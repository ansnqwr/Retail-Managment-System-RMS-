class AdModel {
  final int id;
  final String url;
  final String businessType;
  final bool isProduct;

  AdModel({
    required this.id,
    required this.url,
    required this.businessType,
    required this.isProduct,
  });

  factory AdModel.fromJson(Map<String, dynamic> json) {
    return AdModel(
      id: json['id'] as int,
      url: json['url'] as String? ?? '',
      businessType: json['businessType'] as String? ?? '',
      isProduct: json['isProduct'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
      'businessType': businessType,
      'isProduct': isProduct,
    };
  }
}
