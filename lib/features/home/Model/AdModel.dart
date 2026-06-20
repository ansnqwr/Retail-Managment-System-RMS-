class AdModel {
  final int id;
  final String url;
  final String businessType;

  AdModel({required this.id, required this.url, required this.businessType});

  factory AdModel.fromJson(Map<String, dynamic> json) {
    return AdModel(
      id: json['id'] as int,
      url: json['url'] as String? ?? '',
      businessType: json['businessType'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'url': url, 'businessType': businessType};
  }
}
