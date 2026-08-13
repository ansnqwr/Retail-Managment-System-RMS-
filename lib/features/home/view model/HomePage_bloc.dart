import 'package:flutter_bloc/flutter_bloc.dart';
import '../Model/ProductCardModel.dart';
import '../Model/StoreCardItem.dart';
import 'HomePage_event.dart';
import 'HomePage_repository.dart';
import 'HomePage_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository _homeRepository;

  bool _isGuest = false;
  int? _selectedCategoryId;

  HomeBloc({required HomeRepository homeRepository})
    : _homeRepository = homeRepository,
      super(const HomeInitial()) {
    on<HomeLoadRequested>(_onLoadRequested);
    on<HomeCategorySelected>(_onCategorySelected);
    on<HomeRefreshRequested>(_onRefreshRequested);
    on<HomeLoadMoreJustForYouRequested>(_onLoadMoreJustForYouRequested);
    on<HomeSearchSubmitted>(_onSearchSubmitted);
    on<HomeSearchToggleChanged>(_onSearchToggleChanged);
    on<HomeSearchCleared>(_onSearchCleared);
    on<HomeSectionSeeAllTapped>(_onSectionSeeAllTapped);
    on<HomeProductTapped>(_onProductTapped);
    on<HomeStoreTapped>(_onStoreTapped);
    on<HomeSettingsTapped>(_onSettingsTapped);
    on<HomeNotificationsTapped>(_onNotificationsTapped);
    on<HomeSignUpTapped>(_onSignUpTapped);
  }

  Future<void> _onLoadRequested(
    HomeLoadRequested event,
    Emitter<HomeState> emit,
  ) async {
    _isGuest = event.isGuest;
    _selectedCategoryId = null;

    emit(const HomeLoading());

    try {
      final data = await _homeRepository.fetchAllHomeData();

      emit(
        HomeLoaded(
          ads: data.ads,
          categories: data.categories,
          selectedCategoryIndex: 0,
          selectedSeeAllIndex: 0,
          trendingProducts: data.trendingProducts,
          onSaleProducts: data.onSaleProducts,
          mostBoughtProducts: data.mostBoughtProducts,
          newestProducts: data.newestProducts,
          brandStores: data.brandStores,
          nearbyStores: data.nearbyStores,
          justForYouProducts: data.justForYouProducts,
          justForYouHasMoreData: data.justForYouProducts.length >= 10,
          justForYouCurrentPage: 1,
          isLoadingMoreJustForYou: false,
          homeSearchQuery: null,
          isSearchingProducts: true,
          isGuest: event.isGuest,
          selectedCategoryId: null,
          selectedCategoryName: null,
        ),
      );
    } on HomeRepositoryException catch (e) {
      emit(HomeError(e.message));
    } catch (e) {
      emit(HomeError('Unexpected error: $e'));
    }
  }

  Future<void> _onCategorySelected(
    HomeCategorySelected event,
    Emitter<HomeState> emit,
  ) async {
    if (state is! HomeLoaded) return;

    final current = state as HomeLoaded;

    final isAllCategory = event.categoryId == 0;
    _selectedCategoryId = isAllCategory ? null : event.categoryId;

    final selectedCategory =
        isAllCategory
            ? null
            : current.categories.firstWhere(
              (c) => c.id == event.categoryId,
              orElse: () => current.categories[event.categoryIndex],
            );
    final categoryName = isAllCategory ? null : selectedCategory?.title;

    emit(
      current.copyWith(
        selectedCategoryIndex: event.categoryIndex,
        selectedCategoryId: isAllCategory ? null : event.categoryId,
        selectedCategoryName: categoryName,
        isLoadingMoreJustForYou: true,
      ),
    );

    try {
      final filters =
          isAllCategory
              ? <String, dynamic>{}
              : <String, dynamic>{'category': event.categoryId};

      final results = await Future.wait([
        _homeRepository.fetchProducts(
          businessType: 'Trending',
          searchQuery: null,
          filters: filters,
          subCategoryId: null,
          page: 1,
          limit: 10,
        ),
        _homeRepository.fetchProducts(
          businessType: 'On Sale',
          searchQuery: null,
          filters: filters,
          subCategoryId: null,
          page: 1,
          limit: 10,
        ),
        _homeRepository.fetchProducts(
          businessType: 'Newest',
          searchQuery: null,
          filters: filters,
          subCategoryId: null,
          page: 1,
          limit: 10,
        ),
        _homeRepository.fetchStores(
          businessType: 'Brands',
          searchQuery: null,
          filters: filters,
          subCategoryId: null,
          page: 1,
          limit: 10,
        ),
        _homeRepository.fetchStores(
          businessType: 'Stores Nearby',
          searchQuery: null,
          filters: filters,
          subCategoryId: null,
          page: 1,
          limit: 10,
        ),
        _homeRepository.fetchProducts(
          businessType: 'Just For You',
          searchQuery: null,
          filters: filters,
          subCategoryId: null,
          page: 1,
          limit: 10,
        ),
      ]);

      emit(
        current.copyWith(
          selectedCategoryIndex: event.categoryIndex,
          selectedCategoryId: isAllCategory ? null : event.categoryId,
          selectedCategoryName: categoryName,
          trendingProducts: results[0] as List<ProductCardModel>,
          onSaleProducts: results[1] as List<ProductCardModel>,
          newestProducts: results[2] as List<ProductCardModel>,
          brandStores: results[3] as List<StoreCardModel>,
          nearbyStores: results[4] as List<StoreCardModel>,
          justForYouProducts: results[5] as List<ProductCardModel>,
          justForYouCurrentPage: 1,
          justForYouHasMoreData:
              (results[5] as List<ProductCardModel>).length >= 10,
          isLoadingMoreJustForYou: false,
        ),
      );
    } on HomeRepositoryException catch (e) {
      emit(
        current.copyWith(
          selectedCategoryIndex: event.categoryIndex,
          selectedCategoryId: isAllCategory ? null : event.categoryId,
          selectedCategoryName: categoryName,
          isLoadingMoreJustForYou: false,
        ),
      );
      emit(HomeError(e.message));
      emit(
        current.copyWith(
          selectedCategoryIndex: event.categoryIndex,
          selectedCategoryId: isAllCategory ? null : event.categoryId,
          selectedCategoryName: categoryName,
          isLoadingMoreJustForYou: false,
        ),
      );
    } catch (e) {
      emit(
        current.copyWith(
          selectedCategoryIndex: event.categoryIndex,
          selectedCategoryId: isAllCategory ? null : event.categoryId,
          selectedCategoryName: categoryName,
          isLoadingMoreJustForYou: false,
        ),
      );
    }
  }

  Future<void> _onRefreshRequested(
    HomeRefreshRequested event,
    Emitter<HomeState> emit,
  ) async {
    add(HomeLoadRequested(_isGuest));
  }

  Future<void> _onLoadMoreJustForYouRequested(
    HomeLoadMoreJustForYouRequested event,
    Emitter<HomeState> emit,
  ) async {
    if (state is! HomeLoaded) return;

    final current = state as HomeLoaded;
    if (!current.justForYouHasMoreData || current.isLoadingMoreJustForYou) {
      return;
    }

    final nextPage = current.justForYouCurrentPage + 1;

    emit(current.copyWith(isLoadingMoreJustForYou: true));

    try {
      Map<String, dynamic> filters = {};
      if (_selectedCategoryId != null) {
        filters['category'] = _selectedCategoryId;
      }

      final newProducts = await _homeRepository.fetchProducts(
        businessType: 'Just For You',
        searchQuery: current.homeSearchQuery,
        filters: filters,
        subCategoryId: null,
        page: nextPage,
        limit: 10,
      );

      final allProducts = [...current.justForYouProducts, ...newProducts];

      emit(
        current.copyWith(
          justForYouProducts: allProducts,
          justForYouCurrentPage: nextPage,
          justForYouHasMoreData: newProducts.length >= 10,
          isLoadingMoreJustForYou: false,
        ),
      );
    } on HomeRepositoryException catch (e) {
      emit(current.copyWith(isLoadingMoreJustForYou: false));
      emit(HomeError(e.message));
      emit(current.copyWith(isLoadingMoreJustForYou: false));
    } catch (e) {
      emit(current.copyWith(isLoadingMoreJustForYou: false));
    }
  }

  Future<void> _onSearchSubmitted(
    HomeSearchSubmitted event,
    Emitter<HomeState> emit,
  ) async {
    if (state is! HomeLoaded) return;

    final current = state as HomeLoaded;
    final trimmedQuery = event.query.trim();

    if (trimmedQuery.isEmpty) {
      add(const HomeSearchCleared());
      return;
    }

    emit(
      current.copyWith(
        homeSearchQuery: trimmedQuery,
        isSearchingProducts: event.isSearchingProducts,
      ),
    );

    try {
      Map<String, dynamic> filters = {};
      if (_selectedCategoryId != null) {
        filters['category'] = _selectedCategoryId;
      }

      if (event.isSearchingProducts) {
        final products = await _homeRepository.fetchProducts(
          businessType: 'Just For You',
          searchQuery: trimmedQuery,
          filters: filters,
          subCategoryId: null,
          page: 1,
          limit: 10,
        );
        emit(
          current.copyWith(
            homeSearchQuery: trimmedQuery,
            isSearchingProducts: true,
            justForYouProducts: products,
            justForYouCurrentPage: 1,
            justForYouHasMoreData: products.length >= 10,
          ),
        );
      } else {
        final stores = await _homeRepository.fetchStores(
          businessType: 'Stores Nearby',
          searchQuery: trimmedQuery,
          filters: filters,
          subCategoryId: null,
          page: 1,
          limit: 10,
        );
        // TODO: Add justForYouStores to HomeLoaded if you want to display stores on home
        emit(
          current.copyWith(
            homeSearchQuery: trimmedQuery,
            isSearchingProducts: false,
            justForYouProducts: [],
            justForYouCurrentPage: 1,
            justForYouHasMoreData: false,
          ),
        );
      }
    } on HomeRepositoryException catch (e) {
      emit(HomeError(e.message));
      emit(
        current.copyWith(
          homeSearchQuery: trimmedQuery,
          isSearchingProducts: event.isSearchingProducts,
        ),
      );
    } catch (e) {
      emit(
        current.copyWith(
          homeSearchQuery: trimmedQuery,
          isSearchingProducts: event.isSearchingProducts,
        ),
      );
    }
  }

  void _onSearchToggleChanged(
    HomeSearchToggleChanged event,
    Emitter<HomeState> emit,
  ) {
    if (state is! HomeLoaded) return;
    final current = state as HomeLoaded;
    emit(current.copyWith(isSearchingProducts: event.isSearchingProducts));
  }

  Future<void> _onSearchCleared(
    HomeSearchCleared event,
    Emitter<HomeState> emit,
  ) async {
    if (state is! HomeLoaded) return;

    final current = state as HomeLoaded;

    try {
      Map<String, dynamic> filters = {};
      if (_selectedCategoryId != null) {
        filters['category'] = _selectedCategoryId;
      }

      final products = await _homeRepository.fetchProducts(
        businessType: 'Just For You',
        searchQuery: null,
        filters: filters,
        subCategoryId: null,
        page: 1,
        limit: 10,
      );

      emit(
        current.copyWith(
          homeSearchQuery: null,
          isSearchingProducts: current.isSearchingProducts,
          justForYouProducts: products,
          justForYouCurrentPage: 1,
          justForYouHasMoreData: products.length >= 10,
        ),
      );
    } catch (e) {
      emit(current.copyWith(homeSearchQuery: null));
    }
  }

  void _onSectionSeeAllTapped(
    HomeSectionSeeAllTapped event,
    Emitter<HomeState> emit,
  ) {
    if (state is! HomeLoaded) return;
    final current = state as HomeLoaded;
    emit(current.copyWith(selectedSeeAllIndex: event.sectionId));
  }

  void _onProductTapped(HomeProductTapped event, Emitter<HomeState> emit) {}

  void _onStoreTapped(HomeStoreTapped event, Emitter<HomeState> emit) {}

  void _onSettingsTapped(HomeSettingsTapped event, Emitter<HomeState> emit) {}

  void _onNotificationsTapped(
    HomeNotificationsTapped event,
    Emitter<HomeState> emit,
  ) {}

  void _onSignUpTapped(HomeSignUpTapped event, Emitter<HomeState> emit) {}
}
