import 'package:delni_rms/constants.dart';
import 'package:delni_rms/core1/utils/size_utils.dart';
import 'package:delni_rms/core1/utils/styles.dart';
import 'package:flutter/material.dart';

class Pastorder extends StatelessWidget {
  final List<Map<String, dynamic>> pastOrders;
  final Function(int) onRemovePastOrder;
  final Function(Map<String, dynamic>) onReorder;

  Pastorder({
    super.key,
    required this.pastOrders,
    required this.onRemovePastOrder,
    required this.onReorder,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 8.h),
          child: Text(
            "past order",
            style: TextStyleHelper.instance.headline24Bold.copyWith(
              color: appTheme.writecolor,
              fontSize: 18,
            ),
          ),
        ),
        pastOrders.isEmpty
            ? Padding(
                padding: EdgeInsets.all(20.h),
                child: Center(
                  child: Text(
                    "Not there past order",
                    style: TextStyleHelper.instance.headline24Bold.copyWith(
                      color: appTheme.secondcolor,
                      fontSize: 20,
                    ),
                  ),
                ),
              )
            : ListView.builder(
                itemCount: pastOrders.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final order = pastOrders[index];
                  return Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 16.h,
                      vertical: 4.h,
                    ),
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
                                width: 50.h,
                                height: 50.h,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(
                                      width: 50.h,
                                      height: 50.h,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius: BorderRadius.circular(
                                          8.h,
                                        ),
                                      ),
                                      child: Icon(
                                        Icons.image,
                                        size: 18,
                                        color: appTheme.greycolor,
                                      ),
                                    ),
                              ),
                            ),
                            Positioned(
                              top: 2.h,
                              left: 2.h,
                              child: InkWell(
                                onTap: () => onRemovePastOrder(index),
                                child: Container(
                                  padding: EdgeInsets.all(3.h),
                                  decoration: BoxDecoration(
                                    color: appTheme.backgroundcolor,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.delete_outline,
                                    size: 10,
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
                                order['name'],
                                style: TextStyleHelper.instance.headline24Bold
                                    .copyWith(fontSize: 11),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                "\$${order['price'].toStringAsFixed(2).replaceAll('.', ',')}",
                                style: TextStyleHelper.instance.headline24Bold
                                    .copyWith(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 6.h,
                                vertical: 2.h,
                              ),
                              decoration: BoxDecoration(
                                color: appTheme.backgroundcolor,
                                borderRadius: BorderRadius.circular(4.h),
                              ),
                              child: Text(
                                order['color'],
                                style: TextStyleHelper.instance.headline24Bold
                                    .copyWith(fontSize: 9),
                              ),
                            ),
                            SizedBox(width: 4.h),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 6.h,
                                vertical: 2.h,
                              ),
                              decoration: BoxDecoration(
                                color: appTheme.backgroundcolor,
                                borderRadius: BorderRadius.circular(4.h),
                              ),
                              child: Text(
                                order['size'],
                                style: TextStyleHelper.instance.headline24Bold
                                    .copyWith(fontSize: 9),
                              ),
                            ),
                            SizedBox(width: 6.h),
                            IconButton(
                              icon: Icon(
                                Icons.shopping_cart_outlined,
                                color: appTheme.primarycolor,
                                size: 20,
                              ),
                              onPressed: () => onReorder(order),
                              tooltip: "إضافة إلى السلة",
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
