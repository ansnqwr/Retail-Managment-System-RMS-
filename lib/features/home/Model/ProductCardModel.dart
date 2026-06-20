class ProductCardModel {
  final int id;
  final String imageUrl;
  final String title;
  final double price;
  final bool isNew;
  final bool hasDiscount;
  final int discountPercentage;

  // [{'id':1,'imageUrl':'','title':'lenovo'}]

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
      id: json['id'] as int,
      imageUrl: json['imageUrl'] as String? ?? '',
      title: json['title'] as String,
      price: (json['price'] as num).toDouble(),
      isNew: json['isNew'] as bool,
      hasDiscount: json['hasDiscount'] as bool,
      discountPercentage: json['discountPercentage'] as int,
    );
  }
}
