// lib/features/products/view model/ProductDetailsEvent.dart
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

/// Called whenever the user taps a SKU option (e.g. "256GB" under "Size").
class SkuFactorSelected extends ProductDetailsEvent {
  final String factorKey;
  final String value;
  const SkuFactorSelected(this.factorKey, this.value);

  @override
  List<Object?> get props => [factorKey, value];
}

/// Internal event fired automatically when ALL SKU factors are selected.
class LoadProductVariant extends ProductDetailsEvent {
  const LoadProductVariant();
}

class QuantityChanged extends ProductDetailsEvent {
  final int quantity;
  const QuantityChanged(this.quantity);

  @override
  List<Object?> get props => [quantity];
}
