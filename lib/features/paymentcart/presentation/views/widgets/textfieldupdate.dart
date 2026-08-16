import 'package:delni_rms/constants.dart';
import 'package:delni_rms/core1/utils/size_utils.dart';
import 'package:delni_rms/core1/utils/styles.dart';
import 'package:flutter/material.dart';

class Textfieldupdate extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final TextInputType keyboardType;

  Textfieldupdate({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyleHelper.instance.headline24Bold.copyWith(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: appTheme.writecolor,
          ),
        ),
        SizedBox(height: 6.h),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: TextStyleHelper.instance.headline24Bold.copyWith(
            fontSize: 14,
            color: appTheme.primarycolor,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyleHelper.instance.headline24Bold.copyWith(
              color: appTheme.writecolor,
              fontSize: 13,
            ),
            filled: true,
            fillColor: appTheme.whitecolor,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade200, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: appTheme.primarycolor, width: 1.3),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 14.h,
              vertical: 13.h,
            ),
          ),
        ),
      ],
    );
  }
}
