import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();
  @override
  List<Object?> get props => [];
}

class HomeLoadRequested extends HomeEvent {
  final bool isGuest;
  const HomeLoadRequested(this.isGuest);

  @override
  List<Object?> get props => [isGuest];
}

class HomeCategorySelected extends HomeEvent {
  final int categoryIndex;
  final int categoryId;
  const HomeCategorySelected({
    required this.categoryIndex,
    required this.categoryId,
  });
  @override
  List<Object?> get props => [categoryIndex, categoryId];
}

class HomeRefreshRequested extends HomeEvent {
  const HomeRefreshRequested();
}

class HomeSectionSeeAllTapped extends HomeEvent {
  final int sectionId;
  final String sectionTitle;

  const HomeSectionSeeAllTapped(this.sectionTitle, this.sectionId);

  @override
  List<Object?> get props => [sectionTitle, sectionId];
}

class HomeProductTapped extends HomeEvent {
  final int productId;
  const HomeProductTapped(this.productId);
  @override
  List<Object?> get props => [productId];
}

class HomeStoreTapped extends HomeEvent {
  final int storeId;
  const HomeStoreTapped(this.storeId);
  @override
  List<Object?> get props => [storeId];
}

class HomeSettingsTapped extends HomeEvent {
  const HomeSettingsTapped();
}

class HomeNotificationsTapped extends HomeEvent {
  const HomeNotificationsTapped();
}

class HomeSignUpTapped extends HomeEvent {
  const HomeSignUpTapped();
}

class HomeLoadMoreJustForYouRequested extends HomeEvent {
  const HomeLoadMoreJustForYouRequested();
}

class HomeSearchSubmitted extends HomeEvent {
  final String query;
  final bool isSearchingProducts;

  const HomeSearchSubmitted({
    required this.query,
    required this.isSearchingProducts,
  });

  @override
  List<Object?> get props => [query, isSearchingProducts];
}

class HomeSearchToggleChanged extends HomeEvent {
  final bool isSearchingProducts;
  const HomeSearchToggleChanged({required this.isSearchingProducts});
  @override
  List<Object?> get props => [isSearchingProducts];
}

class HomeSearchCleared extends HomeEvent {
  const HomeSearchCleared();
}
