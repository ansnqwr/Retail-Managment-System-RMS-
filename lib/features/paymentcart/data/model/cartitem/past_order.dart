import 'package:equatable/equatable.dart';

class PastOrder extends Equatable {
  final int? orderId;
  final int? productId;
  final String? name;
  final int? price;
  final String? currency;
  final String? selectedColor;
  final String? selectedSize;
  final String? imageUrl;

  const PastOrder({
    this.orderId,
    this.productId,
    this.name,
    this.price,
    this.currency,
    this.selectedColor,
    this.selectedSize,
    this.imageUrl,
  });

  factory PastOrder.fromJson(Map<String, dynamic> json) => PastOrder(
    orderId: json['order_id'] as int?,
    productId: json['product_id'] as int?,
    name: json['name'] as String?,
    price: json['price'] as int?,
    currency: json['currency'] as String?,
    selectedColor: json['selected_color'] as String?,
    selectedSize: json['selected_size'] as String?,
    imageUrl: json['image_url'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'order_id': orderId,
    'product_id': productId,
    'name': name,
    'price': price,
    'currency': currency,
    'selected_color': selectedColor,
    'selected_size': selectedSize,
    'image_url': imageUrl,
  };

  @override
  List<Object?> get props {
    return [
      orderId,
      productId,
      name,
      price,
      currency,
      selectedColor,
      selectedSize,
      imageUrl,
    ];
  }
}
