import 'package:equatable/equatable.dart';

abstract class ProductDetailsEvent extends Equatable {
  const ProductDetailsEvent();

  @override
  List<Object?> get props => [];
}

class LoadProductDetails extends ProductDetailsEvent {
  final int productId;
  const LoadProductDetails(this.productId);

  @override
  List<Object?> get props => [productId];
}

class RefreshProductDetails extends ProductDetailsEvent {
  const RefreshProductDetails();
}

class LoadMoreReviews extends ProductDetailsEvent {
  const LoadMoreReviews();
}

class ColorSelected extends ProductDetailsEvent {
  final int colorId;
  const ColorSelected(this.colorId);

  @override
  List<Object?> get props => [colorId];
}

class SizeSelected extends ProductDetailsEvent {
  final String sizeLabel;
  const SizeSelected(this.sizeLabel);

  @override
  List<Object?> get props => [sizeLabel];
}

class QuantityChanged extends ProductDetailsEvent {
  final int quantity;
  const QuantityChanged(this.quantity);

  @override
  List<Object?> get props => [quantity];
}

