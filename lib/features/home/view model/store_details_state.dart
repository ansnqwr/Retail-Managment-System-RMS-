import 'package:delni_rms/features/home/Model/ProductCardModel.dart';
import 'package:delni_rms/features/home/Model/StoreProfileModel.dart';


abstract class StoreDetailsState {}

class StoreDetailsLoading extends StoreDetailsState {}

class StoreDetailsLoaded extends StoreDetailsState {
  final Map<String, dynamic> overviewData;
  final List<ProductCardModel> products; // استخدام المودل الأصلي للمشروع
  final StoreProfileModel profileData;
  final bool hasMoreProducts;
  final bool isLoadingMore;
  final String currentSort;

  StoreDetailsLoaded({
    required this.overviewData,
    required this.products,
    required this.profileData,
    required this.hasMoreProducts,
    required this.isLoadingMore,
    required this.currentSort,
  });

  StoreDetailsLoaded copyWith({
    List<ProductCardModel>? products,
    bool? hasMoreProducts,
    bool? isLoadingMore,
    String? currentSort,
  }) {
    return StoreDetailsLoaded(
      overviewData: overviewData,
      profileData: profileData,
      products: products ?? this.products,
      hasMoreProducts: hasMoreProducts ?? this.hasMoreProducts,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      currentSort: currentSort ?? this.currentSort,
    );
  }
}

class StoreDetailsError extends StoreDetailsState {
  final String message;
  StoreDetailsError(this.message);
}
