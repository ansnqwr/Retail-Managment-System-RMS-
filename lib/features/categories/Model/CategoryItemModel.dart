import 'package:flutter/material.dart';

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
}
