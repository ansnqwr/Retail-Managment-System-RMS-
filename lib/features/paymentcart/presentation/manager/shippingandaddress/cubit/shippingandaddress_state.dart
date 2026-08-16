part of 'shippingandaddress_cubit.dart';

sealed class ShippingandaddressState extends Equatable {
  const ShippingandaddressState();

  @override
  List<Object> get props => [];
}

final class ShippingandaddressInitial extends ShippingandaddressState {}

// 4. جلب جميع العناوين
final class GetAddressesLoading extends ShippingandaddressState {}

final class GetAddressesSuccess extends ShippingandaddressState {
  final Map<String, dynamic> addressesData;
  const GetAddressesSuccess({required this.addressesData});

  @override
  List<Object> get props => [addressesData];
}

final class GetAddressesFailure extends ShippingandaddressState {
  final String errorMessage;
  const GetAddressesFailure(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

// 5. إضافة عنوان جديد
final class AddAddressLoading extends ShippingandaddressState {}

final class AddAddressSuccess extends ShippingandaddressState {
  final String message;
  const AddAddressSuccess(this.message);

  @override
  List<Object> get props => [message];
}

final class AddAddressFailure extends ShippingandaddressState {
  final String errorMessage;
  const AddAddressFailure(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

// 6. تعديل عنوان
final class UpdateAddressLoading extends ShippingandaddressState {}

final class UpdateAddressSuccess extends ShippingandaddressState {
  final String message;
  const UpdateAddressSuccess(this.message);

  @override
  List<Object> get props => [message];
}

final class UpdateAddressFailure extends ShippingandaddressState {
  final String errorMessage;
  const UpdateAddressFailure(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

// 7. حذف عنوان
final class DeleteAddressLoading extends ShippingandaddressState {}

final class DeleteAddressSuccess extends ShippingandaddressState {
  final String message;
  const DeleteAddressSuccess(this.message);

  @override
  List<Object> get props => [message];
}

final class DeleteAddressFailure extends ShippingandaddressState {
  final String errorMessage;
  const DeleteAddressFailure(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

// 8. اختيار عنوان التوصيل
final class SelectAddressLoading extends ShippingandaddressState {}

final class SelectAddressSuccess extends ShippingandaddressState {
  final String message;
  const SelectAddressSuccess(this.message);

  @override
  List<Object> get props => [message];
}

final class SelectAddressFailure extends ShippingandaddressState {
  final String errorMessage;
  const SelectAddressFailure(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

// 9. جلب شركات الشحن
final class GetShippingProvidersLoading extends ShippingandaddressState {}

final class GetShippingProvidersSuccess extends ShippingandaddressState {
  final Map<String, dynamic> providersData;
  const GetShippingProvidersSuccess({required this.providersData});

  @override
  List<Object> get props => [providersData];
}

final class GetShippingProvidersFailure extends ShippingandaddressState {
  final String errorMessage;
  const GetShippingProvidersFailure(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

// 10. اختيار شركة الشحن
final class SelectShippingProviderLoading extends ShippingandaddressState {}

final class SelectShippingProviderSuccess extends ShippingandaddressState {
  final String message;
  const SelectShippingProviderSuccess(this.message);

  @override
  List<Object> get props => [message];
}

final class SelectShippingProviderFailure extends ShippingandaddressState {
  final String errorMessage;
  const SelectShippingProviderFailure(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
