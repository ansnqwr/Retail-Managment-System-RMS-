class StoreBranchModel {
  final int id;
  final int storeId;
  final String title;
  final String governorate;
  final String city;

  const StoreBranchModel({
    required this.id,
    required this.storeId,
    required this.title,
    required this.governorate,
    required this.city,
  });

  factory StoreBranchModel.fromJson(Map<String, dynamic> json) {
    return StoreBranchModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      storeId: (json['storeId'] as num?)?.toInt() ?? 0,
      title: json['title'] as String? ?? '',
      governorate: json['governorate'] as String? ?? '',
      city: json['city'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'storeId': storeId,
      'title': title,
      'governorate': governorate,
      'city': city,
    };
  }
}
