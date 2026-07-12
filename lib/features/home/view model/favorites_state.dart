import 'package:equatable/equatable.dart';

class FavoritesState extends Equatable {
  final Set<int> favoriteProductIds;
  final bool isLoading;
  final String? error;

  const FavoritesState({
    this.favoriteProductIds = const {},
    this.isLoading = false,
    this.error,
  });

  bool isFavorite(int productId) => favoriteProductIds.contains(productId);

  FavoritesState copyWith({
    Set<int>? favoriteProductIds,
    bool? isLoading,
    String? error,
  }) {
    return FavoritesState(
      favoriteProductIds: favoriteProductIds ?? this.favoriteProductIds,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [favoriteProductIds, isLoading, error];
}
