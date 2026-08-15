import 'package:delni_rms/features/orders/model/orderModel.dart';
import 'package:equatable/equatable.dart';

abstract class OrdersState extends Equatable {
  const OrdersState();
  @override
  List<Object?> get props => [];
}

class OrdersInitial extends OrdersState {}

class OrdersLoading extends OrdersState {}

class OrdersLoaded extends OrdersState {
  final List<Order> orders;
  const OrdersLoaded(this.orders);

  @override
  List<Object?> get props => [orders];
}

class OrderDetailsLoaded extends OrdersState {
  final Order order;
  const OrderDetailsLoaded(this.order);

  @override
  List<Object?> get props => [order];
}

class OrdersError extends OrdersState {
  final String message;
  const OrdersError(this.message);

  @override
  List<Object?> get props => [message];
}

class OrderActionInProgress extends OrdersState {
  final String orderId;
  const OrderActionInProgress(this.orderId);

  @override
  List<Object?> get props => [orderId];
}
