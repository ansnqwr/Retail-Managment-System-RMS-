import 'package:delni_rms/constants.dart';
import 'package:delni_rms/core1/utils/size_utils.dart';
import 'package:delni_rms/core1/utils/styles.dart';
import 'package:delni_rms/features/paymentcart/presentation/manager/paymentcart/cubit/paymentcart_cubit.dart';
import 'package:delni_rms/features/paymentcart/presentation/manager/paymentcart/cubit/paymentcart_state.dart';
import 'package:delni_rms/features/paymentcart/presentation/views/widgets/AppBarpaymentcartCustomer.dart';
import 'package:delni_rms/features/paymentcart/presentation/views/widgets/buildshippingaddresssection.dart';
import 'package:delni_rms/features/paymentcart/presentation/views/widgets/checkoutbottombar.dart';
import 'package:delni_rms/features/paymentcart/presentation/views/widgets/itemcart.dart';
import 'package:delni_rms/features/paymentcart/presentation/views/widgets/pastorder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaymentCartViewBody extends StatefulWidget {
  const PaymentCartViewBody({super.key});

  @override
  State<PaymentCartViewBody> createState() => _PaymentCartViewBodyState();
}

class _PaymentCartViewBodyState extends State<PaymentCartViewBody> {
  List<Map<String, dynamic>> cartItems = [];
  List<Map<String, dynamic>> pastOrders = [];

  int get cartCount =>
      cartItems.fold(0, (sum, item) => sum + (item['quantity'] as int));

  @override
  void initState() {
    super.initState();
    print("🖥️ [PaymentCartViewBody] initState -> calling fetch data");
    _fetchPageData();
  }

  // دالة لجلب البيانات المطلوبة من الـ Cubit
  void _fetchPageData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<CartCubit>().getCart();
      }
    });
  }

  void _increaseCartItem(int index) {
    final item = cartItems[index];
    final cartId = item['cart_id'];
    final currentQty = item['quantity'] as int;

    context.read<CartCubit>().updateQuantity(
      cartId: cartId,
      quantity: currentQty + 1,
    );
  }

  void _decreaseCartItem(int index) {
    final item = cartItems[index];
    final cartId = item['cart_id'];
    int currentQty = item['quantity'] as int;
    if (currentQty > 1) {
      context.read<CartCubit>().updateQuantity(
        cartId: cartId,
        quantity: currentQty - 1,
      );
    }
  }

  void _removeCartItem(int index) {
    final item = cartItems[index];
    final cartId = item['cart_id'];
    context.read<CartCubit>().removeFromCart(cartId);
  }

  void _removePastOrder(int index) {
    setState(() {
      pastOrders.removeAt(index);
    });
  }

  void _reorderItem(Map<String, dynamic> order) {
    context.read<CartCubit>().reorderProduct(
      productId: order['product_id'] ?? 0,
      selectedColor: order['color'] ?? '',
      selectedSize: order['size'] ?? '',
      quantity: 1,
    );

    // تحديث السلة مباشرة بعد إعادة الطلب
    context.read<CartCubit>().getCart();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: appTheme.primarycolor,
        content: Text(
          "Add to Cart Success",
          style: TextStyleHelper.instance.headline24Bold.copyWith(
            fontSize: 12,
            color: appTheme.secondcolor,
          ),
        ),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // لاستدعاء جلب البيانات كلما تم بناء الـ Widget (عند الانتقال لها من أي مكان في التطبيق)
    _fetchPageData();

    return BlocConsumer<CartCubit, PaymentcartState>(
      listener: (context, state) {
        if (state is FetchCartFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: appTheme.primarycolor,
              content: Text(
                state.errorMessage,
                style: TextStyleHelper.instance.headline24Bold.copyWith(
                  fontSize: 12,
                  color: appTheme.secondcolor,
                ),
              ),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      },
      builder: (context, state) {
        print("🎨 [PaymentCartViewBody] Current State: ${state.runtimeType}");

        if (state is FetchCartSuccess) {
          final cartModel = state.cartModel;

          cartItems =
              cartModel.cartItems
                  ?.map(
                    (item) => {
                      "cart_id": item.cartId ?? 0,
                      "name": item.name ?? "",
                      "price": item.price ?? 0,
                      "size": item.selectedSize ?? "",
                      "color": item.selectedColor ?? "",
                      "quantity": item.quantity ?? 1,
                      "image_url": item.imageUrl ?? "",
                    },
                  )
                  .toList() ??
              [];

          pastOrders =
              cartModel.pastOrders
                  ?.map(
                    (order) => {
                      "product_id": order.productId ?? 0,
                      "name": order.name ?? "",
                      "price": order.price ?? 0,
                      "size": order.selectedSize ?? "",
                      "color": order.selectedColor ?? "",
                    },
                  )
                  .toList() ??
              [];
        }

        return Scaffold(
          backgroundColor: appTheme.whitecolor,
          appBar: Appbarpaymentcartcustomer(cartCount: cartCount),
          body: Column(
            children: [
              state is FetchAddressesLoading
                  ? Container(
                      padding: const EdgeInsets.all(20),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: appTheme.primarycolor,
                        ),
                      ),
                    )
                  : Buildshippingaddresssection(
                      shippingaddress: state is FetchAddressesSuccess
                          ? state.addressesData.toString()
                          : (state is FetchCartSuccess
                                ? state.cartModel.shippingAddress?.fullAddress
                                : null),
                    ),
              state is FetchCartLoading
                  ? Expanded(
                      child: Center(
                        child: CircularProgressIndicator(
                          color: appTheme.primarycolor,
                        ),
                      ),
                    )
                  : Expanded(
                      child: ListView(
                        padding: EdgeInsets.zero,
                        children: [
                          Itemcart(
                            cartItems: cartItems,
                            onIncrease: _increaseCartItem,
                            onDecrease: _decreaseCartItem,
                            onRemove: _removeCartItem,
                          ),
                          Divider(thickness: 1, height: 20.h),
                          Pastorder(
                            pastOrders: pastOrders,
                            onRemovePastOrder: _removePastOrder,
                            onReorder: _reorderItem,
                          ),
                        ],
                      ),
                    ),
              Checkoutbottombar(cartItems: cartItems),
            ],
          ),
        );
      },
    );
  }
}
