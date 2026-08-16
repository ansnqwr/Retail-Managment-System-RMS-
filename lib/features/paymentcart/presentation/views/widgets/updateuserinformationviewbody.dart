import 'package:delni_rms/constants.dart';
import 'package:delni_rms/core1/utils/size_utils.dart';
import 'package:delni_rms/core1/utils/styles.dart';
import 'package:delni_rms/features/paymentcart/presentation/manager/checkoutinfo/cubit/checkoutinfo_cubit.dart';
import 'package:delni_rms/features/paymentcart/presentation/views/payment_cart_view.dart';
import 'package:delni_rms/features/paymentcart/presentation/views/widgets/saveupdateinformation.dart';
import 'package:delni_rms/features/paymentcart/presentation/views/widgets/textfieldupdate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Updateuserinformationviewbody extends StatefulWidget {
  const Updateuserinformationviewbody({super.key});

  @override
  State<Updateuserinformationviewbody> createState() =>
      _UpdateuserinformationviewbodyState();
}

class _UpdateuserinformationviewbodyState
    extends State<Updateuserinformationviewbody> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController streetAddressController = TextEditingController();
  final TextEditingController streetAddress2Controller =
      TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController countryController = TextEditingController();

  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    // إعادة تعيين الـ flag فور دخول الصفحة لضمان جلب البيانات الجديدة من الباك إند دائماً
    _isInitialized = false;

    // جلب بيانات Checkout عند فتح الصفحة
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<CheckoutinfoCubit>().getCheckoutData();
      }
    });
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    streetAddressController.dispose();
    streetAddress2Controller.dispose();
    cityController.dispose();
    stateController.dispose();
    phoneController.dispose();
    countryController.dispose();
    super.dispose();
  }

  // دالة لتعبئة الحقول بالبيانات القادمة من الـ API
  void _populateFields(Map<String, dynamic> data) {
    final user = data['user'] as Map<String, dynamic>?;
    final shippingAddress = data['shipping_address'] as Map<String, dynamic>?;

    // فصل الاسم الأول والأخير بناءً على أول مسافة
    if (user != null && user['name'] != null) {
      String fullName = user['name'].toString().trim();
      List<String> nameParts = fullName.split(' ');
      if (nameParts.isNotEmpty) {
        firstNameController.text = nameParts.first;
        if (nameParts.length > 1) {
          lastNameController.text = nameParts.sublist(1).join(' ');
        }
      }
      phoneController.text = user['phone'] ?? '';
    }

    // تعبئة بيانات العنوان
    if (shippingAddress != null) {
      streetAddressController.text = shippingAddress['address'] ?? '';
      streetAddress2Controller.text = shippingAddress['address_2'] ?? '';
      cityController.text = shippingAddress['city'] ?? '';
      stateController.text = shippingAddress['state'] ?? '';
      countryController.text = shippingAddress['country'] ?? '';

      // إذا كان رقم الهاتف موجوداً في العنوان أيضاً
      if (shippingAddress['phone'] != null && phoneController.text.isEmpty) {
        phoneController.text = shippingAddress['phone'];
      }
    }

    _isInitialized = true;
  }

  void _navigateToCartView() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PaymentCartView()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CheckoutinfoCubit, CheckoutinfoState>(
      listener: (context, state) {
        if (state is GetCheckoutDataSuccess) {
          if (!_isInitialized) {
            _populateFields(state.checkoutData);
          }
        } else if (state is SaveUserAddressSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: appTheme.primarycolor,
              content: Text(
                state.message,
                style: TextStyleHelper.instance.headline24Bold.copyWith(
                  fontSize: 12,
                  color: appTheme.secondcolor,
                ),
              ),
            ),
          );
          // إعادة تعيين الـ flag لتحديث البيانات في المرة القادمة
          _isInitialized = false;
          // العودة إلى واجهة السلة بعد نجاح الحفظ
          _navigateToCartView();
        } else if (state is SaveUserAddressFailure ||
            state is GetCheckoutDataFailure) {
          final errMessage = state is SaveUserAddressFailure
              ? state.errorMessage
              : (state as GetCheckoutDataFailure).errorMessage;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(backgroundColor: Colors.red, content: Text(errMessage)),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: appTheme.backgroundcolor,
          appBar: AppBar(
            backgroundColor: appTheme.backgroundcolor,
            elevation: 0,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new,
                color: appTheme.primarycolor,
                size: 20,
              ),
              onPressed: () {
                // العودة إلى السلة عند الضغط على زر الرجوع في الأبر بار
                _navigateToCartView();
              },
            ),
            title: Text(
              "Update Information",
              style: TextStyleHelper.instance.headline24Bold.copyWith(
                fontSize: 18,
                color: appTheme.primarycolor,
              ),
            ),
            centerTitle: true,
          ),
          body: state is GetCheckoutDataLoading && !_isInitialized
              ? Center(
                  child: CircularProgressIndicator(
                    color: appTheme.primarycolor,
                  ),
                )
              : SafeArea(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(
                      24.0.h,
                      16.0.h,
                      24.0.h,
                      24.0.h,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Please fill in the details below to update your info",
                          style: TextStyleHelper.instance.headline24Bold
                              .copyWith(
                                fontSize: 16,
                                color: appTheme.primarycolor,
                              ),
                        ),
                        SizedBox(height: 22.h),

                        // صف الاسم الأول والأخير
                        Row(
                          children: [
                            Expanded(
                              child: Textfieldupdate(
                                label: "First Name",
                                hint: "First name",
                                controller: firstNameController,
                              ),
                            ),
                            SizedBox(width: 10.h),
                            Expanded(
                              child: Textfieldupdate(
                                label: "Last Name",
                                hint: "Last name",
                                controller: lastNameController,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12.h),

                        Textfieldupdate(
                          label: "Street Address",
                          hint: "House number and street name",
                          controller: streetAddressController,
                        ),
                        SizedBox(height: 12.h),

                        Textfieldupdate(
                          label: "Street Address 2 (Optional)",
                          hint: "Apartment, suite, unit, etc.",
                          controller: streetAddress2Controller,
                        ),
                        SizedBox(height: 12.h),

                        // صف المدينة والـ State
                        Row(
                          children: [
                            Expanded(
                              child: Textfieldupdate(
                                label: "Town / City",
                                hint: "City name",
                                controller: cityController,
                              ),
                            ),
                            SizedBox(width: 10.h),
                            Expanded(
                              child: Textfieldupdate(
                                label: "State",
                                hint: "State",
                                controller: stateController,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12.h),

                        Textfieldupdate(
                          label: "Phone",
                          hint: "+918076534234",
                          controller: phoneController,
                          keyboardType: TextInputType.phone,
                        ),
                        SizedBox(height: 12.h),

                        Textfieldupdate(
                          label: "Country",
                          hint: "Country",
                          controller: countryController,
                        ),
                        SizedBox(height: 30.h),

                        // زر الحفظ
                        state is SaveUserAddressLoading
                            ? Center(
                                child: CircularProgressIndicator(
                                  color: appTheme.primarycolor,
                                ),
                              )
                            : Saveupdateinformation(
                                firstNameController: firstNameController,
                                lastNameController: lastNameController,
                                streetAddressController:
                                    streetAddressController,
                                streetAddress2Controller:
                                    streetAddress2Controller,
                                cityController: cityController,
                                stateController: stateController,
                                phoneController: phoneController,
                                countryController: countryController,
                              ),
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }
}
