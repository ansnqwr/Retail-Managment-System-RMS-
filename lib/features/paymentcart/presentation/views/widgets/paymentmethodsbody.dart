import 'package:delni_rms/constants.dart';
import 'package:delni_rms/core1/utils/size_utils.dart';
import 'package:delni_rms/core1/utils/styles.dart';
import 'package:flutter/material.dart';

class Paymentmethodsbody extends StatefulWidget {
  const Paymentmethodsbody({super.key});

  @override
  State<Paymentmethodsbody> createState() => _PaymentmethodsbodyState();
}

class _PaymentmethodsbodyState extends State<Paymentmethodsbody> {
  // ======================================================
  // DEMO DATA
  // ======================================================

  String selectedPayment = 'Cash on Delivery';
  int? selectedCardId = 7;

  final List<Map<String, dynamic>> paymentMethods = [
    {
      'id': 1,
      'name': 'Cash on Delivery',
      'type': 'cash',
      'icon': Icons.money,
      'description': 'Pay with cash when your order arrives',
    },
    {
      'id': 2,
      'name': 'Paypal',
      'type': 'wallet',
      'icon': Icons.account_balance_wallet,
      'description': 'Pay securely using your PayPal wallet',
    },
    {
      'id': 3,
      'name': 'Google Pay',
      'type': 'wallet',
      'icon': Icons.g_mobiledata,
      'description': 'Fast and secure payment with Google Pay',
    },
    {
      'id': 4,
      'name': 'Bank Transfer',
      'type': 'bank',
      'icon': Icons.account_balance,
      'description': 'Transfer money directly from your bank',
    },
  ];

  List<Map<String, dynamic>> savedCards = [
    {
      'id': 7,
      'card_holder': 'Anna Doe',
      'last_four_digits': '1111',
      'expiry_date': '12/28',
      'is_default': true,
    },
    {
      'id': 8,
      'card_holder': 'Anna Doe',
      'last_four_digits': '4242',
      'expiry_date': '08/29',
      'is_default': false,
    },
  ];

  // ======================================================
  // ADD CARD
  // ======================================================

  void _showAddCardDialog(BuildContext context) {
    final cardNumberController = TextEditingController();
    final expDateController = TextEditingController();
    final cvvController = TextEditingController();
    final holderController = TextEditingController();

    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.h),
          ),
          contentPadding: EdgeInsets.zero,
          content: SizedBox(
            width: 420.h,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(20.h),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        children: [
                          Container(
                            width: 42.h,
                            height: 42.h,
                            decoration: BoxDecoration(
                              color: appTheme.primarycolor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10.h),
                            ),
                            child: Icon(
                              Icons.credit_card,
                              color: appTheme.primarycolor,
                            ),
                          ),
                          SizedBox(width: 12.h),
                          Expanded(
                            child: Text(
                              'Add New Card',
                              style: TextStyleHelper.instance.headline24Bold
                                  .copyWith(fontSize: 18.h),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.pop(dialogContext);
                            },
                            icon: Icon(Icons.close, color: appTheme.writecolor),
                          ),
                        ],
                      ),

                      SizedBox(height: 20.h),

                      _buildTextField(
                        label: 'Card Number',
                        hint: '1234 5678 9012 3456',
                        controller: cardNumberController,
                        keyboardType: TextInputType.number,
                      ),

                      SizedBox(height: 14.h),

                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              label: 'Expiration Date',
                              hint: 'MM/YY',
                              controller: expDateController,
                              keyboardType: TextInputType.datetime,
                            ),
                          ),
                          SizedBox(width: 12.h),
                          Expanded(
                            child: _buildTextField(
                              label: 'Security Code',
                              hint: 'CVV',
                              controller: cvvController,
                              keyboardType: TextInputType.number,
                              obscureText: true,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 14.h),

                      _buildTextField(
                        label: 'Card Holder',
                        hint: 'Enter card holder name',
                        controller: holderController,
                      ),

                      SizedBox(height: 22.h),

                      SizedBox(
                        width: double.infinity,
                        height: 50.h,
                        child: ElevatedButton(
                          onPressed: () {
                            if (!formKey.currentState!.validate()) {
                              return;
                            }

                            setState(() {
                              final newId =
                                  DateTime.now().millisecondsSinceEpoch;

                              savedCards.add({
                                'id': newId,
                                'card_holder':
                                    holderController.text.trim().isEmpty
                                    ? 'Anna Doe'
                                    : holderController.text.trim(),
                                'last_four_digits':
                                    cardNumberController.text
                                            .replaceAll(' ', ' ')
                                            .length >=
                                        4
                                    ? cardNumberController.text
                                          .replaceAll(' ', ' ')
                                          .substring(
                                            cardNumberController.text
                                                    .replaceAll(' ', ' ')
                                                    .length -
                                                4,
                                          )
                                    : '5555',
                                'expiry_date':
                                    expDateController.text.trim().isEmpty
                                    ? '12/29'
                                    : expDateController.text.trim(),
                                'is_default': false,
                              });
                            });

                            Navigator.pop(dialogContext);

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Card added successfully'),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: appTheme.primarycolor,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.h),
                            ),
                          ),
                          child: Text(
                            'Add Card',
                            style: TextStyleHelper.instance.headline24Bold
                                .copyWith(
                                  color: appTheme.whitecolor,
                                  fontSize: 15.h,
                                ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // ======================================================
  // TEXT FIELD
  // ======================================================

  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    TextInputType? keyboardType,
    bool obscureText = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyleHelper.instance.headline24Bold.copyWith(
            fontSize: 12.h,
          ),
        ),
        SizedBox(height: 7.h),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Required';
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyleHelper.instance.headline24Bold.copyWith(
              fontSize: 12.h,
              color: appTheme.greycolor,
            ),
            filled: true,
            fillColor: appTheme.whitecolor,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 13.h,
              vertical: 13.h,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(9.h),
              borderSide: BorderSide(color: appTheme.greycolor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(9.h),
              borderSide: BorderSide(color: appTheme.greycolor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(9.h),
              borderSide: BorderSide(color: appTheme.primarycolor, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  // ======================================================
  // DELETE CARD
  // ======================================================

  void _deleteCard(int cardId) {
    final card = savedCards.firstWhere((element) => element['id'] == cardId);

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.h),
          ),
          title: Text(
            'Delete Card',
            style: TextStyleHelper.instance.headline24Bold.copyWith(
              fontSize: 18.h,
            ),
          ),
          content: Text(
            'Are you sure you want to delete the card ending in ${card['last_four_digits']}?',
            style: TextStyle(fontSize: 13.h, color: appTheme.writecolor),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: appTheme.greycolor),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  savedCards.removeWhere((element) => element['id'] == cardId);

                  if (selectedCardId == cardId) {
                    selectedCardId = savedCards.isNotEmpty
                        ? savedCards.first['id']
                        : null;
                  }
                });

                Navigator.pop(dialogContext);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Card deleted successfully')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                elevation: 0,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  // ======================================================
  // CARD
  // ======================================================

  Widget _buildSavedCard(Map<String, dynamic> card) {
    final bool isSelected = selectedCardId == card['id'];

    final bool isDefault = card['is_default'] == true;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCardId = card['id'];
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(14.h),
        decoration: BoxDecoration(
          color: isSelected ? appTheme.backgroundcolor : appTheme.whitecolor,
          borderRadius: BorderRadius.circular(12.h),
          border: Border.all(
            color: isSelected ? appTheme.primarycolor : appTheme.greycolor,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            // Card Icon
            Container(
              width: 48.h,
              height: 48.h,
              decoration: BoxDecoration(
                color: appTheme.primarycolor.withOpacity(0.08),
                borderRadius: BorderRadius.circular(10.h),
              ),
              child: Icon(
                Icons.credit_card,
                color: appTheme.primarycolor,
                size: 25.h,
              ),
            ),

            SizedBox(width: 12.h),

            // Card Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          card['card_holder'],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyleHelper.instance.headline24Bold
                              .copyWith(fontSize: 13.h),
                        ),
                      ),
                      if (isDefault)
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 7.h,
                            vertical: 3.h,
                          ),
                          decoration: BoxDecoration(
                            color: appTheme.primarycolor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(5.h),
                          ),
                          child: Text(
                            'Default',
                            style: TextStyle(
                              fontSize: 8.h,
                              fontWeight: FontWeight.bold,
                              color: appTheme.primarycolor,
                            ),
                          ),
                        ),
                    ],
                  ),

                  SizedBox(height: 5.h),

                  Text(
                    '••••  ••••  ••••  ${card['last_four_digits']}',
                    style: TextStyleHelper.instance.headline24Bold.copyWith(
                      fontSize: 12.h,
                      letterSpacing: 0.5,
                    ),
                  ),

                  SizedBox(height: 4.h),

                  Text(
                    'Expires ${card['expiry_date']}',
                    style: TextStyle(fontSize: 9.h, color: appTheme.greycolor),
                  ),
                ],
              ),
            ),

            SizedBox(width: 5.h),

            // Radio
            Radio<int>(
              value: card['id'],
              groupValue: selectedCardId,
              activeColor: appTheme.primarycolor,
              onChanged: (value) {
                setState(() {
                  selectedCardId = value;
                });
              },
            ),

            // Delete
            IconButton(
              onPressed: () {
                _deleteCard(card['id']);
              },
              splashRadius: 22.h,
              icon: Icon(Icons.delete_outline, color: Colors.red, size: 21.h),
            ),
          ],
        ),
      ),
    );
  }

  // ======================================================
  // PAYMENT METHOD
  // ======================================================

  Widget _buildPaymentMethod(Map<String, dynamic> method) {
    final bool isSelected = selectedPayment == method['name'];

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPayment = method['name'];
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: EdgeInsets.only(bottom: 10.h),
        padding: EdgeInsets.all(13.h),
        decoration: BoxDecoration(
          color: isSelected ? appTheme.backgroundcolor : appTheme.whitecolor,
          borderRadius: BorderRadius.circular(11.h),
          border: Border.all(
            color: isSelected ? appTheme.primarycolor : appTheme.greycolor,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 44.h,
              height: 44.h,
              decoration: BoxDecoration(
                color: isSelected
                    ? appTheme.primarycolor.withOpacity(0.1)
                    : appTheme.backgroundcolor,
                borderRadius: BorderRadius.circular(9.h),
              ),
              child: Icon(
                method['icon'],
                color: appTheme.primarycolor,
                size: 23.h,
              ),
            ),

            SizedBox(width: 12.h),

            // Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    method['name'],
                    style: TextStyleHelper.instance.headline24Bold.copyWith(
                      fontSize: 13.h,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    method['description'],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 9.h, color: appTheme.greycolor),
                  ),
                ],
              ),
            ),

            // Radio
            Radio<String>(
              value: method['name'],
              groupValue: selectedPayment,
              activeColor: appTheme.primarycolor,
              onChanged: (value) {
                if (value == null) return;

                setState(() {
                  selectedPayment = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  // ======================================================
  // EMPTY CARDS
  // ======================================================

  Widget _buildEmptyCards() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 25.h, horizontal: 20.h),
      decoration: BoxDecoration(
        color: appTheme.backgroundcolor,
        borderRadius: BorderRadius.circular(12.h),
        border: Border.all(color: appTheme.greycolor),
      ),
      child: Column(
        children: [
          Container(
            width: 55.h,
            height: 55.h,
            decoration: BoxDecoration(
              color: appTheme.whitecolor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.credit_card_off,
              color: appTheme.greycolor,
              size: 27.h,
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            'No saved cards',
            style: TextStyleHelper.instance.headline24Bold.copyWith(
              fontSize: 13.h,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'Add a card to make your checkout faster',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 10.h, color: appTheme.greycolor),
          ),
        ],
      ),
    );
  }

  // ======================================================
  // BUILD
  // ======================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.whitecolor,

      // ==================================================
      // APP BAR
      // ==================================================
      appBar: AppBar(
        backgroundColor: appTheme.whitecolor,
        elevation: 0,
        centerTitle: false,

        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: appTheme.writecolor),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        title: Text(
          'Payment Card',
          style: TextStyleHelper.instance.headline24Bold.copyWith(
            fontSize: 18.h,
          ),
        ),
      ),

      // ==================================================
      // BODY
      // ==================================================
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ==========================================
              // STEPS
              // ==========================================
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  _StepItem(
                    title: 'Cart',
                    number: '1',
                    isActive: true,
                    isCompleted: true,
                  ),
                  _StepLine(isActive: true),
                  _StepItem(
                    title: 'Address',
                    number: '2',
                    isActive: true,
                    isCompleted: true,
                  ),
                  _StepLine(isActive: true),
                  _StepItem(
                    title: 'Payment',
                    number: '3',
                    isActive: true,
                    isCompleted: false,
                  ),
                  _StepLine(isActive: false),
                  _StepItem(
                    title: 'Summary',
                    number: '4',
                    isActive: false,
                    isCompleted: false,
                  ),
                ],
              ),

              SizedBox(height: 25.h),

              // ==========================================
              // PAYMENT HEADER
              // ==========================================
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      'Select Payment Method',
                      style: TextStyleHelper.instance.headline24Bold.copyWith(
                        fontSize: 17.h,
                      ),
                    ),
                  ),

                  TextButton.icon(
                    onPressed: () {
                      _showAddCardDialog(context);
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 5.h),
                    ),
                    icon: Icon(
                      Icons.add,
                      size: 18.h,
                      color: appTheme.primarycolor,
                    ),
                    label: Text(
                      'Add Card',
                      style: TextStyleHelper.instance.headline24Bold.copyWith(
                        fontSize: 13.h,
                        color: appTheme.primarycolor,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 12.h),

              // ==========================================
              // SCROLL CONTENT
              // ==========================================
              Expanded(
                child: ListView(
                  padding: EdgeInsets.only(bottom: 10.h),
                  children: [
                    // --------------------------------------
                    // PAYMENT METHODS
                    // --------------------------------------
                    Text(
                      'Payment Methods',
                      style: TextStyleHelper.instance.headline24Bold.copyWith(
                        fontSize: 13.h,
                        color: appTheme.writecolor,
                      ),
                    ),

                    SizedBox(height: 9.h),

                    ...paymentMethods.map(
                      (method) => _buildPaymentMethod(method),
                    ),

                    SizedBox(height: 15.h),

                    // --------------------------------------
                    // SAVED CARDS HEADER
                    // --------------------------------------
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Saved Cards',
                          style: TextStyleHelper.instance.headline24Bold
                              .copyWith(
                                fontSize: 13.h,
                                color: appTheme.writecolor,
                              ),
                        ),
                        if (savedCards.isNotEmpty)
                          Text(
                            '${savedCards.length} Cards',
                            style: TextStyle(
                              fontSize: 10.h,
                              color: appTheme.greycolor,
                            ),
                          ),
                      ],
                    ),

                    SizedBox(height: 9.h),

                    // --------------------------------------
                    // SAVED CARDS
                    // --------------------------------------
                    if (savedCards.isEmpty)
                      _buildEmptyCards()
                    else
                      ...savedCards.map((card) => _buildSavedCard(card)),
                  ],
                ),
              ),

              // ==========================================
              // BOTTOM
              // ==========================================
              Padding(
                padding: EdgeInsets.only(top: 5.h, bottom: 8.h),
                child: Row(
                  children: [
                    // Selected payment info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Selected',
                            style: TextStyle(
                              fontSize: 9.h,
                              color: appTheme.greycolor,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            selectedPayment,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyleHelper.instance.headline24Bold
                                .copyWith(fontSize: 12.h),
                          ),
                        ],
                      ),
                    ),

                    // Continue
                    InkWell(
                      borderRadius: BorderRadius.circular(30.h),
                      onTap: () {
                        // الانتقال للـ Summary
                      },
                      child: Container(
                        width: 56.h,
                        height: 56.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: appTheme.primarycolor,
                        ),
                        child: Icon(
                          Icons.arrow_forward,
                          color: appTheme.whitecolor,
                          size: 25.h,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ======================================================
// STEP ITEM
// ======================================================

class _StepItem extends StatelessWidget {
  final String title;
  final String number;
  final bool isActive;
  final bool isCompleted;

  const _StepItem({
    required this.title,
    required this.number,
    required this.isActive,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 25.h,
          height: 25.h,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? appTheme.primarycolor : appTheme.greycolor,
          ),
          child: Center(
            child: isCompleted
                ? Icon(Icons.check, size: 14.h, color: appTheme.whitecolor)
                : Text(
                    number,
                    style: TextStyle(
                      color: appTheme.whitecolor,
                      fontSize: 10.h,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
        SizedBox(height: 5.h),
        Text(
          title,
          style: TextStyle(
            fontSize: 9.h,
            color: appTheme.writecolor,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}

// ======================================================
// STEP LINE
// ======================================================

class _StepLine extends StatelessWidget {
  final bool isActive;

  const _StepLine({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 2.h,
        margin: EdgeInsets.symmetric(horizontal: 4.h, vertical: 12.h),
        decoration: BoxDecoration(
          color: isActive ? appTheme.primarycolor : appTheme.greycolor,
          borderRadius: BorderRadius.circular(2.h),
        ),
      ),
    );
  }
}
