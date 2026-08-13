import 'package:delni_rms/features/home/Model/ProductCardModel.dart';
import 'package:delni_rms/features/stores/model/BranchModel.dart';
import 'package:delni_rms/features/stores/model/StoreProfileModel.dart';

abstract class StoreDetailsState {}

class StoreDetailsLoading extends StoreDetailsState {}

class StoreDetailsLoaded extends StoreDetailsState {
  final Map<String, dynamic> overviewData;
  final List<ProductCardModel> products;
  final StoreProfileModel profileData;

  final StoreBranchModel? selectedBranch;

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
    this.selectedBranch,
  });

  StoreDetailsLoaded copyWith({
    List<ProductCardModel>? products,
    bool? hasMoreProducts,
    bool? isLoadingMore,
    String? currentSort,
    StoreBranchModel? selectedBranch,
  }) {
    return StoreDetailsLoaded(
      overviewData: overviewData,
      products: products ?? this.products,
      profileData: profileData,
      selectedBranch: selectedBranch ?? this.selectedBranch,
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
