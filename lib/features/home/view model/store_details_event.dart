abstract class StoreDetailsEvent {}

class LoadStoreDetails extends StoreDetailsEvent {
  final int storeId;
  LoadStoreDetails(this.storeId);
}

class SortProducts extends StoreDetailsEvent {
  final String sortBy;
  SortProducts(this.sortBy);
}

class LoadMoreProducts extends StoreDetailsEvent {}
