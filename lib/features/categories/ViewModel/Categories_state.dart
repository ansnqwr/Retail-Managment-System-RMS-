import 'package:equatable/equatable.dart';
import '../Model/CategoryItemModel.dart';

abstract class CategoriesState extends Equatable {
  const CategoriesState();
  @override
  List<Object?> get props => [];
}

class CategoriesInitialState extends CategoriesState {
  const CategoriesInitialState();
}

class CategoriesLoadingState extends CategoriesState {
  const CategoriesLoadingState();
}

class CategoriesLoadedState extends CategoriesState {
  final int? expandedCategoryId;
  final List<CategoryItemModel> categoriesList;

  const CategoriesLoadedState({
    this.expandedCategoryId,
    required this.categoriesList,
  });

  CategoriesLoadedState copyWith({
    int? expandedCategoryId,
    List<CategoryItemModel>? categoriesList,
  }) {
    return CategoriesLoadedState(
      expandedCategoryId: expandedCategoryId ?? this.expandedCategoryId,
      categoriesList: categoriesList ?? this.categoriesList,
    );
  }

  @override
  List<Object?> get props => [expandedCategoryId, categoriesList];
}

class CategoriesErrorState extends CategoriesState {
  final String message;
  const CategoriesErrorState(this.message);
  @override
  List<Object?> get props => [message];
}
