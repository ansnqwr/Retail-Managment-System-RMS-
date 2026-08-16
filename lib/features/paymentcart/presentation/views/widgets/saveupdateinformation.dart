import 'package:delni_rms/constants.dart';
import 'package:delni_rms/core1/utils/size_utils.dart';
import 'package:delni_rms/features/paymentcart/presentation/manager/checkoutinfo/cubit/checkoutinfo_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Saveupdateinformation extends StatelessWidget {
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController streetAddressController;
  final TextEditingController streetAddress2Controller;
  final TextEditingController cityController;
  final TextEditingController stateController;
  final TextEditingController phoneController;
  final TextEditingController countryController;

  const Saveupdateinformation({
    super.key,
    required this.firstNameController,
    required this.lastNameController,
    required this.streetAddressController,
    required this.streetAddress2Controller,
    required this.cityController,
    required this.stateController,
    required this.phoneController,
    required this.countryController,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50.h,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: appTheme.primarycolor,
          elevation: 3,
          shadowColor: appTheme.primarycolor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () {
          // طباعة للتأكد من أن الزر استابح الضغط
          debugPrint('🟢 [SaveButton] Save Changes button was pressed!');

          // طباعة قيم الحقول للتأكد من أنها مليئة وليست فارغة
          debugPrint('-----------------------------------------');
          debugPrint('First Name: ${firstNameController.text}');
          debugPrint('Last Name: ${lastNameController.text}');
          debugPrint('Street Address: ${streetAddressController.text}');
          debugPrint('Street Address 2: ${streetAddress2Controller.text}');
          debugPrint('City: ${cityController.text}');
          debugPrint('State: ${stateController.text}');
          debugPrint('Phone: ${phoneController.text}');
          debugPrint('Country: ${countryController.text}');
          debugPrint('-----------------------------------------');

          // استدعاء دالة الحفظ في الـ Cubit مع تمرير البارامترات المطلوبة
          try {
            context.read<CheckoutinfoCubit>().saveUserAddress(
              accessToken: "3|MuVHIKIvqTeg16qIU8YMrLvqra6vwTdPIZS0Qs7Kae091cff",
              country: countryController.text,
              firstName: firstNameController.text,
              lastName: lastNameController.text,
              streetAddress: streetAddressController.text,
              streetAddress2: streetAddress2Controller.text,
              city: cityController.text,
              state: stateController.text,
              phone: phoneController.text,
            );
            debugPrint(
              '🚀 [SaveButton] saveUserAddress called successfully from Cubit.',
            );
          } catch (e) {
            debugPrint(
              '❌ [SaveButton Error] Failed to call saveUserAddress: $e',
            );
          }
        },
        child: Text(
          "Save Changes",
          style: TextStyle(
            color: appTheme.secondcolor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
