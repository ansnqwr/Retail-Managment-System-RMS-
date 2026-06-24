import 'package:equatable/equatable.dart';
import '../Model/FiltersModel.dart';
import '../../categories/Model/CategoryItemModel.dart';
import '../../home/Model/ProductCardModel.dart';
import '../../home/Model/StoreCardItem.dart';

abstract class PaginationState extends Equatable {
  const PaginationState();
  @override
  List<Object?> get props => [];
}

class PaginationInitial extends PaginationState {
  const PaginationInitial();
}

class PaginationLoading extends PaginationState {
  const PaginationLoading();
}

class PaginationLoaded extends PaginationState {
  final List<ProductCardModel> products;
  final List<StoreCardModel> stores;
  final List<CategoryItemModel> subcategories;
  final bool isProduct;
  final bool isStore;
  final bool isSubCategory;
  final bool? hasSubCategories;
  final int? subCategoryId;
  final String paginationTitle;
  final Map<String, dynamic> activeFilters;
  final FiltersModel? filtersModel;
  final String? searchQuery;
  final List<String> searchChips;
  final bool hasMoreData;
  final int currentPage;
  final bool isLoadingMore;

  const PaginationLoaded({
    required this.products,
    required this.stores,
    required this.subcategories,
    required this.isProduct,
    required this.isStore,
    required this.isSubCategory,
    this.hasSubCategories,
    this.subCategoryId,
    required this.paginationTitle,
    this.activeFilters = const {},
    this.filtersModel,
    this.searchQuery,
    this.searchChips = const [],
    this.hasMoreData = true,
    this.currentPage = 1,
    this.isLoadingMore = false,
  });

  PaginationLoaded copyWith({
    List<ProductCardModel>? products,
    List<StoreCardModel>? stores,
    List<CategoryItemModel>? subcategories,
    bool? isProduct,
    bool? isStore,
    bool? isSubCategory,
    bool? hasSubCategories,
    int? subCategoryId,
    String? paginationTitle,
    Map<String, dynamic>? activeFilters,
    FiltersModel? filtersModel,
    String? searchQuery,
    List<String>? searchChips,
    bool? hasMoreData,
    int? currentPage,
    bool? isLoadingMore,
  }) {
    return PaginationLoaded(
      products: products ?? this.products,
      stores: stores ?? this.stores,
      subcategories: subcategories ?? this.subcategories,
      isProduct: isProduct ?? this.isProduct,
      isStore: isStore ?? this.isStore,
      isSubCategory: isSubCategory ?? this.isSubCategory,
      hasSubCategories: hasSubCategories ?? this.hasSubCategories,
      subCategoryId: subCategoryId ?? this.subCategoryId,
      paginationTitle: paginationTitle ?? this.paginationTitle,
      activeFilters: activeFilters ?? this.activeFilters,
      filtersModel: filtersModel ?? this.filtersModel,
      searchQuery: searchQuery ?? this.searchQuery,
      searchChips: searchChips ?? this.searchChips,
      hasMoreData: hasMoreData ?? this.hasMoreData,
      currentPage: currentPage ?? this.currentPage,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props => [
    products,
    stores,
    subcategories,
    isProduct,
    isStore,
    isSubCategory,
    hasSubCategories,
    subCategoryId,
    paginationTitle,
    activeFilters,
    filtersModel,
    searchQuery,
    searchChips,
    hasMoreData,
    currentPage,
    isLoadingMore,
  ];
}

class PaginationError extends PaginationState {
  final String message;
  const PaginationError(this.message);
  @override
  List<Object?> get props => [message];
}
