import 'package:equatable/equatable.dart';
import '/features/categories/Model/CategoryItemModel.dart';
import '/features/home/Model/AdModel.dart';
import '../Model/ProductCardModel.dart';
import '../Model/StoreCardItem.dart';

abstract class HomeState extends Equatable {
  const HomeState();
  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {
  const HomeInitial();
}

class HomeLoading extends HomeState {
  const HomeLoading();
}

class HomeLoaded extends HomeState {
  final List<AdModel> ads;
  final List<CategoryItemModel> categories;
  final int selectedCategoryIndex;
  final int selectedSeeAllIndex;
  final List<ProductCardModel> trendingProducts;
  final List<ProductCardModel> onSaleProducts;
  final List<ProductCardModel> mostBoughtProducts;
  final List<ProductCardModel> newestProducts;
  final List<StoreCardModel> brandStores;
  final List<StoreCardModel> nearbyStores;
  final List<ProductCardModel> justForYouProducts;
  final bool justForYouHasMoreData;
  final int justForYouCurrentPage;
  final bool isLoadingMoreJustForYou;
  final String? homeSearchQuery;
  final bool isSearchingProducts;
  final bool isGuest;

  const HomeLoaded({
    required this.ads,
    required this.categories,
    this.selectedCategoryIndex = 0,
    this.selectedSeeAllIndex = 0,
    required this.trendingProducts,
    required this.onSaleProducts,
    required this.mostBoughtProducts,
    required this.newestProducts,
    required this.brandStores,
    required this.nearbyStores,
    required this.justForYouProducts,
    this.justForYouHasMoreData = true,
    this.justForYouCurrentPage = 1,
    this.isLoadingMoreJustForYou = false,
    this.homeSearchQuery,
    this.isSearchingProducts = true,
    required this.isGuest,
  });

  HomeLoaded copyWith({
    List<AdModel>? ads,
    List<CategoryItemModel>? categories,
    int? selectedCategoryIndex,
    int? selectedSeeAllIndex,
    List<ProductCardModel>? trendingProducts,
    List<ProductCardModel>? onSaleProducts,
    List<ProductCardModel>? mostBoughtProducts,
    List<ProductCardModel>? newestProducts,
    List<StoreCardModel>? brandStores,
    List<StoreCardModel>? nearbyStores,
    List<ProductCardModel>? justForYouProducts,
    bool? justForYouHasMoreData,
    int? justForYouCurrentPage,
    bool? isLoadingMoreJustForYou,
    String? homeSearchQuery,
    bool? isSearchingProducts,
    bool? isGuest,
  }) {
    return HomeLoaded(
      ads: ads ?? this.ads,
      categories: categories ?? this.categories,
      selectedCategoryIndex:
          selectedCategoryIndex ?? this.selectedCategoryIndex,
      selectedSeeAllIndex: selectedSeeAllIndex ?? this.selectedSeeAllIndex,
      trendingProducts: trendingProducts ?? this.trendingProducts,
      onSaleProducts: onSaleProducts ?? this.onSaleProducts,
      mostBoughtProducts: mostBoughtProducts ?? this.mostBoughtProducts,
      newestProducts: newestProducts ?? this.newestProducts,
      brandStores: brandStores ?? this.brandStores,
      nearbyStores: nearbyStores ?? this.nearbyStores,
      justForYouProducts: justForYouProducts ?? this.justForYouProducts,
      justForYouHasMoreData:
          justForYouHasMoreData ?? this.justForYouHasMoreData,
      justForYouCurrentPage:
          justForYouCurrentPage ?? this.justForYouCurrentPage,
      isLoadingMoreJustForYou:
          isLoadingMoreJustForYou ?? this.isLoadingMoreJustForYou,
      homeSearchQuery: homeSearchQuery ?? this.homeSearchQuery,
      isSearchingProducts: isSearchingProducts ?? this.isSearchingProducts,
      isGuest: isGuest ?? this.isGuest,
    );
  }

  @override
  List<Object?> get props => [
    ads,
    categories,
    selectedCategoryIndex,
    selectedSeeAllIndex,
    trendingProducts,
    onSaleProducts,
    mostBoughtProducts,
    newestProducts,
    brandStores,
    nearbyStores,
    justForYouProducts,
    justForYouHasMoreData,
    justForYouCurrentPage,
    isLoadingMoreJustForYou,
    homeSearchQuery,
    isSearchingProducts,
    isGuest,
  ];
}

class HomeError extends HomeState {
  final String message;
  const HomeError(this.message);
  @override
  List<Object?> get props => [message];
}
