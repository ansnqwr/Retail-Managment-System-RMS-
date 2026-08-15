// lib/features/products/view model/ProductDetailsState.dart
import 'package:delni_rms/features/products/model/ProductDetailModel.dart';
import 'package:delni_rms/features/products/model/ProductReviewModel.dart';
import 'package:equatable/equatable.dart';

abstract class ProductDetailsState extends Equatable {
  const ProductDetailsState();

  @override
  List<Object?> get props => [];
}

class ProductDetailsLoading extends ProductDetailsState {
  const ProductDetailsLoading();
}

class ProductDetailsError extends ProductDetailsState {
  final String message;
  const ProductDetailsError(this.message);

  @override
  List<Object?> get props => [message];
}

class ProductDetailsLoaded extends ProductDetailsState {
  final ProductDetailModel product;
  final ProductReviewsResponse reviews;
  final List<SimilarProductModel> similarProducts;
  final List<SimilarProductModel> recommendedProducts;
  final int variantImageIndex;

  /// Currently selected SKU values: {"Size": "256GB", "colors": "Titanium Black"}
  final Map<String, String> selectedSkus;
  final int quantity;

  final bool isLoadingMoreReviews;
  final bool isAddingToBag;
  final bool isTogglingFavorite;
  final bool isLoadingVariant;

  const ProductDetailsLoaded({
    required this.product,
    required this.reviews,
    required this.similarProducts,
    required this.recommendedProducts,
    this.selectedSkus = const {},
    this.quantity = 1,
    this.isLoadingMoreReviews = false,
    this.isAddingToBag = false,
    this.isTogglingFavorite = false,
    this.isLoadingVariant = false,
    this.variantImageIndex = 0,
  });

  ProductDetailsLoaded copyWith({
    ProductDetailModel? product,
    ProductReviewsResponse? reviews,
    List<SimilarProductModel>? similarProducts,
    List<SimilarProductModel>? recommendedProducts,
    Map<String, String>? selectedSkus,
    int? quantity,
    bool? isLoadingMoreReviews,
    bool? isAddingToBag,
    bool? isTogglingFavorite,
    bool? isLoadingVariant,
    int? variantImageIndex,
  }) {
    return ProductDetailsLoaded(
      product: product ?? this.product,
      reviews: reviews ?? this.reviews,
      similarProducts: similarProducts ?? this.similarProducts,
      recommendedProducts: recommendedProducts ?? this.recommendedProducts,
      selectedSkus: selectedSkus ?? this.selectedSkus,
      quantity: quantity ?? this.quantity,
      isLoadingMoreReviews: isLoadingMoreReviews ?? this.isLoadingMoreReviews,
      isAddingToBag: isAddingToBag ?? this.isAddingToBag,
      isTogglingFavorite: isTogglingFavorite ?? this.isTogglingFavorite,
      isLoadingVariant: isLoadingVariant ?? this.isLoadingVariant,
      variantImageIndex: variantImageIndex ?? this.variantImageIndex,
    );
  }

  @override
  List<Object?> get props => [
    product.productId,
    product.isFavorite,
    product.stockCount,
    reviews.reviews.length,
    similarProducts,
    recommendedProducts,
    selectedSkus,
    quantity,
    isLoadingMoreReviews,
    isAddingToBag,
    isTogglingFavorite,
    isLoadingVariant,
    variantImageIndex,
  ];
}
