import 'package:flutter/material.dart';

class NamedId {
  final int id;
  final String title;

  const NamedId({required this.id, required this.title});

  factory NamedId.fromJson(Map<String, dynamic> json) {
    return NamedId(id: json['id'] as int, title: json['title'] as String);
  }
}

class FiltersModel {
  final List<NamedId> categories;
  final Map<String, List<NamedId>> subcategories;
  final List<NamedId> brands;
  final List<NamedId> governorates;
  final Map<String, List<NamedId>> cities;
  final List<ColorOption> colors;
  final double minPrice;
  final double maxPrice;

  const FiltersModel({
    this.categories = const [],
    this.subcategories = const {},
    this.brands = const [],
    this.governorates = const [],
    this.cities = const {},
    this.colors = const [],
    this.minPrice = 0,
    this.maxPrice = 1000,
  });

  factory FiltersModel.fromJson(Map<String, dynamic> json) {
    return FiltersModel(
      categories:
          (json['categories'] as List<dynamic>?)
              ?.map((e) => NamedId.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      subcategories:
          (json['subcategories'] as Map<String, dynamic>?)?.map(
            (key, value) => MapEntry(
              key,
              (value as List<dynamic>)
                  .map((e) => NamedId.fromJson(e as Map<String, dynamic>))
                  .toList(),
            ),
          ) ??
          {},
      brands:
          (json['brands'] as List<dynamic>?)
              ?.map((e) => NamedId.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      governorates:
          (json['governorates'] as List<dynamic>?)
              ?.map((e) => NamedId.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      cities:
          (json['cities'] as Map<String, dynamic>?)?.map(
            (key, value) => MapEntry(
              key,
              (value as List<dynamic>)
                  .map((e) => NamedId.fromJson(e as Map<String, dynamic>))
                  .toList(),
            ),
          ) ??
          {},
      colors:
          (json['colors'] as List<dynamic>?)
              ?.map((e) => ColorOption.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      minPrice: (json['minPrice'] as num?)?.toDouble() ?? 0,
      maxPrice: (json['maxPrice'] as num?)?.toDouble() ?? 1000,
    );
  }

  List<String> get categoryNames => categories.map((e) => e.title).toList();
  List<String> get brandNames => brands.map((e) => e.title).toList();
  List<String> get governorateNames =>
      governorates.map((e) => e.title).toList();
  Map<String, List<String>> get cityNamesByGovernorate =>
      cities.map((k, v) => MapEntry(k, v.map((e) => e.title).toList()));
  Map<String, List<String>> get subcategoryNamesByCategory =>
      subcategories.map((k, v) => MapEntry(k, v.map((e) => e.title).toList()));

  int? categoryIdByName(String name) =>
      categories
                  .firstWhere(
                    (e) => e.title == name,
                    orElse: () => const NamedId(id: -1, title: ''),
                  )
                  .id ==
              -1
          ? null
          : categories.firstWhere((e) => e.title == name).id;

  int? brandIdByName(String name) =>
      brands
                  .firstWhere(
                    (e) => e.title == name,
                    orElse: () => const NamedId(id: -1, title: ''),
                  )
                  .id ==
              -1
          ? null
          : brands.firstWhere((e) => e.title == name).id;

  int? governorateIdByName(String name) =>
      governorates
                  .firstWhere(
                    (e) => e.title == name,
                    orElse: () => const NamedId(id: -1, title: ''),
                  )
                  .id ==
              -1
          ? null
          : governorates.firstWhere((e) => e.title == name).id;

  int? cityIdByName(String governorateName, String cityName) =>
      cities[governorateName]
                  ?.firstWhere(
                    (e) => e.title == cityName,
                    orElse: () => const NamedId(id: -1, title: ''),
                  )
                  .id ==
              -1
          ? null
          : cities[governorateName]?.firstWhere((e) => e.title == cityName).id;

  int? subcategoryIdByName(String categoryName, String subcategoryName) =>
      subcategories[categoryName]
                  ?.firstWhere(
                    (e) => e.title == subcategoryName,
                    orElse: () => const NamedId(id: -1, title: ''),
                  )
                  .id ==
              -1
          ? null
          : subcategories[categoryName]
              ?.firstWhere((e) => e.title == subcategoryName)
              .id;

  String? categoryNameById(int id) {
    try {
      return categories.firstWhere((e) => e.id == id).title;
    } catch (_) {
      return null;
    }
  }
}

class ColorOption {
  final String name;
  final String hex;

  const ColorOption({required this.name, required this.hex});

  factory ColorOption.fromJson(Map<String, dynamic> json) {
    return ColorOption(
      name: json['name'] as String,
      hex: json['hex'] as String,
    );
  }

  Color get colorValue {
    String hexColor = hex.replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor';
    }
    return Color(int.parse(hexColor, radix: 16));
  }
}
