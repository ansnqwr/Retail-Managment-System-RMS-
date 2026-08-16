import 'package:bloc/bloc.dart';
import 'package:delni_rms/features/paymentcart/data/repo/shippingandaddressrepo.dart';
import 'package:equatable/equatable.dart';

part 'shippingandaddress_state.dart';

class ShippingandaddressCubit extends Cubit<ShippingandaddressState> {
  final AddressAndShippingRepo repo;

  ShippingandaddressCubit(this.repo) : super(ShippingandaddressInitial());

  // 4. جلب جميع العناوين
  Future<void> getAddresses() async {
    emit(GetAddressesLoading());
    final response = await repo.getAddresses();
    response.fold(
      (errMessage) => emit(GetAddressesFailure(errMessage)),
      (addressesData) =>
          emit(GetAddressesSuccess(addressesData: addressesData)),
    );
  }

  // 5. إضافة عنوان جديد
  Future<void> addAddress({
    required String country,
    required String firstName,
    required String lastName,
    required String streetAddress,
    String streetAddress2 = "",
    required String city,
    required String state,
    required String phone,
  }) async {
    emit(AddAddressLoading());
    final response = await repo.addAddress(
      country: country,
      firstName: firstName,
      lastName: lastName,
      streetAddress: streetAddress,
      streetAddress2: streetAddress2,
      city: city,
      state: state,
      phone: phone,
    );
    response.fold((errMessage) => emit(AddAddressFailure(errMessage)), (
      message,
    ) {
      emit(AddAddressSuccess(message));
      getAddresses();
    });
  }

  // 6. تعديل عنوان
  Future<void> updateAddress({
    required int addressId,
    required String country,
    required String firstName,
    required String lastName,
    required String streetAddress,
    String streetAddress2 = "",
    required String city,
    required String state,
    required String phone,
  }) async {
    emit(UpdateAddressLoading());
    final response = await repo.updateAddress(
      addressId: addressId,
      country: country,
      firstName: firstName,
      lastName: lastName,
      streetAddress: streetAddress,
      streetAddress2: streetAddress2,
      city: city,
      state: state,
      phone: phone,
    );
    response.fold((errMessage) => emit(UpdateAddressFailure(errMessage)), (
      message,
    ) {
      emit(UpdateAddressSuccess(message));
      getAddresses();
    });
  }

  // 7. حذف عنوان
  Future<void> deleteAddress({required int addressId}) async {
    emit(DeleteAddressLoading());
    final response = await repo.deleteAddress(addressId: addressId);
    response.fold((errMessage) => emit(DeleteAddressFailure(errMessage)), (
      message,
    ) {
      emit(DeleteAddressSuccess(message));
      getAddresses();
    });
  }

  // 8. اختيار عنوان التوصيل
  Future<void> selectAddress({required int addressId}) async {
    emit(SelectAddressLoading());
    final response = await repo.selectAddress(addressId: addressId);
    response.fold(
      (errMessage) => emit(SelectAddressFailure(errMessage)),
      (message) => emit(SelectAddressSuccess(message)),
    );
  }

  // 9. جلب شركات الشحن
  Future<void> getShippingProviders() async {
    emit(GetShippingProvidersLoading());
    final response = await repo.getShippingProviders();
    response.fold(
      (errMessage) => emit(GetShippingProvidersFailure(errMessage)),
      (providersData) =>
          emit(GetShippingProvidersSuccess(providersData: providersData)),
    );
  }

  // 10. اختيار شركة الشحن
  Future<void> selectShippingProvider({required int providerId}) async {
    emit(SelectShippingProviderLoading());
    final response = await repo.selectShippingProvider(providerId: providerId);
    response.fold(
      (errMessage) => emit(SelectShippingProviderFailure(errMessage)),
      (message) => emit(SelectShippingProviderSuccess(message)),
    );
  }
}
