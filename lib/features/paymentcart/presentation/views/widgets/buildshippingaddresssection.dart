import 'package:delni_rms/constants.dart';
import 'package:delni_rms/core1/utils/size_utils.dart';
import 'package:delni_rms/core1/utils/styles.dart';
import 'package:delni_rms/features/paymentcart/presentation/views/widgets/updateuserinformationviewbody.dart';
import 'package:flutter/material.dart';

class Buildshippingaddresssection extends StatelessWidget {
  final String? shippingaddress;
  const Buildshippingaddresssection({super.key, required this.shippingaddress});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 14.h, vertical: 4.h),
      padding: EdgeInsets.all(12.h),
      decoration: BoxDecoration(
        color: appTheme.backgroundcolor,
        borderRadius: BorderRadius.circular(12.h),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Shipping Address",
                  style: TextStyleHelper.instance.headline24Bold.copyWith(
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  "26, Duong So 2, Thao Dien Ward, An Phu, District 2",
                  style: TextStyleHelper.instance.headline24Bold.copyWith(
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.edit, color: appTheme.primarycolor, size: 22),
            onPressed: () async {
              await Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => Updateuserinformationviewbody(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
