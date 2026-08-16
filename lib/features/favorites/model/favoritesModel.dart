// lib/features/favorites/data/models/product_model.dart
class Product {
  final int id;
  final int? subCategoryId;
  final int? brandId;
  final int? storeId;
  final int? ownerId;
  final String name;
  final String? description;
  final String? specifications;
  final String? story;
  final String price; // kept as String because API returns "1850000.00"
  final String? oldPrice;
  final int quantity;
  final String image;
  final bool isTrending;
  final bool isNewest;
  final bool isOnSale;
  final String discount;
  final bool isMostBought;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Product({
    required this.id,
    this.subCategoryId,
    this.brandId,
    this.storeId,
    this.ownerId,
    required this.name,
    this.description,
    this.specifications,
    this.story,
    required this.price,
    this.oldPrice,
    required this.quantity,
    required this.image,
    this.isTrending = false,
    this.isNewest = false,
    this.isOnSale = false,
    this.discount = '0.00',
    this.isMostBought = false,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    // Helper to safely extract a nested image URL or plain string
    String? asString(dynamic val) {
      if (val == null) return null;
      if (val is String) return val;
      if (val is Map)
        return val['url']?.toString() ?? val['path']?.toString() ?? '';
      return val.toString();
    }

    return Product(
      id: json['id'] as int,
      subCategoryId: json['sub_category_id'] as int?,
      brandId: json['brand_id'] as int?,
      storeId: json['store_id'] as int?,
      ownerId: json['owner_id'] as int?,
      name: asString(json['name']) ?? '',
      description: asString(json['description']),
      specifications: asString(json['specifications']),
      story: asString(json['story']),
      price: json['price']?.toString() ?? '0',
      oldPrice: json['old_price']?.toString(),
      quantity: json['quantity'] as int? ?? 0,
      image: asString(json['image']) ?? '',
      isTrending: json['is_trending'] as bool? ?? false,
      isNewest: json['is_newest'] as bool? ?? false,
      isOnSale: json['is_on_sale'] as bool? ?? false,
      discount: json['discount']?.toString() ?? '0.00',
      isMostBought: json['is_most_bought'] as bool? ?? false,
      isActive: json['is_active'] as bool? ?? true,
      createdAt:
          json['created_at'] != null
              ? DateTime.tryParse(json['created_at'])
              : null,
      updatedAt:
          json['updated_at'] != null
              ? DateTime.tryParse(json['updated_at'])
              : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'sub_category_id': subCategoryId,
    'brand_id': brandId,
    'store_id': storeId,
    'owner_id': ownerId,
    'name': name,
    'description': description,
    'specifications': specifications,
    'story': story,
    'price': price,
    'old_price': oldPrice,
    'quantity': quantity,
    'image': image,
    'is_trending': isTrending,
    'is_newest': isNewest,
    'is_on_sale': isOnSale,
    'discount': discount,
    'is_most_bought': isMostBought,
    'is_active': isActive,
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
  };

  // Helper for UI
  String get formattedPrice {
    final value = double.tryParse(price) ?? 0;
    return value
        .toStringAsFixed(0)
        .replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
  }
}
