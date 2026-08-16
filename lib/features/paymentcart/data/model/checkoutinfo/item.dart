import 'package:equatable/equatable.dart';

class Item extends Equatable {
  final int? cartItemId;
  final int? productId;
  final String? name;
  final String? image;
  final int? price;
  final String? currency;
  final int? quantity;
  final dynamic size;
  final dynamic color;

  const Item({
    this.cartItemId,
    this.productId,
    this.name,
    this.image,
    this.price,
    this.currency,
    this.quantity,
    this.size,
    this.color,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    cartItemId: json['cart_item_id'] as int?,
    productId: json['product_id'] as int?,
    name: json['name'] as String?,
    image: json['image'] as String?,
    price: json['price'] as int?,
    currency: json['currency'] as String?,
    quantity: json['quantity'] as int?,
    size: json['size'] as dynamic,
    color: json['color'] as dynamic,
  );

  Map<String, dynamic> toJson() => {
    'cart_item_id': cartItemId,
    'product_id': productId,
    'name': name,
    'image': image,
    'price': price,
    'currency': currency,
    'quantity': quantity,
    'size': size,
    'color': color,
  };

  @override
  List<Object?> get props {
    return [
      cartItemId,
      productId,
      name,
      image,
      price,
      currency,
      quantity,
      size,
      color,
    ];
  }
}
