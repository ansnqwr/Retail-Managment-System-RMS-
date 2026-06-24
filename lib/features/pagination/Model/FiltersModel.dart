import 'package:flutter/material.dart';

class FiltersModel {
  final List<String> categories;
  final Map<String, List<String>> subcategories;
  final List<String> brands;
  final List<String> governorates;
  final Map<String, List<String>> cities;
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
              ?.map((e) => (e as Map<String, dynamic>)['title'] as String)
              .where((s) => s.isNotEmpty)
              .toList() ??
          [],
      subcategories:
          (json['subcategories'] as Map<String, dynamic>?)?.map(
            (key, value) => MapEntry(
              key,
              (value as List<dynamic>)
                  .map((e) => (e as Map<String, dynamic>)['title'] as String)
                  .where((s) => s.isNotEmpty)
                  .toList(),
            ),
          ) ??
          {},

      brands:
          (json['brands'] as List<dynamic>?)
              ?.map((e) => (e as Map<String, dynamic>)['title'] as String)
              .where((s) => s.isNotEmpty)
              .toList() ??
          [],
      governorates:
          (json['governorates'] as List<dynamic>?)
              ?.map((e) => (e as Map<String, dynamic>)['title'] as String)
              .where((s) => s.isNotEmpty)
              .toList() ??
          [],
      cities:
          (json['cities'] as Map<String, dynamic>?)?.map(
            (key, value) => MapEntry(
              key,
              (value as List<dynamic>)
                  .map((e) => (e as Map<String, dynamic>)['title'] as String)
                  .where((s) => s.isNotEmpty)
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

  List<String> get categoryNames => categories;

  List<String> get brandNames => brands;

  List<String> get governorateNames => governorates;

  Map<String, List<String>> get cityNamesByGovernorate => cities;

  Map<String, List<String>> get subcategoryNamesByCategory => subcategories;
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
