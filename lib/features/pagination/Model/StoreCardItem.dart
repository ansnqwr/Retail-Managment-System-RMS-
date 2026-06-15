class StoreCardModel {
  final int id;
  final String imageUrl;
  final String title;
  final String governorate;
  final String city;
  final bool isNew;
  final bool isVerified;
  final bool isBrand;

  StoreCardModel({
    required this.id,
    required this.imageUrl,
    required this.title,
    required this.isNew,
    required this.governorate,
    required this.city,
    required this.isVerified,
    required this.isBrand,
  });
}
