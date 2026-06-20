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
    if (event.categoryId == 1) {
      try {
        final products = await _homeRepository.fetchJustForYou();
        emit(
          current.copyWith(
            selectedCategoryIndex: event.categoryIndex,
            justForYouProducts: products,
          ),
        );
      } catch (e) {
        emit(current.copyWith(selectedCategoryIndex: event.categoryIndex));
      }
    } else {
      try {
        final products = await _homeRepository.fetchProductsByCategory(
          event.categoryId,
        );
        emit(
          current.copyWith(
            selectedCategoryIndex: event.categoryIndex,
            justForYouProducts: products,
          ),
        );
      } catch (e) {
        emit(current.copyWith(selectedCategoryIndex: event.categoryIndex));
      }
    }
  }

  Future<void> _onRefreshRequested(
    HomeRefreshRequested event,
    Emitter<HomeState> emit,
  ) async {
    add(HomeLoadRequested(_isGuest));
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
