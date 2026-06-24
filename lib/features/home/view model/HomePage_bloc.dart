import 'package:flutter_bloc/flutter_bloc.dart';
import 'HomePage_event.dart';
import 'HomePage_repository.dart';
import 'HomePage_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository _homeRepository;

  bool _isGuest = false;

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

    emit(current.copyWith(selectedCategoryIndex: event.categoryIndex));

    try {
      if (event.categoryId == 1) {
        final products = await _homeRepository.fetchProducts(
          businessType: 'Just For You',
          searchQuery: current.homeSearchQuery,
          filters: {},
          subCategoryId: null,
          page: 1,
          limit: 10,
        );
        emit(
          current.copyWith(
            selectedCategoryIndex: event.categoryIndex,
            justForYouProducts: products,
            justForYouCurrentPage: 1,
            justForYouHasMoreData: products.length >= 10,
          ),
        );
      } else {
        final products = await _homeRepository.fetchProducts(
          businessType: 'Just For You',
          searchQuery: current.homeSearchQuery,
          filters: {'category': event.categoryId.toString()},
          subCategoryId: null,
          page: 1,
          limit: 10,
        );
        emit(
          current.copyWith(
            selectedCategoryIndex: event.categoryIndex,
            justForYouProducts: products,
            justForYouCurrentPage: 1,
            justForYouHasMoreData: products.length >= 10,
          ),
        );
      }
    } on HomeRepositoryException catch (e) {
      emit(current.copyWith(selectedCategoryIndex: event.categoryIndex));
      emit(HomeError(e.message));
      emit(current.copyWith(selectedCategoryIndex: event.categoryIndex));
    } catch (e) {
      emit(current.copyWith(selectedCategoryIndex: event.categoryIndex));
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
      if (current.selectedCategoryIndex > 0 && current.categories.isNotEmpty) {
        final selectedCategory =
            current.categories[current.selectedCategoryIndex];
        filters['category'] = selectedCategory.id.toString();
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
      if (event.isSearchingProducts) {
        final products = await _homeRepository.fetchProducts(
          businessType: 'Just For You',
          searchQuery: trimmedQuery,
          filters: {},
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
          filters: {},
          subCategoryId: null,
          page: 1,
          limit: 10,
        );
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
      final products = await _homeRepository.fetchProducts(
        businessType: 'Just For You',
        searchQuery: null,
        filters: {},
        subCategoryId: null,
        page: 1,
        limit: 10,
      );

      emit(
        current.copyWith(
          homeSearchQuery: null,
          isSearchingProducts: true,
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
