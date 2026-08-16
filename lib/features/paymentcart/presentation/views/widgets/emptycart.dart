import 'package:delni_rms/core1/utils/size_utils.dart';
import 'package:delni_rms/core1/utils/styles.dart';
import 'package:flutter/material.dart';

class Emptycart extends StatelessWidget {
  const Emptycart({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(20.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/Empty Cart.png',
              width: 100.h,
              height: 100.h,
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.shopping_cart_outlined,
                size: 60,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              "The cart Empty",
              style: TextStyleHelper.instance.headline24Bold.copyWith(
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
