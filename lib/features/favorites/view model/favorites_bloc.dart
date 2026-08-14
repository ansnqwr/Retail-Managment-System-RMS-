// lib/features/favorites/presentation/bloc/favorites_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../model/favoritesModel.dart';
import 'FavoritesRepository.dart';
import 'favorites_event.dart';
import 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final FavoritesRepository favoritesRepository;

  FavoritesBloc(this.favoritesRepository) : super(const FavoritesState()) {
    on<FavoritesStarted>(_onStarted);
    on<FavoriteToggled>(_onToggled);
    on<FavoritesProductTapped>(_onTapped);
    on<FavoritesRefreshed>(_onStarted);
  }

  Future<void> _onStarted(
    FavoritesEvent event,
    Emitter<FavoritesState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final products = await favoritesRepository.getWishlist();
      final ids = products.map((p) => p.id).toSet();
      emit(
        state.copyWith(
          products: products,
          favoriteProductIds: ids,
          isLoading: false,
        ),
      );
    } catch (e) {
      final localIds = await favoritesRepository.getFavoriteIds();
      emit(
        state.copyWith(
          favoriteProductIds: localIds,
          isLoading: false,
          error: e.toString(),
        ),
      );
    }
  }

  Future<void> _onToggled(
    FavoriteToggled event,
    Emitter<FavoritesState> emit,
  ) async {
    // 1. Optimistic update
    final optimisticIds = Set<int>.from(state.favoriteProductIds);
    final optimisticProducts = List<Product>.from(state.products);

    if (event.currentIsFavorite) {
      optimisticIds.remove(event.productId);
      optimisticProducts.removeWhere((p) => p.id == event.productId);
    } else {
      optimisticIds.add(event.productId);
    }

    emit(
      state.copyWith(
        favoriteProductIds: optimisticIds,
        products: optimisticProducts,
      ),
    );

    // 2. Call API
    try {
      final newIsFavorite = await favoritesRepository.toggleFavorite(
        event.productId,
        event.currentIsFavorite,
      );

      final confirmedIds = Set<int>.from(state.favoriteProductIds);
      if (newIsFavorite) {
        confirmedIds.add(event.productId);
      } else {
        confirmedIds.remove(event.productId);
      }

      emit(state.copyWith(favoriteProductIds: confirmedIds));
    } catch (e) {
      // Revert
      final revertedIds = Set<int>.from(state.favoriteProductIds);
      if (event.currentIsFavorite) {
        revertedIds.add(event.productId);
      } else {
        revertedIds.remove(event.productId);
      }

      emit(
        state.copyWith(favoriteProductIds: revertedIds, error: e.toString()),
      );
    }
  }

  Future<void> _onTapped(
    FavoritesProductTapped event,
    Emitter<FavoritesState> emit,
  ) async {
    // Optional side-effects only
    // e.g. analytics, logging, etc.
    // No state change needed for navigation
  }
}
