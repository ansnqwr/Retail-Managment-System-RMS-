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

  // Parse from API JSON
  factory StoreCardModel.fromJson(Map<String, dynamic> json) {
    return StoreCardModel(
      id: json['id'] as int,
      imageUrl: json['imageUrl'] as String? ?? '',
      title: json['title'] as String,
      isNew: json['isNew'] as bool,
      governorate: json['governorate'] as String,
      city: json['city'] as String,
      isVerified: json['isVerified'] as bool,
      isBrand: json['isBrand'] as bool,
    );
  }
}
