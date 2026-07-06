
class CategoryItemModel {
  final int id;
  final String title;
  final bool hasSubCategories;
  final List<CategoryItemModel> subCategories;
  final String imageUrl;

  CategoryItemModel({
    required this.id,
    required this.title,
    required this.hasSubCategories,
    required this.subCategories,
    required this.imageUrl,
  });

  factory CategoryItemModel.fromJson(Map<String, dynamic> json) {
    return CategoryItemModel(
      id: json['id'] as int,
      title: json['title'] as String,
      hasSubCategories: json['hasSubCategories'] as bool,
      subCategories:
          (json['subCategories'] as List<dynamic>? ?? [])
              .map((e) => CategoryItemModel.fromJson(e as Map<String, dynamic>))
              .toList(),
      imageUrl: json['imageUrl'] as String? ?? '',
    );
  }
}
