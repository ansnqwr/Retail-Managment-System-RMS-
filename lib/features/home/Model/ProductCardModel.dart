class ProductCardModel {
  final int id;
  final String imageUrl;
  final String title;
  final double price;
  final bool isNew;
  final bool hasDiscount;
  final int discountPercentage;

  ProductCardModel({
    required this.id,
    required this.imageUrl,
    required this.title,
    required this.price,
    required this.isNew,
    required this.hasDiscount,
    required this.discountPercentage,
  });

  factory ProductCardModel.fromJson(Map<String, dynamic> json) {
    return ProductCardModel(
      id: (json['id'] is num) ? (json['id'] as num).toInt() : 0,
      imageUrl: json['imageUrl']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      price: (json['price'] is num) ? (json['price'] as num).toDouble() : 0.0,
      isNew: json['isNew'] == true,
      hasDiscount: json['hasDiscount'] == true,
      discountPercentage:
          (json['discountPercentage'] is num)
              ? (json['discountPercentage'] as num).toInt()
              : 0,
    );
  }
}
