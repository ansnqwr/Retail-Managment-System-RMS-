import 'package:equatable/equatable.dart';

class CartItem extends Equatable {
  final int? cartId;
  final int? productId;
  final String? name;
  final int? price;
  final String? currency;
  final int? quantity;
  final String? selectedColor;
  final String? selectedSize;
  final String? imageUrl;

  const CartItem({
    this.cartId,
    this.productId,
    this.name,
    this.price,
    this.currency,
    this.quantity,
    this.selectedColor,
    this.selectedSize,
    this.imageUrl,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
    cartId: json['cart_id'] as int?,
    productId: json['product_id'] as int?,
    name: json['name'] as String?,
    price: json['price'] as int?,
    currency: json['currency'] as String?,
    quantity: json['quantity'] as int?,
    selectedColor: json['selected_color'] as String?,
    selectedSize: json['selected_size'] as String?,
    imageUrl: json['image_url'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'cart_id': cartId,
    'product_id': productId,
    'name': name,
    'price': price,
    'currency': currency,
    'quantity': quantity,
    'selected_color': selectedColor,
    'selected_size': selectedSize,
    'image_url': imageUrl,
  };

  @override
  List<Object?> get props {
    return [
      cartId,
      productId,
      name,
      price,
      currency,
      quantity,
      selectedColor,
      selectedSize,
      imageUrl,
    ];
  }
}
