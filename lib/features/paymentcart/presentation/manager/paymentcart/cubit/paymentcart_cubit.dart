import 'package:delni_rms/features/paymentcart/data/repo/cartrepo.dart';
import 'package:delni_rms/features/paymentcart/presentation/manager/paymentcart/cubit/paymentcart_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartCubit extends Cubit<PaymentcartState> {
  final CartRepo repo;
  CartCubit(this.repo) : super(CartInitial());

  // 1. جلب بيانات السلة
  Future<void> getCart() async {
    print("🔄 [CartCubit] getCart() called!");
    emit(FetchCartLoading());
    final response = await repo.getCart();
    response.fold(
      (errMessage) {
        print("❌ [CartCubit] getCart Failed: $errMessage");
        emit(FetchCartFailure(errMessage));
      },
      (cartModel) {
        print("✅ [CartCubit] getCart Success! Emitting FetchCartSuccess...");
        emit(FetchCartSuccess(cartModel: cartModel));
      },
    );
  }

  // 2. حذف منتج من السلة وتحديث السلة تلقائياً
  Future<void> removeFromCart(int cartId) async {
    emit(RemoveFromCartLoading());
    final response = await repo.removeFromCart(cartId: cartId);
    response.fold((errMessage) => emit(RemoveFromCartFailure(errMessage)), (
      message,
    ) {
      emit(RemoveFromCartSuccess(message));
      getCart();
    });
  }

  // 3. تعديل كمية المنتج وتحديث السلة تلقائياً
  Future<void> updateQuantity({
    required int cartId,
    required int quantity,
  }) async {
    emit(UpdateQuantityLoading());
    final response = await repo.updateQuantity(
      cartId: cartId,
      quantity: quantity,
    );
    response.fold((errMessage) => emit(UpdateQuantityFailure(errMessage)), (
      message,
    ) {
      emit(UpdateQuantitySuccess(message));
      getCart();
    });
  }

  // 4. تعديل عنوان الشحن وتحديث السلة تلقائياً
  Future<void> updateShippingAddress(int addressId) async {
    emit(UpdateShippingAddressLoading());
    final response = await repo.updateShippingAddress(addressId: addressId);
    response.fold(
      (errMessage) => emit(UpdateShippingAddressFailure(errMessage)),
      (message) {
        emit(UpdateShippingAddressSuccess(message));
        getCart();
      },
    );
  }

  // 5. إعادة إضافة منتج من الطلبات السابقة وتحديث السلة
  Future<void> reorderProduct({
    required int productId,
    required String selectedColor,
    required String selectedSize,
    required int quantity,
  }) async {
    emit(ReorderLoading());
    final response = await repo.reorderProduct(
      productId: productId,
      selectedColor: selectedColor,
      selectedSize: selectedSize,
      quantity: quantity,
    );
    response.fold((errMessage) => emit(ReorderFailure(errMessage)), (message) {
      emit(ReorderSuccess(message));
      getCart();
    });
  }

  // 6. تنفيذ عملية Checkout
  Future<void> checkout() async {
    emit(CheckoutLoading());
    final response = await repo.checkout();
    response.fold(
      (errMessage) => emit(CheckoutFailure(errMessage)),
      (checkoutData) => emit(CheckoutSuccess(checkoutData: checkoutData)),
    );
  }

  // 7. جلب عناوين المستخدم
  Future<void> getAddresses() async {
    emit(FetchAddressesLoading());
    final response = await repo.getAddresses();
    response.fold(
      (errMessage) => emit(FetchAddressesFailure(errMessage)),
      (addressesData) =>
          emit(FetchAddressesSuccess(addressesData: addressesData)),
    );
  }
}
