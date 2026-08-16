import 'package:delni_rms/constants.dart';
import 'package:delni_rms/core1/utils/size_utils.dart';
import 'package:delni_rms/core1/utils/styles.dart';
import 'package:delni_rms/features/paymentcart/presentation/views/checkoutinfo.dart';
import 'package:flutter/material.dart';

class Checkoutbottombar extends StatelessWidget {
  final List<Map<String, dynamic>> cartItems;
  const Checkoutbottombar({super.key, required this.cartItems});

  double get totalPrice {
    return cartItems.fold(
      0.0,
      (sum, item) =>
          sum +
          ((item['price'] as num).toDouble() *
              (item['quantity'] as num).toInt()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.h),
      decoration: BoxDecoration(
        color: appTheme.whitecolor,
        boxShadow: [
          BoxShadow(
            color: appTheme.writecolor,
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Total \$${totalPrice.toStringAsFixed(2).replaceAll('.', ',')}",
            style: TextStyleHelper.instance.headline24Bold.copyWith(
              fontSize: 16,
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: appTheme.primarycolor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            onPressed: cartItems.isEmpty
                ? null
                : () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Checkoutinfo(),
                      ),
                      (route) => false,
                    );
                  },
            child: Text(
              "Checkout",
              style: TextStyleHelper.instance.headline24Bold.copyWith(
                color: appTheme.secondcolor,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
