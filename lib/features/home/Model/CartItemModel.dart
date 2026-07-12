class CartItemModel {
  // cartItemId is null until the backend has assigned one (i.e. while the
  // item still only exists in local/offline storage).
  final String? cartItemId;
  final int productId;
  final String name;
  final String imageUrl;
  final double price;
  final String currency;
  final int? colorId;
  final String? colorName;
  final String? colorHex;
  final String? size;
  final int quantity;

  CartItemModel({
    this.cartItemId,
    required this.productId,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.currency,
    this.colorId,
    this.colorName,
    this.colorHex,
    this.size,
    required this.quantity,
  });

  double get subtotal => price * quantity;

  /// Two cart lines are "the same line" if they're the same product with
  /// the same color + size, so adding it again just bumps the quantity
  /// instead of creating a duplicate row - matching typical cart behavior.
  bool isSameVariant(CartItemModel other) {
    return productId == other.productId &&
        colorId == other.colorId &&
        size == other.size;
  }

  CartItemModel copyWith({String? cartItemId, int? quantity}) {
    return CartItemModel(
      cartItemId: cartItemId ?? this.cartItemId,
      productId: productId,
      name: name,
      imageUrl: imageUrl,
      price: price,
      currency: currency,
      colorId: colorId,
      colorName: colorName,
      colorHex: colorHex,
      size: size,
      quantity: quantity ?? this.quantity,
    );
  }

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      cartItemId: json['cart_item_id']?.toString(),
      productId: json['product_id'] ?? 0,
      name: json['name'] ?? '',
      imageUrl: json['image_url'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      currency: json['currency'] ?? '',
      colorId: json['color_id'],
      colorName: json['color_name'],
      colorHex: json['color_hex'],
      size: json['size'],
      quantity: json['quantity'] ?? 1,
    );
  }

  Map<String, dynamic> toAddToCartJson() {
    return {
      'product_id': productId,
      if (colorId != null) 'color_id': colorId,
      if (size != null) 'size': size,
      'quantity': quantity,
    };
  }
}
