import 'package:delni_rms/features/stores/model/BranchModel.dart';

abstract class StoreDetailsEvent {}

class LoadStoreDetails extends StoreDetailsEvent {
  final int storeId;
  final StoreBranchModel? selectedBranch;

  LoadStoreDetails(this.storeId, {this.selectedBranch});
}

class SortProducts extends StoreDetailsEvent {
  final String sortBy;

  SortProducts(this.sortBy);
}

class LoadMoreProducts extends StoreDetailsEvent {}
