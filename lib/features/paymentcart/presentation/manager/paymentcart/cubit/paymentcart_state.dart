import 'package:delni_rms/features/paymentcart/data/model/cartitem/cartitem.dart';
import 'package:equatable/equatable.dart';

sealed class PaymentcartState extends Equatable {
  const PaymentcartState();

  @override
  List<Object> get props => [];
}

final class CartInitial extends PaymentcartState {}

// 1. جلب بيانات السلة (Get Cart)
final class FetchCartLoading extends PaymentcartState {}

final class FetchCartSuccess extends PaymentcartState {
  final Cartitem cartModel; // استبدلها باسم الموديل الخاص بالسلة لديك

  const FetchCartSuccess({required this.cartModel});

  @override
  List<Object> get props => [cartModel];
}

final class FetchCartFailure extends PaymentcartState {
  final String errorMessage;
  const FetchCartFailure(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

// 2. حذف منتج من السلة (Remove from Cart)
final class RemoveFromCartLoading extends PaymentcartState {}

final class RemoveFromCartSuccess extends PaymentcartState {
  final String message;
  const RemoveFromCartSuccess(this.message);

  @override
  List<Object> get props => [message];
}

final class RemoveFromCartFailure extends PaymentcartState {
  final String errorMessage;
  const RemoveFromCartFailure(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

// 3. تعديل كمية المنتج (Update Quantity)
final class UpdateQuantityLoading extends PaymentcartState {}

final class UpdateQuantitySuccess extends PaymentcartState {
  final String message;
  const UpdateQuantitySuccess(this.message);

  @override
  List<Object> get props => [message];
}

final class UpdateQuantityFailure extends PaymentcartState {
  final String errorMessage;
  const UpdateQuantityFailure(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

// 4. تعديل عنوان الشحن (Update Shipping Address)
final class UpdateShippingAddressLoading extends PaymentcartState {}

final class UpdateShippingAddressSuccess extends PaymentcartState {
  final String message;
  const UpdateShippingAddressSuccess(this.message);

  @override
  List<Object> get props => [message];
}

final class UpdateShippingAddressFailure extends PaymentcartState {
  final String errorMessage;
  const UpdateShippingAddressFailure(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

// 5. إعادة إضافة منتج من الطلبات السابقة (Reorder)
final class ReorderLoading extends PaymentcartState {}

final class ReorderSuccess extends PaymentcartState {
  final String message;
  const ReorderSuccess(this.message);

  @override
  List<Object> get props => [message];
}

final class ReorderFailure extends PaymentcartState {
  final String errorMessage;
  const ReorderFailure(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

// 6. تنفيذ عملية Checkout
final class CheckoutLoading extends PaymentcartState {}

final class CheckoutSuccess extends PaymentcartState {
  final Map<String, dynamic> checkoutData;
  const CheckoutSuccess({required this.checkoutData});

  @override
  List<Object> get props => [checkoutData];
}

final class CheckoutFailure extends PaymentcartState {
  final String errorMessage;
  const CheckoutFailure(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

// 7. جلب عناوين المستخدم (اختياري)
final class FetchAddressesLoading extends PaymentcartState {}

final class FetchAddressesSuccess extends PaymentcartState {
  final dynamic addressesData;
  const FetchAddressesSuccess({required this.addressesData});

  @override
  List<Object> get props => [addressesData];
}

final class FetchAddressesFailure extends PaymentcartState {
  final String errorMessage;
  const FetchAddressesFailure(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
