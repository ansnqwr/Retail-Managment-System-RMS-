import 'package:delni_rms/features/home/Model/ProductCardModel.dart';
import 'package:delni_rms/features/stores/model/StoreProfileModel.dart';
import 'package:delni_rms/features/stores/view%20model/store_details_repository.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/widgets/ImageHelper.dart';
import '../../auth/data/models/Repository/signin_repository.dart';
import 'store_details_event.dart';
import 'store_details_state.dart';

class StoreDetailsBloc extends Bloc<StoreDetailsEvent, StoreDetailsState> {
  final StoreDetailsRepository repository;

  int _currentPage = 1;
  int _currentStoreId = 0;

  StoreDetailsBloc(this.repository) : super(StoreDetailsLoading()) {
    on<LoadStoreDetails>(_loadStoreDetails);
    on<SortProducts>(_sortProducts);
    on<LoadMoreProducts>(_loadMoreProducts);
  }

  Future<void> _loadStoreDetails(
    LoadStoreDetails event,
    Emitter<StoreDetailsState> emit,
  ) async {
    emit(StoreDetailsLoading());

    _currentStoreId = event.storeId;
    _currentPage = 1;

    try {
      final results = await Future.wait([
        repository.getStoreOverview(_currentStoreId),
        repository.getStoreProducts(
          _currentStoreId,
          _currentPage,
          'popularity'.tr(),
        ),
        repository.getStoreProfile(_currentStoreId),
      ]);

      final overviewData = results[0];
      final productsData = results[1];
      final profileData = results[2];

      final rawImageUrl = overviewData['imageUrl'] as String? ?? '';
      overviewData['imageUrl'] = getImageUrl(rawImageUrl);

      final overview = overviewData['overview'] as Map<String, dynamic>?;
      if (overview != null) {
        final rawBanner = overview['bannerUrl'] as String? ?? '';
        overview['bannerUrl'] = getImageUrl(rawBanner);
      }

      final products =
          (productsData['products'] as List? ?? [])
              .whereType<Map<String, dynamic>>()
              .map(ProductCardModel.fromJson)
              .toList();

      final profileModel = StoreProfileModel.fromJson(profileData);

      emit(
        StoreDetailsLoaded(
          overviewData: overviewData,
          products: products,
          profileData: profileModel,

          // THIS IS IMPORTANT
          selectedBranch: event.selectedBranch,

          hasMoreProducts: productsData['hasMore'] == true,

          isLoadingMore: false,

          currentSort: 'popularity'.tr(),
        ),
      );
    } catch (e, stack) {
      print('BLOC ERROR: $e');
      print('BLOC STACK: $stack');
      emit(StoreDetailsError(e.toString()));
    }
    // catch (e) {
    //   emit(StoreDetailsError(e.toString()));
    // }
  }

  Future<void> _sortProducts(
    SortProducts event,
    Emitter<StoreDetailsState> emit,
  ) async {
    final currentState = state;

    if (currentState is! StoreDetailsLoaded) {
      return;
    }

    emit(currentState.copyWith(isLoadingMore: true));

    _currentPage = 1;

    try {
      final result = await repository.getStoreProducts(
        _currentStoreId,
        _currentPage,
        event.sortBy,
      );

      final newProducts =
          (result['products'] as List? ?? [])
              .whereType<Map<String, dynamic>>()
              .map(ProductCardModel.fromJson)
              .toList();

      final latestState = state;

      if (latestState is StoreDetailsLoaded) {
        emit(
          latestState.copyWith(
            products: newProducts,
            hasMoreProducts: result['hasMore'] == true,
            isLoadingMore: false,
            currentSort: event.sortBy,
          ),
        );
      }
    } catch (e) {
      final latestState = state;

      if (latestState is StoreDetailsLoaded) {
        emit(latestState.copyWith(isLoadingMore: false));
      } else {
        emit(StoreDetailsError(e.toString()));
      }
    }
  }

  Future<void> _loadMoreProducts(
    LoadMoreProducts event,
    Emitter<StoreDetailsState> emit,
  ) async {
    final currentState = state;

    if (currentState is! StoreDetailsLoaded ||
        !currentState.hasMoreProducts ||
        currentState.isLoadingMore) {
      return;
    }

    emit(currentState.copyWith(isLoadingMore: true));

    _currentPage++;

    try {
      final result = await repository.getStoreProducts(
        _currentStoreId,
        _currentPage,
        currentState.currentSort,
      );

      final moreProducts =
          (result['products'] as List? ?? [])
              .whereType<Map<String, dynamic>>()
              .map(ProductCardModel.fromJson)
              .toList();

      final latestState = state;

      if (latestState is StoreDetailsLoaded) {
        emit(
          latestState.copyWith(
            products: [...latestState.products, ...moreProducts],
            hasMoreProducts: result['hasMore'] == true,
            isLoadingMore: false,
          ),
        );
      }
    } catch (e) {
      _currentPage--;

      final latestState = state;

      if (latestState is StoreDetailsLoaded) {
        emit(latestState.copyWith(isLoadingMore: false));
      }
    }
  }
}
