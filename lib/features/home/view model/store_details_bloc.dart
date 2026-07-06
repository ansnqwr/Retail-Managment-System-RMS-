import 'package:delni_rms/features/home/Model/ProductCardModel.dart';
import 'package:delni_rms/features/home/Model/StoreProfileModel.dart';
import 'package:delni_rms/features/home/view%20model/store_details_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'store_details_event.dart';
import 'store_details_state.dart';

class StoreDetailsBloc extends Bloc<StoreDetailsEvent, StoreDetailsState> {
  final StoreDetailsRepository repository;
  int _currentPage = 1;
  int _currentStoreId = 0;

  StoreDetailsBloc(this.repository) : super(StoreDetailsLoading()) {
    on<LoadStoreDetails>((event, emit) async {
      emit(StoreDetailsLoading());
      _currentStoreId = event.storeId;
      _currentPage = 1;

      try {
        final results = await Future.wait([
          repository.getStoreOverview(_currentStoreId),
          repository.getStoreProducts(
            _currentStoreId,
            _currentPage,
            'popularity',
          ),
          repository.getStoreProfile(_currentStoreId),
        ]);

 
        final productsData = results[1];
        final productsList =
            (productsData['products'] as List)
                .map((e) => ProductCardModel.fromJson(e))
                .toList();

        final profileModel = StoreProfileModel.fromJson(results[2]);



        emit(
          StoreDetailsLoaded(
            overviewData: results[0],
            products: productsList,
            profileData: profileModel,
            hasMoreProducts: productsData['hasMore'] ?? false,
            isLoadingMore: false,
            currentSort: 'popularity',
          ),
        );
      } catch (e) {
        emit(StoreDetailsError(e.toString()));
      }
    });

    on<SortProducts>((event, emit) async {
      final currentState = state;
      if (currentState is StoreDetailsLoaded) {
        emit(
          currentState.copyWith(isLoadingMore: true, currentSort: event.sortBy),
        );
        _currentPage = 1;

        try {
          final result = await repository.getStoreProducts(
            _currentStoreId,
            _currentPage,
            event.sortBy,
          );
          final newProducts =
              (result['products'] as List)
                  .map((e) => ProductCardModel.fromJson(e))
                  .toList();

          emit(
            currentState.copyWith(
              products: newProducts,
              hasMoreProducts: result['hasMore'] ?? false,
              isLoadingMore: false,
            ),
          );
        } catch (e) {
          emit(StoreDetailsError(e.toString()));
        }
      }
    });

    on<LoadMoreProducts>((event, emit) async {
      final currentState = state;
      if (currentState is StoreDetailsLoaded &&
          currentState.hasMoreProducts &&
          !currentState.isLoadingMore) {
        emit(currentState.copyWith(isLoadingMore: true));
        _currentPage++;

        try {
          final result = await repository.getStoreProducts(
            _currentStoreId,
            _currentPage,
            currentState.currentSort,
          );
          final moreProducts =
              (result['products'] as List)
                  .map((e) => ProductCardModel.fromJson(e))
                  .toList();

          emit(
            currentState.copyWith(
              products: [...currentState.products, ...moreProducts],
              hasMoreProducts: result['hasMore'] ?? false,
              isLoadingMore: false,
            ),
          );
        } catch (e) {
          emit(currentState.copyWith(isLoadingMore: false));
        }
      }
    });
  }
}
