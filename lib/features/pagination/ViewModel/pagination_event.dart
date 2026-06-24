import 'package:equatable/equatable.dart';

abstract class PaginationEvent extends Equatable {
  const PaginationEvent();
  @override
  List<Object?> get props => [];
}

class PaginationLoadRequested extends PaginationEvent {
  final String? businessType;
  final bool isProduct;
  final bool isStore;
  final bool isSubCategory;
  final bool? hasSubCategories;
  final int? subCategoryId;
  final String paginationTitle;

  const PaginationLoadRequested({
    required this.businessType,
    required this.isProduct,
    required this.isStore,
    required this.isSubCategory,
    this.hasSubCategories,
    this.subCategoryId,
    required this.paginationTitle,
  });

  @override
  List<Object?> get props => [
    businessType,
    isProduct,
    isStore,
    isSubCategory,
    hasSubCategories,
    subCategoryId,
    paginationTitle,
  ];
}

class PaginationRefreshRequested extends PaginationEvent {
  const PaginationRefreshRequested();
}

class PaginationLoadMoreRequested extends PaginationEvent {
  const PaginationLoadMoreRequested();
}

class PaginationSearchSubmitted extends PaginationEvent {
  final String query;
  const PaginationSearchSubmitted({required this.query});
  @override
  List<Object?> get props => [query];
}

class PaginationSearchChipRemoved extends PaginationEvent {
  final int chipIndex;
  const PaginationSearchChipRemoved({required this.chipIndex});
  @override
  List<Object?> get props => [chipIndex];
}

class PaginationSearchChipsCleared extends PaginationEvent {
  const PaginationSearchChipsCleared();
}

class PaginationFiltersApplied extends PaginationEvent {
  final Map<String, dynamic> filters;
  const PaginationFiltersApplied({required this.filters});
  @override
  List<Object?> get props => [filters];
}

class PaginationFilterChipRemoved extends PaginationEvent {
  final String filterKey;
  const PaginationFilterChipRemoved({required this.filterKey});
  @override
  List<Object?> get props => [filterKey];
}

class PaginationFiltersCleared extends PaginationEvent {
  const PaginationFiltersCleared();
}

class PaginationSubCategoryTapped extends PaginationEvent {
  final int subCategoryId;
  final String subCategoryTitle;

  const PaginationSubCategoryTapped({
    required this.subCategoryId,
    required this.subCategoryTitle,
  });
  @override
  List<Object?> get props => [subCategoryId, subCategoryTitle];
}

class PaginationProductTapped extends PaginationEvent {
  final int productId;
  const PaginationProductTapped({required this.productId});
  @override
  List<Object?> get props => [productId];
}

class PaginationStoreTapped extends PaginationEvent {
  final int storeId;
  const PaginationStoreTapped({required this.storeId});
  @override
  List<Object?> get props => [storeId];
}
