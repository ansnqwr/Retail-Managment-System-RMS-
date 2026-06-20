import 'package:equatable/equatable.dart';

abstract class CategoriesEvent extends Equatable {
  const CategoriesEvent();
  @override
  List<Object?> get props => [];
}

class CategoriesLoadEvent extends CategoriesEvent {
  const CategoriesLoadEvent();
}

class CategoriesRefreshRequested extends CategoriesEvent {
  const CategoriesRefreshRequested();
}

class CategoriesCategoryTapped extends CategoriesEvent {
  final int categoryIndex;
  final int categoryId;

  const CategoriesCategoryTapped({
    required this.categoryIndex,
    required this.categoryId,
  });

  @override
  List<Object?> get props => [categoryIndex, categoryId];
}

class CategoriesSubcategoryTapped extends CategoriesEvent {
  final int subcategoryId;
  final String pageTitle;

  const CategoriesSubcategoryTapped({
    required this.subcategoryId,
    required this.pageTitle,
  });

  @override
  List<Object?> get props => [subcategoryId, pageTitle];
}
