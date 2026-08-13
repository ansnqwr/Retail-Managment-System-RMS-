import 'package:delni_rms/features/favorites/view%20model/FavoritesRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'favorites_event.dart';
import 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final FavoritesRepository favoritesRepository;

  FavoritesBloc(this.favoritesRepository) : super(const FavoritesState()) {
    on<FavoritesStarted>(_onStarted);
    on<FavoriteToggled>(_onToggled);
  }

  Future<void> _onStarted(
    FavoritesStarted event,
    Emitter<FavoritesState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final ids = await favoritesRepository.getFavoriteIds();
      emit(state.copyWith(favoriteProductIds: ids, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onToggled(
    FavoriteToggled event,
    Emitter<FavoritesState> emit,
  ) async {
    final optimisticIds = Set<int>.from(state.favoriteProductIds);
    event.currentIsFavorite
        ? optimisticIds.remove(event.productId)
        : optimisticIds.add(event.productId);
    emit(state.copyWith(favoriteProductIds: optimisticIds));

    try {
      final newState = await favoritesRepository.toggleFavorite(
        event.productId,
        event.currentIsFavorite,
      );
      final confirmedIds = Set<int>.from(state.favoriteProductIds);
      newState
          ? confirmedIds.add(event.productId)
          : confirmedIds.remove(event.productId);
      emit(state.copyWith(favoriteProductIds: confirmedIds));
    } catch (e) {
      // revert optimistic update on failure
      emit(
        state.copyWith(
          favoriteProductIds: Set<int>.from(state.favoriteProductIds)
            ..removeWhere(
              (id) => id == event.productId && !event.currentIsFavorite,
            ),
          error: e.toString(),
        ),
      );
    }
  }
}
