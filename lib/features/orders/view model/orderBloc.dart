import 'package:delni_rms/features/orders/model/orderModel.dart';
import 'package:delni_rms/features/orders/view%20model/orderEvent.dart';
import 'package:delni_rms/features/orders/view%20model/orderState.dart';
import 'package:delni_rms/features/orders/view%20model/ordersRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  final OrdersRepository _repository;

  OrdersBloc({required OrdersRepository repository})
    : _repository = repository,
      super(OrdersInitial()) {
    on<LoadOrders>(_onLoadOrders);
    on<RefreshOrders>(_onRefreshOrders);
    on<LoadOrderDetails>(_onLoadOrderDetails);
    on<TrackOrder>(_onTrackOrder);
    on<ReviewOrder>(_onReviewOrder);
    on<ConfirmOrderViaQr>(_onConfirmOrderViaQr);
  }

  Future<void> _onLoadOrders(
    LoadOrders event,
    Emitter<OrdersState> emit,
  ) async {
    emit(OrdersLoading());
    try {
      final orders = await _repository.getOrders();
      emit(OrdersLoaded(orders));
    } catch (e) {
      emit(const OrdersError('Failed to load orders'));
    }
  }

  Future<void> _onRefreshOrders(
    RefreshOrders event,
    Emitter<OrdersState> emit,
  ) async {
    emit(OrdersLoading());
    try {
      final orders = await _repository.getOrders();
      emit(OrdersLoaded(orders));
    } catch (e) {
      emit(const OrdersError('Failed to refresh orders'));
    }
  }

  Future<void> _onLoadOrderDetails(
    LoadOrderDetails event,
    Emitter<OrdersState> emit,
  ) async {
    emit(OrdersLoading());
    try {
      final order = await _repository.getOrderById(event.orderId);
      emit(OrderDetailsLoaded(order));
    } catch (e) {
      emit(const OrdersError('Failed to load order details'));
    }
  }

  Future<void> _onTrackOrder(
    TrackOrder event,
    Emitter<OrdersState> emit,
  ) async {
    emit(OrderActionInProgress(event.orderId));
    try {
      await _repository.trackOrder(event.orderId);
      final order = await _repository.getOrderById(event.orderId);
      emit(OrderDetailsLoaded(order));
    } catch (e) {
      emit(const OrdersError('Tracking failed'));
    }
  }

  Future<void> _onReviewOrder(
    ReviewOrder event,
    Emitter<OrdersState> emit,
  ) async {
    emit(OrderActionInProgress(event.orderId));
    try {
      await _repository.reviewOrder(
        event.orderId,
        review: event.review,
        rating: event.rating,
      );
      final orders = await _repository.getOrders();
      emit(OrdersLoaded(orders));
    } catch (e) {
      emit(const OrdersError('Review action failed'));
    }
  }

  Future<void> _onConfirmOrderViaQr(
    ConfirmOrderViaQr event,
    Emitter<OrdersState> emit,
  ) async {
    if (event.scannedCode.trim() != event.orderNumber.trim()) {
      emit(const OrdersError('QR code does not match this order'));
      return;
    }

    emit(OrderActionInProgress(event.orderId));
    try {
      final updatedOrder = await _repository.changeOrderStatus(
        event.orderId,
        OrderStatus.Confirmed,
      );
      emit(OrderDetailsLoaded(updatedOrder));
    } catch (e) {
      emit(const OrdersError('Failed to confirm order'));
    }
  }
}
