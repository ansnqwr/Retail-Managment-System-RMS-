// lib/features/favorites/presentation/bloc/favorites_state.dart
import 'package:equatable/equatable.dart';
import '../model/favoritesModel.dart';

class FavoritesState extends Equatable {
  final List<Product> products;
  final Set<int> favoriteProductIds;
  final bool isLoading;
  final String? error;

  const FavoritesState({
    this.products = const [],
    this.favoriteProductIds = const {},
    this.isLoading = false,
    this.error,
  });

  bool isFavorite(int productId) => favoriteProductIds.contains(productId);

  FavoritesState copyWith({
    List<Product>? products,
    Set<int>? favoriteProductIds,
    bool? isLoading,
    String? error,
  }) {
    return FavoritesState(
      products: products ?? this.products,
      favoriteProductIds: favoriteProductIds ?? this.favoriteProductIds,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [products, favoriteProductIds, isLoading, error];
}
