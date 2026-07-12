import 'package:delni_rms/features/home/Model/ProductDetailModel.dart';
import 'package:delni_rms/features/home/Model/ProductReviewModel.dart';
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

  final int? selectedColorId;
  final String? selectedSize;
  final int quantity;

  final bool isLoadingMoreReviews;
  final bool isAddingToBag;
  final bool isTogglingFavorite;

  const ProductDetailsLoaded({
    required this.product,
    required this.reviews,
    required this.similarProducts,
    required this.recommendedProducts,
    this.selectedColorId,
    this.selectedSize,
    this.quantity = 1,
    this.isLoadingMoreReviews = false,
    this.isAddingToBag = false,
    this.isTogglingFavorite = false,
  });

  ProductDetailsLoaded copyWith({
    ProductDetailModel? product,
    ProductReviewsResponse? reviews,
    List<SimilarProductModel>? similarProducts,
    List<SimilarProductModel>? recommendedProducts,
    int? selectedColorId,
    String? selectedSize,
    int? quantity,
    bool? isLoadingMoreReviews,
    bool? isAddingToBag,
    bool? isTogglingFavorite,
  }) {
    return ProductDetailsLoaded(
      product: product ?? this.product,
      reviews: reviews ?? this.reviews,
      similarProducts: similarProducts ?? this.similarProducts,
      recommendedProducts: recommendedProducts ?? this.recommendedProducts,
      selectedColorId: selectedColorId ?? this.selectedColorId,
      selectedSize: selectedSize ?? this.selectedSize,
      quantity: quantity ?? this.quantity,
      isLoadingMoreReviews: isLoadingMoreReviews ?? this.isLoadingMoreReviews,
      isAddingToBag: isAddingToBag ?? this.isAddingToBag,
      isTogglingFavorite: isTogglingFavorite ?? this.isTogglingFavorite,
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
    selectedColorId,
    selectedSize,
    quantity,
    isLoadingMoreReviews,
    isAddingToBag,
    isTogglingFavorite,
  ];
}
