import 'package:bloc/bloc.dart';
import 'package:delni_rms/features/paymentcart/data/repo/checkoutrepo.dart';
import 'package:equatable/equatable.dart';

part 'checkoutinfo_state.dart';

class CheckoutinfoCubit extends Cubit<CheckoutinfoState> {
  final CheckoutRepo repo;

  CheckoutinfoCubit(this.repo) : super(CheckoutinfoInitial());

  // 1. جلب بيانات صفحة Checkout
  Future<void> getCheckoutData() async {
    emit(GetCheckoutDataLoading());
    final response = await repo.getCheckoutData();
    response.fold(
      (errMessage) => emit(GetCheckoutDataFailure(errMessage)),
      (checkoutData) =>
          emit(GetCheckoutDataSuccess(checkoutData: checkoutData)),
    );
  }

  // 2. حفظ أو تحديث بيانات العنوان
  Future<void> saveUserAddress({
    required String accessToken,
    required String country,
    required String firstName,
    required String lastName,
    required String streetAddress,
    required String streetAddress2,
    required String city,
    required String state,
    required String phone,
  }) async {
    emit(SaveUserAddressLoading());
    final response = await repo.saveUserAddress(
      accessToken: accessToken,
      country: country,
      firstName: firstName,
      lastName: lastName,
      streetAddress: streetAddress,
      streetAddress2: streetAddress2,
      city: city,
      state: state,
      phone: phone,
    );
    response.fold((errMessage) => emit(SaveUserAddressFailure(errMessage)), (
      message,
    ) {
      emit(SaveUserAddressSuccess(message));
      getCheckoutData();
    });
  }

  // 3. تحديث طريقة التوصيل (Fulfillment Method)
  Future<void> updateFulfillmentMethod({
    required String accessToken,
    required int fulfillmentMethodId,
  }) async {
    emit(UpdateFulfillmentLoading());
    final response = await repo.updateFulfillmentMethod(
      accessToken: accessToken,
      fulfillmentMethodId: fulfillmentMethodId,
    );
    response.fold((errMessage) => emit(UpdateFulfillmentFailure(errMessage)), (
      message,
    ) {
      emit(UpdateFulfillmentSuccess(message));
      getCheckoutData();
    });
  }
}
