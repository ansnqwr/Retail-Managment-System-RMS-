// lib/features/favorites/presentation/bloc/favorites_event.dart
import 'package:equatable/equatable.dart';

abstract class FavoritesEvent extends Equatable {
  const FavoritesEvent();

  @override
  List<Object?> get props => [];
}

class FavoritesStarted extends FavoritesEvent {
  const FavoritesStarted();
}

class FavoriteToggled extends FavoritesEvent {
  final int productId;
  final bool currentIsFavorite;
  const FavoriteToggled(this.productId, this.currentIsFavorite);

  @override
  List<Object?> get props => [productId, currentIsFavorite];
}

/// Optional – useful if you want to force a full refresh later

class FavoritesProductTapped extends FavoritesEvent {
  final int productId;

  const FavoritesProductTapped(this.productId);
  @override
  List<Object?> get props => [productId];
}

class FavoritesRefreshed extends FavoritesEvent {
  const FavoritesRefreshed();
}
