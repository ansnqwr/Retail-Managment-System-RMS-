// lib/features/products/model/ProductDetailModel.dart
import 'package:equatable/equatable.dart';

class BrandModel extends Equatable {
  final int id;
  final String name;

  const BrandModel({required this.id, required this.name});

  factory BrandModel.fromJson(Map<String, dynamic> json) {
    return BrandModel(id: json['id'] ?? 0, name: json['name'] ?? '');
  }

  @override
  List<Object?> get props => [id, name];
}

class ProductImageModel extends Equatable {
  final int id;
  final String imageUrl;

  const ProductImageModel({required this.id, required this.imageUrl});

  factory ProductImageModel.fromJson(Map<String, dynamic> json) {
    return ProductImageModel(
      id: json['id'] ?? 0,
      imageUrl: json['image_url'] ?? '',
    );
  }

  @override
  List<Object?> get props => [id, imageUrl];
}

class ProductDetailModel extends Equatable {
  final int productId;
  final String name;
  final BrandModel brand;
  final String description;
  final double price;
  final double oldPrice;
  final String currency;
  final double discountPercentage;
  final List<ProductImageModel> images;
  final Map<String, List<String>> skuFactors;
  final int stockCount;
  final bool isInStock;
  final bool isFavorite;
  final String howItWasMade;
  final String manufacturingInformation;
  final Map<String, String> specifications;

  const ProductDetailModel({
    required this.productId,
    required this.name,
    required this.brand,
    required this.description,
    required this.price,
    required this.oldPrice,
    required this.currency,
    required this.discountPercentage,
    required this.images,
    required this.skuFactors,
    required this.stockCount,
    required this.isInStock,
    this.isFavorite = false,
    this.howItWasMade = '',
    this.manufacturingInformation = '',
    this.specifications = const {},
  });

  ProductDetailModel copyWith({
    int? productId,
    String? name,
    BrandModel? brand,
    String? description,
    double? price,
    double? oldPrice,
    String? currency,
    double? discountPercentage,
    List<ProductImageModel>? images,
    Map<String, List<String>>? skuFactors,
    int? stockCount,
    bool? isInStock,
    bool? isFavorite,
    String? howItWasMade,
    String? manufacturingInformation,
    Map<String, String>? specifications,
  }) {
    return ProductDetailModel(
      productId: productId ?? this.productId,
      name: name ?? this.name,
      brand: brand ?? this.brand,
      description: description ?? this.description,
      price: price ?? this.price,
      oldPrice: oldPrice ?? this.oldPrice,
      currency: currency ?? this.currency,
      discountPercentage: discountPercentage ?? this.discountPercentage,
      images: images ?? this.images,
      skuFactors: skuFactors ?? this.skuFactors,
      stockCount: stockCount ?? this.stockCount,
      isInStock: isInStock ?? this.isInStock,
      isFavorite: isFavorite ?? this.isFavorite,
      howItWasMade: howItWasMade ?? this.howItWasMade,
      manufacturingInformation:
          manufacturingInformation ?? this.manufacturingInformation,
      specifications: specifications ?? this.specifications,
    );
  }

  factory ProductDetailModel.fromJson(Map<String, dynamic> json) {
    final skuRaw = json['Sku'] ?? json['sku'];
    Map<String, List<String>> skuFactors = {};
    if (skuRaw is Map) {
      skuFactors = skuRaw.map((key, value) {
        if (value is List) {
          return MapEntry(
            key.toString(),
            value.map((e) => e.toString()).toList(),
          );
        }
        return MapEntry(key.toString(), <String>[]);
      });
    }

    return ProductDetailModel(
      productId: json['product_id'] ?? 0,
      name: json['name'] ?? '',
      brand: BrandModel.fromJson(json['brand'] ?? {}),
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      oldPrice: (json['old_price'] ?? 0).toDouble(),
      currency: json['currency'] ?? '',
      discountPercentage: (json['discount_percentage'] ?? 0).toDouble(),
      images:
          (json['images'] as List? ?? [])
              .map((e) => ProductImageModel.fromJson(e))
              .toList(),
      skuFactors: skuFactors,
      stockCount: json['stock_count'] ?? 0,
      isInStock: json['is_in_stock'] ?? false,
      isFavorite: json['is_favorite'] ?? false,
      howItWasMade: json['how_it_was_made'] ?? '',
      manufacturingInformation: json['manufacturing_information'] ?? '',
      specifications: Map<String, String>.from(json['specifications'] ?? {}),
    );
  }

  @override
  List<Object?> get props => [
    productId,
    name,
    brand,
    description,
    price,
    oldPrice,
    currency,
    discountPercentage,
    images,
    skuFactors,
    stockCount,
    isInStock,
    isFavorite,
    howItWasMade,
    manufacturingInformation,
    specifications,
  ];
}

class SimilarProductModel extends Equatable {
  final int id;
  final String name;
  final double price;
  final double oldPrice;
  final String currency;
  final String imageUrl;
  final double averageRating;
  final int discountPercentage;

  const SimilarProductModel({
    required this.id,
    required this.name,
    required this.price,
    this.oldPrice = 0,
    required this.currency,
    required this.imageUrl,
    this.averageRating = 0,
    this.discountPercentage = 0,
  });

  factory SimilarProductModel.fromJson(Map<String, dynamic> json) {
    return SimilarProductModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      oldPrice: (json['old_price'] ?? 0).toDouble(),
      currency: json['currency'] ?? '',
      imageUrl: json['image_url'] ?? '',
      averageRating: (json['average_rating'] ?? 0).toDouble(),
      discountPercentage: (json['discount_percentage'] ?? 0).toInt(),
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    price,
    oldPrice,
    currency,
    imageUrl,
    averageRating,
    discountPercentage,
  ];
}
