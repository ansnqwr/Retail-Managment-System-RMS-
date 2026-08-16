import 'package:delni_rms/constants.dart';
import 'package:delni_rms/core1/utils/size_utils.dart';
import 'package:delni_rms/core1/utils/styles.dart';
import 'package:delni_rms/features/paymentcart/presentation/views/widgets/emptycart.dart';
import 'package:flutter/material.dart';

class Itemcart extends StatelessWidget {
  final List<Map<String, dynamic>> cartItems;
  final Function(int) onIncrease;
  final Function(int) onDecrease;
  final Function(int) onRemove;

  const Itemcart({
    super.key,
    required this.cartItems,
    required this.onIncrease,
    required this.onDecrease,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    if (cartItems.isEmpty) {
      return const Emptycart();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 8.h),
          child: Text(
            "Shopping Cart",
            style: TextStyleHelper.instance.headline24Bold.copyWith(
              fontSize: 18,
              color: appTheme.writecolor,
            ),
          ),
        ),
        ListView.builder(
          itemCount: cartItems.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final item = cartItems[index];
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 16.h, vertical: 4.h),
              padding: EdgeInsets.all(8.h),
              decoration: BoxDecoration(
                color: appTheme.whitecolor,
                borderRadius: BorderRadius.circular(12.h),
                boxShadow: [
                  BoxShadow(
                    color: appTheme.primarycolor,
                    blurRadius: 3,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.h),
                        child: Image.asset(
                          'assets/images/product test.PNG',
                          width: 55.h,
                          height: 55.h,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                                width: 55.h,
                                height: 55.h,
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(8.h),
                                ),
                                child: const Icon(
                                  Icons.image,
                                  size: 20,
                                  color: Colors.grey,
                                ),
                              ),
                        ),
                      ),
                      Positioned(
                        top: 2.h,
                        left: 2.h,
                        child: InkWell(
                          onTap: () => onRemove(index),
                          child: Container(
                            padding: EdgeInsets.all(3.h),
                            decoration: BoxDecoration(
                              color: appTheme.backgroundcolor,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.delete_outline,
                              size: 12,
                              color: appTheme.redcolor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 10.h),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['name'],
                          style: TextStyleHelper.instance.headline24Bold
                              .copyWith(fontSize: 11),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          "\$${item['price'].toStringAsFixed(2).replaceAll('.', ',')}",
                          style: TextStyleHelper.instance.headline24Bold
                              .copyWith(fontSize: 10),
                        ),
                        Text(
                          "${item['color']}, ${item['size']}",
                          style: TextStyleHelper.instance.headline24Bold
                              .copyWith(
                                fontSize: 9,
                                color: appTheme.secondcolor,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline, size: 18),
                        onPressed: () => onDecrease(index),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 6.0.h),
                        child: Text(
                          "${item['quantity']}",
                          style: TextStyleHelper.instance.headline24Bold
                              .copyWith(fontSize: 12),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline, size: 18),
                        onPressed: () => onIncrease(index),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
