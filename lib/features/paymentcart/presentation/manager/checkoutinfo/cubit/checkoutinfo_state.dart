part of 'checkoutinfo_cubit.dart';

sealed class CheckoutinfoState extends Equatable {
  const CheckoutinfoState();

  @override
  List<Object> get props => [];
}

final class CheckoutinfoInitial extends CheckoutinfoState {}

// 1. جلب بيانات صفحة Checkout
final class GetCheckoutDataLoading extends CheckoutinfoState {}

final class GetCheckoutDataSuccess extends CheckoutinfoState {
  final Map<String, dynamic> checkoutData;
  const GetCheckoutDataSuccess({required this.checkoutData});

  @override
  List<Object> get props => [checkoutData];
}

final class GetCheckoutDataFailure extends CheckoutinfoState {
  final String errorMessage;
  const GetCheckoutDataFailure(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

// 2. حفظ وتحديث العنوان (Save User Address)
final class SaveUserAddressLoading extends CheckoutinfoState {}

final class SaveUserAddressSuccess extends CheckoutinfoState {
  final String message;
  const SaveUserAddressSuccess(this.message);

  @override
  List<Object> get props => [message];
}

final class SaveUserAddressFailure extends CheckoutinfoState {
  final String errorMessage;
  const SaveUserAddressFailure(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

// 3. تحديث طريقة التوصيل (Update Fulfillment Method)
final class UpdateFulfillmentLoading extends CheckoutinfoState {}

final class UpdateFulfillmentSuccess extends CheckoutinfoState {
  final String message;
  const UpdateFulfillmentSuccess(this.message);

  @override
  List<Object> get props => [message];
}

final class UpdateFulfillmentFailure extends CheckoutinfoState {
  final String errorMessage;
  const UpdateFulfillmentFailure(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
