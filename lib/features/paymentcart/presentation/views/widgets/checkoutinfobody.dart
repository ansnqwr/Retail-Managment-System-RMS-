import 'package:delni_rms/constants.dart';
import 'package:delni_rms/core1/utils/size_utils.dart';
import 'package:delni_rms/core1/utils/styles.dart';
import 'package:delni_rms/features/paymentcart/presentation/manager/checkoutinfo/cubit/checkoutinfo_cubit.dart';
import 'package:delni_rms/features/paymentcart/presentation/views/addressAndshipping.dart';
import 'package:delni_rms/features/paymentcart/presentation/views/payment_cart_view.dart';
import 'package:delni_rms/features/paymentcart/presentation/views/updateuserinformation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Checkoutinfobody extends StatefulWidget {
  const Checkoutinfobody({super.key});

  @override
  State<Checkoutinfobody> createState() => _CheckoutinfobodyState();
}

class _CheckoutinfobodyState extends State<Checkoutinfobody> {
  int? selectedFulfillment;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _isInitialized = false;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<CheckoutinfoCubit>().getCheckoutData();
      }
    });
  }

  void _navigateToCartView() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PaymentCartView()),
    );
  }

  void _handleNextStep() {
    if (selectedFulfillment == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Updateuserinformation()),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Addressandshipping()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CheckoutinfoCubit, CheckoutinfoState>(
      listener: (context, state) {
        if (state is GetCheckoutDataSuccess) {
          if (!_isInitialized) {
            final fulfillmentMethods =
                (state.checkoutData["fulfillment_methods"] as List?) ?? [];
            final selectedMethod = fulfillmentMethods.firstWhere(
              (element) => element["selected"] == true,
              orElse: () => fulfillmentMethods.isNotEmpty
                  ? fulfillmentMethods.first
                  : {"id": 1},
            );
            setState(() {
              selectedFulfillment = selectedMethod["id"];
              _isInitialized = true;
            });
          }
        } else if (state is UpdateFulfillmentSuccess) {
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
        } else if (state is GetCheckoutDataFailure ||
            state is UpdateFulfillmentFailure) {
          final errMessage = state is GetCheckoutDataFailure
              ? state.errorMessage
              : (state as UpdateFulfillmentFailure).errorMessage;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(backgroundColor: Colors.red, content: Text(errMessage)),
          );
        }
      },
      builder: (context, state) {
        Map<String, dynamic>? checkoutData;
        if (state is GetCheckoutDataSuccess) {
          checkoutData = state.checkoutData;
        } else if (context.read<CheckoutinfoCubit>().state
            is GetCheckoutDataSuccess) {
          checkoutData =
              (context.read<CheckoutinfoCubit>().state
                      as GetCheckoutDataSuccess)
                  .checkoutData;
        }

        final address =
            checkoutData?["shipping_address"] as Map<String, dynamic>?;
        final shippingAddressContent = address != null
            ? "${address["name"] ?? ''}\n${address["phone"] ?? ''}\n${address["address"] ?? ''}, ${address["city"] ?? ''}, ${address["country"] ?? ''}"
            : "No address added";

        final user = checkoutData?["user"] as Map<String, dynamic>?;
        final userInfoContent = user != null
            ? "${user["name"] ?? ''}\n${user["phone"] ?? ''}\n${user["email"] ?? ''}"
            : "No user info available";

        final List items = (checkoutData?["items"] as List?) ?? [];
        final List fulfillmentMethods =
            (checkoutData?["fulfillment_methods"] as List?) ?? [];

        return Scaffold(
          backgroundColor: appTheme.primarycolor,
          // تم استبدال الـ bottomNavigationBar بزر دائري أنيق أسفل اليمين (FloatingActionButton)
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 10, right: 4),
            child: FloatingActionButton(
              onPressed: _handleNextStep,
              backgroundColor: appTheme.primarycolor,
              elevation: 4,
              shape: const CircleBorder(),
              child: Icon(
                Icons.arrow_forward_rounded,
                color: appTheme.secondcolor,
                size: 24,
              ),
            ),
          ),
          body: state is GetCheckoutDataLoading && !_isInitialized
              ? Center(
                  child: CircularProgressIndicator(color: appTheme.whitecolor),
                )
              : SafeArea(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.h,
                          vertical: 0.h,
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              height: 32.h,
                              width: 32.h,
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                icon: Icon(
                                  Icons.arrow_back,
                                  color: appTheme.whitecolor,
                                  size: 22,
                                ),
                                onPressed: _navigateToCartView,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: appTheme.whitecolor,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(24.h),
                              topRight: Radius.circular(24.h),
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(24.h),
                              topRight: Radius.circular(24.h),
                            ),
                            child: SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 90.h,
                                    width: double.infinity,
                                    child: CustomPaint(
                                      painter: HeaderTrianglePainter(),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Payment info",
                                          style: TextStyleHelper
                                              .instance
                                              .headline24Bold,
                                        ),
                                        SizedBox(height: 16.h),

                                        // 1. Shipping Address Box
                                        _buildInfoCard(
                                          title: "Shipping Address",
                                          content: shippingAddressContent,
                                          cardBg: appTheme.backgroundcolor,
                                          primaryColor: appTheme.writecolor,
                                          showEditButton: true,
                                          onEdit: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const Updateuserinformation(),
                                              ),
                                            ).then((_) {
                                              context
                                                  .read<CheckoutinfoCubit>()
                                                  .getCheckoutData();
                                            });
                                          },
                                        ),
                                        SizedBox(height: 12.h),

                                        // 2. User Information Box
                                        _buildInfoCard(
                                          title: "User Information",
                                          content: userInfoContent,
                                          cardBg: appTheme.backgroundcolor,
                                          primaryColor: appTheme.writecolor,
                                          showEditButton: false,
                                          onEdit: () {},
                                        ),
                                        SizedBox(height: 20.h),

                                        // 3. Items Section
                                        Row(
                                          children: [
                                            Text(
                                              "Items",
                                              style: TextStyleHelper
                                                  .instance
                                                  .headline24Bold
                                                  .copyWith(fontSize: 18),
                                            ),
                                            SizedBox(width: 8.h),
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 10.h,
                                                vertical: 2.h,
                                              ),
                                              decoration: BoxDecoration(
                                                color: appTheme.backgroundcolor,
                                                borderRadius:
                                                    BorderRadius.circular(12.h),
                                              ),
                                              child: Text(
                                                "${items.length}",
                                                style: TextStyleHelper
                                                    .instance
                                                    .headline24Bold
                                                    .copyWith(fontSize: 12),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 12.h),

                                        ...items.map(
                                          (item) => Padding(
                                            padding: EdgeInsets.only(
                                              bottom: 10.h,
                                            ),
                                            child: _buildItemRow(
                                              imageUrl: item["image"] ?? '',
                                              quantity: item["quantity"] ?? 1,
                                              title:
                                                  "${item["name"] ?? ''} (${item["size"] ?? ''} - ${item["color"] ?? ''})",
                                              price:
                                                  "${item["currency"] ?? ''} ${item["price"] ?? ''}",
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 24.h),

                                        // 4. Fulfillment Method Selection
                                        Text(
                                          "Fulfillment Method Selection",
                                          style: TextStyleHelper
                                              .instance
                                              .headline24Bold
                                              .copyWith(fontSize: 18),
                                        ),
                                        SizedBox(height: 12.h),

                                        ...fulfillmentMethods.map((method) {
                                          final int id = method["id"];
                                          final String name = method["name"];
                                          final double price =
                                              (method["price"] as num?)
                                                  ?.toDouble() ??
                                              0.0;
                                          final String trailingText = price == 0
                                              ? "FREE"
                                              : "\$${price.toStringAsFixed(2)}";

                                          return Padding(
                                            padding: EdgeInsets.only(
                                              bottom: 10.h,
                                            ),
                                            child: _buildFulfillmentOption(
                                              id: id,
                                              title: name,
                                              trailingText: trailingText,
                                              isSelected:
                                                  selectedFulfillment == id,
                                              cardBg: appTheme.backgroundcolor,
                                              primaryColor: appTheme.writecolor,
                                              onTap: () {
                                                setState(() {
                                                  selectedFulfillment = id;
                                                });
                                                context
                                                    .read<CheckoutinfoCubit>()
                                                    .updateFulfillmentMethod(
                                                      accessToken:
                                                          "ACCESS_TOKEN_HERE",
                                                      fulfillmentMethodId: id,
                                                    );
                                              },
                                            ),
                                          );
                                        }),

                                        SizedBox(height: 30.h),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }

  Widget _buildInfoCard({
    required String title,
    required String content,
    required Color cardBg,
    required Color primaryColor,
    required bool showEditButton,
    required VoidCallback onEdit,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyleHelper.instance.headline24Bold.copyWith(
                    fontSize: 13,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  content,
                  style: TextStyleHelper.instance.headline24Bold.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          if (showEditButton) ...[
            SizedBox(width: 8.h),
            InkWell(
              onTap: onEdit,
              child: CircleAvatar(
                radius: 16,
                backgroundColor: primaryColor,
                child: Icon(Icons.edit, color: appTheme.secondcolor, size: 16),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildItemRow({
    required String imageUrl,
    required int quantity,
    required String title,
    required String price,
  }) {
    return Row(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            CircleAvatar(radius: 24, backgroundImage: NetworkImage(imageUrl)),
            Positioned(
              right: -4,
              bottom: -4,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Color(0xFFE5DCE1),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  "$quantity",
                  style: TextStyleHelper.instance.headline24Bold.copyWith(
                    fontSize: 10,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(width: 14.h),
        Expanded(
          child: Text(
            title,
            style: TextStyleHelper.instance.headline24Bold.copyWith(
              fontSize: 13,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        SizedBox(width: 10.h),
        Text(
          price,
          style: TextStyleHelper.instance.headline24Bold.copyWith(fontSize: 15),
        ),
      ],
    );
  }

  Widget _buildFulfillmentOption({
    required int id,
    required String title,
    required String trailingText,
    required bool isSelected,
    required Color cardBg,
    required Color primaryColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.h, vertical: 12.h),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(12.h),
        ),
        child: Row(
          children: [
            Container(
              width: 22.h,
              height: 22.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? primaryColor : Colors.grey.shade600,
                  width: 2.h,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 12.h,
                        height: 12.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: appTheme.writecolor,
                        ),
                      ),
                    )
                  : null,
            ),
            SizedBox(width: 12.h),
            Expanded(
              child: Text(
                title,
                style: TextStyleHelper.instance.headline24Bold.copyWith(
                  fontSize: 14,
                ),
              ),
            ),
            if (trailingText.isNotEmpty)
              Text(
                trailingText,
                style: TextStyleHelper.instance.headline24Bold.copyWith(
                  fontSize: 14,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class HeaderTrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint1 = Paint()
      ..color = const Color(0xFFC78299).withOpacity(0.5)
      ..style = PaintingStyle.fill;

    final paint2 = Paint()
      ..color = const Color(0xFF4A2A4E).withOpacity(0.3)
      ..style = PaintingStyle.fill;

    Path path1 = Path();
    path1.moveTo(size.width * 0.1, 0);
    path1.lineTo(size.width * 0.9, 0);
    path1.lineTo(size.width * 0.5, size.height * 0.7);
    path1.close();

    Path path2 = Path();
    path2.moveTo(size.width * 0.2, 0);
    path2.lineTo(size.width, 0);
    path2.lineTo(size.width * 0.5, size.height * 0.9);
    path2.close();

    canvas.drawPath(path2, paint2);
    canvas.drawPath(path1, paint1);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
