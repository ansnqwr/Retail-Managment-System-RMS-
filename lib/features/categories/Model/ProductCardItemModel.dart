class ProductCardItemModel {
  final int id;
  final String title;
  final double price;
  final bool isNew;
  final bool hasDiscount;
  final int rating;
  final String imageUrl;

  ProductCardItemModel({
    required this.id,
    required this.title,
    required this.price,
    required this.isNew,
    required this.hasDiscount,
    required this.rating,
    required this.imageUrl,
  });
}
