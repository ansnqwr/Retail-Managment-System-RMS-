class ProductCardModel {
  final String imageUrl;
  final String title;
  final double price;
  final bool isNew;
  final bool hasDiscount;

  ProductCardModel({
    required this.imageUrl,
    required this.title,
    required this.price,
    required this.isNew,
    required this.hasDiscount,
  });
}
