import 'package:delni_rms/constants.dart';
import 'package:delni_rms/core1/utils/size_utils.dart';
import 'package:delni_rms/core1/utils/styles.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Appbarpaymentcartcustomer extends StatelessWidget
    implements PreferredSizeWidget {
  final dynamic cartCount;

  const Appbarpaymentcartcustomer({super.key, required this.cartCount});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: appTheme.whitecolor,
      title: Row(
        children: [
          Text("Cart ", style: TextStyleHelper.instance.headline24Bold),
          if (cartCount > 0)
            Container(
              padding: EdgeInsets.all(6.h),
              decoration: BoxDecoration(
                color: appTheme.writecolor,
                shape: BoxShape.circle,
              ),
              child: Text(
                "$cartCount",
                style: TextStyleHelper.instance.headline24Bold.copyWith(
                  fontSize: 20,
                  color: appTheme.secondcolor,
                  fontWeight:
                      FontWeight.w500, // تم تصحيح طريقة كتابة الـ FontWeight
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
