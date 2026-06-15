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
}
