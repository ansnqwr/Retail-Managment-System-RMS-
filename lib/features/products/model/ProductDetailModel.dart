// lib/features/home/Model/ProductDetailModel.dart
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

class ProductColorModel extends Equatable {
  final int id;
  final String name;
  final String hex;

  const ProductColorModel({
    required this.id,
    required this.name,
    required this.hex,
  });

  factory ProductColorModel.fromJson(Map<String, dynamic> json) {
    return ProductColorModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      hex: json['hex'] ?? '#000000',
    );
  }

  @override
  List<Object?> get props => [id, name, hex];
}

class ProductSizeModel extends Equatable {
  final String label;
  final bool isAvailable;

  const ProductSizeModel({required this.label, this.isAvailable = true});

  factory ProductSizeModel.fromJson(Map<String, dynamic> json) {
    return ProductSizeModel(
      label: json['label'] ?? '',
      isAvailable: json['is_available'] ?? true,
    );
  }

  @override
  List<Object?> get props => [label, isAvailable];
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
  final List<ProductColorModel> colors;
  final List<ProductSizeModel> sizes;
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
    required this.colors,
    required this.sizes,
    required this.stockCount,
    required this.isInStock,
    this.isFavorite = false,
    this.howItWasMade = '',
    this.manufacturingInformation = '',
    this.specifications = const {},
  });

  factory ProductDetailModel.fromJson(Map<String, dynamic> json) {
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
      colors:
          (json['colors'] as List? ?? [])
              .map((e) => ProductColorModel.fromJson(e))
              .toList(),
      sizes:
          (json['sizes'] as List? ?? [])
              .map((e) => ProductSizeModel.fromJson(e))
              .toList(),
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
    colors,
    sizes,
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
  final String currency;
  final String imageUrl;
  final double averageRating;

  const SimilarProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.currency,
    required this.imageUrl,
    this.averageRating = 0,
  });

  factory SimilarProductModel.fromJson(Map<String, dynamic> json) {
    return SimilarProductModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      currency: json['currency'] ?? '',
      imageUrl: json['image_url'] ?? '',
      averageRating: (json['average_rating'] ?? 0).toDouble(),
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    price,
    currency,
    imageUrl,
    averageRating,
  ];
}
