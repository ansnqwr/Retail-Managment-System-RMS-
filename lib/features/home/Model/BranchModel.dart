class StoreBranchModel {
  final int id;
  final String title;
  final String governorate;
  final String city;
final int storeId;
  StoreBranchModel({
    required this.id,
    required this.storeId,
    required this.title,
    required this.governorate,
    required this.city,
  });

  factory StoreBranchModel.fromJson(Map<String, dynamic> json) {
    return StoreBranchModel(
      id: json['id'] ?? 0,
      storeId: json['storeId'] ?? json['id'] ?? 0,
      title: json['title'] ?? '',
      governorate: json['governorate'] ?? '',
      city: json['city'] ?? '',
    );
  }


    Map<String, dynamic> toJson() {
      return {'id': id, 'storeId': storeId, 'title': title, 'governorate': governorate, 'city': city};
    }
}
