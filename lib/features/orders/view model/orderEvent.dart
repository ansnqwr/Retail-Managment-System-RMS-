abstract class OrdersEvent {}

class LoadOrders extends OrdersEvent {}

class RefreshOrders extends OrdersEvent {}

class LoadOrderDetails extends OrdersEvent {
  final String orderId;
  LoadOrderDetails(this.orderId);
}

class TrackOrder extends OrdersEvent {
  final String orderId;
  TrackOrder(this.orderId);
}

class ReviewOrder extends OrdersEvent {
  final String orderId;
  final String? review;
  final double? rating;

  ReviewOrder(this.orderId, {this.review, this.rating});
}
