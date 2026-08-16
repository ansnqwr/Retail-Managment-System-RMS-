import 'package:delni_rms/constants.dart';
import 'package:delni_rms/core1/utils/size_utils.dart';
import 'package:delni_rms/core1/utils/styles.dart';

import 'package:delni_rms/features/paymentcart/presentation/manager/shippingandaddress/cubit/shippingandaddress_cubit.dart';
import 'package:delni_rms/features/paymentcart/presentation/views/paymentmethods.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Addressandshippingviewbody extends StatefulWidget {
  const Addressandshippingviewbody({super.key});

  @override
  State<Addressandshippingviewbody> createState() =>
      _AddressandshippingviewbodyState();
}

class _AddressandshippingviewbodyState
    extends State<Addressandshippingviewbody> {
  // ============================================================
  // Backend data
  // ============================================================

  List<Map<String, dynamic>> addresses = [];

  List<Map<String, dynamic>> shippingProviders = [];

  int? selectedAddressId;
  int? selectedProviderId;

  // ============================================================
  // Dropdown states for Government & City selectors
  // ============================================================

  String? selectedGovernment;
  String? selectedCity;

  bool isGovernmentExpanded = false;
  bool isCityExpanded = false;

  final List<String> governmentsList = [
    'Cairo',
    'Giza',
    'Alexandria',
    'Karnataka',
    'Delhi',
  ];

  final List<String> citiesList = [
    'Bengaluru',
    'Delhi',
    'City Center',
    'North District',
    'South Zone',
  ];

  // ============================================================
  // Init
  // ============================================================

  @override
  void initState() {
    super.initState();

    selectedGovernment = governmentsList.first;
    selectedCity = citiesList.first;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadBackendData();
    });
  }

  void _loadBackendData() {
    final cubit = context.read<ShippingandaddressCubit>();

    cubit.getAddresses();
    cubit.getShippingProviders();
  }

  // ============================================================
  // Build
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return BlocListener<ShippingandaddressCubit, ShippingandaddressState>(
      listener: (context, state) {
        _handleCubitState(state);
      },
      child: Scaffold(
        backgroundColor: appTheme.whitecolor,
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  color: appTheme.whitecolor,
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTitle(),
                        _buildStepper(),
                        SizedBox(height: 5.h),
                        _buildAddresses(),
                        SizedBox(height: 20.h),
                        _buildAddAddress(),
                        SizedBox(height: 28.h),
                        _buildShippingProviders(),
                        SizedBox(height: 30.h),

                        // ==================================================
                        // Next Page Button
                        // ==================================================
                        _buildNextButton(),

                        SizedBox(height: 30.h),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // Cubit State Handler
  // ============================================================

  void _handleCubitState(ShippingandaddressState state) {
    // ------------------------------------------------------------
    // Addresses
    // ------------------------------------------------------------

    if (state is GetAddressesSuccess) {
      _handleAddressesResponse(state.addressesData);
    }

    // ------------------------------------------------------------
    // Shipping Providers
    // ------------------------------------------------------------

    if (state is GetShippingProvidersSuccess) {
      _handleShippingProvidersResponse(state.providersData);
    }

    // ------------------------------------------------------------
    // Add Address
    // ------------------------------------------------------------

    if (state is AddAddressSuccess) {
      _showMessage(state.message, isError: false);
    }

    if (state is AddAddressFailure) {
      _showMessage(state.errorMessage, isError: true);
    }

    // ------------------------------------------------------------
    // Update Address
    // ------------------------------------------------------------

    if (state is UpdateAddressSuccess) {
      _showMessage(state.message, isError: false);
    }

    if (state is UpdateAddressFailure) {
      _showMessage(state.errorMessage, isError: true);
    }

    // ------------------------------------------------------------
    // Delete Address
    // ------------------------------------------------------------

    if (state is DeleteAddressSuccess) {
      _showMessage(state.message, isError: false);
    }

    if (state is DeleteAddressFailure) {
      _showMessage(state.errorMessage, isError: true);
    }

    // ------------------------------------------------------------
    // Select Address
    // ------------------------------------------------------------

    if (state is SelectAddressSuccess) {
      _showMessage(state.message, isError: false);
    }

    if (state is SelectAddressFailure) {
      _showMessage(state.errorMessage, isError: true);
    }

    // ------------------------------------------------------------
    // Select Shipping Provider
    // ------------------------------------------------------------

    if (state is SelectShippingProviderSuccess) {
      _showMessage(state.message, isError: false);
    }

    if (state is SelectShippingProviderFailure) {
      _showMessage(state.errorMessage, isError: true);
    }
  }

  // ============================================================
  // Parse Addresses Response
  // ============================================================

  void _handleAddressesResponse(Map<String, dynamic> response) {
    try {
      final dynamic rawAddresses = response['addresses'];

      final List<Map<String, dynamic>> parsedAddresses = [];

      if (rawAddresses is List) {
        for (final item in rawAddresses) {
          if (item is Map) {
            final map = Map<String, dynamic>.from(item);

            parsedAddresses.add(_normalizeAddress(map));
          }
        }
      }

      final dynamic defaultAddressIdRaw = response['default_address_id'];

      int? backendDefaultAddressId;

      if (defaultAddressIdRaw is int) {
        backendDefaultAddressId = defaultAddressIdRaw;
      } else if (defaultAddressIdRaw is String) {
        backendDefaultAddressId = int.tryParse(defaultAddressIdRaw);
      }

      int? newSelectedAddressId;

      // First priority: backend default_address_id
      if (backendDefaultAddressId != null &&
          parsedAddresses.any(
            (address) => address['id'] == backendDefaultAddressId,
          )) {
        newSelectedAddressId = backendDefaultAddressId;
      } else {
        // Second priority: is_default
        final defaultAddress = parsedAddresses
            .cast<Map<String, dynamic>?>()
            .firstWhere(
              (address) => address?['isDefault'] == true,
              orElse: () => null,
            );

        if (defaultAddress != null) {
          newSelectedAddressId = defaultAddress['id'];
        } else if (parsedAddresses.isNotEmpty) {
          // Third priority: first address
          newSelectedAddressId = parsedAddresses.first['id'];
        }
      }

      if (!mounted) return;

      setState(() {
        addresses = parsedAddresses;
        selectedAddressId = newSelectedAddressId;
      });
    } catch (e) {
      _showMessage('Failed to process addresses data.', isError: true);
    }
  }

  // ============================================================
  // Normalize Address
  // ============================================================

  Map<String, dynamic> _normalizeAddress(Map<String, dynamic> json) {
    final String fullName = (json['name'] ?? json['full_name'] ?? '')
        .toString()
        .trim();

    String firstName = (json['first_name'] ?? json['firstName'] ?? '')
        .toString()
        .trim();

    String lastName = (json['last_name'] ?? json['lastName'] ?? '')
        .toString()
        .trim();

    // If backend returns only "name", split it for the edit dialog.
    if (firstName.isEmpty && fullName.isNotEmpty) {
      final nameParts = fullName.split(' ');

      if (nameParts.isNotEmpty) {
        firstName = nameParts.first;
      }

      if (nameParts.length > 1) {
        lastName = nameParts.sublist(1).join(' ');
      }
    }

    final String streetAddress =
        (json['street_address'] ??
                json['streetAddress'] ??
                json['address'] ??
                '')
            .toString();

    final String streetAddress2 =
        (json['street_address2'] ?? json['streetAddress2'] ?? '').toString();

    final String city = (json['city'] ?? '').toString();

    final String state = (json['state'] ?? '').toString();

    final String country = (json['country'] ?? '').toString();

    final String phone = (json['phone'] ?? '').toString();

    int? id;

    final dynamic idRaw = json['id'];

    if (idRaw is int) {
      id = idRaw;
    } else if (idRaw is String) {
      id = int.tryParse(idRaw);
    }

    bool isDefault = false;

    final dynamic defaultRaw = json['is_default'] ?? json['isDefault'];

    if (defaultRaw is bool) {
      isDefault = defaultRaw;
    } else if (defaultRaw is String) {
      isDefault = defaultRaw.toLowerCase() == 'true';
    } else if (defaultRaw is int) {
      isDefault = defaultRaw == 1;
    }

    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'streetAddress': streetAddress,
      'streetAddress2': streetAddress2,
      'city': city,
      'state': state,
      'country': country,
      'isDefault': isDefault,
      'name': fullName,
      'raw': json,
    };
  }

  // ============================================================
  // Parse Shipping Providers
  // ============================================================

  void _handleShippingProvidersResponse(Map<String, dynamic> response) {
    try {
      final dynamic rawProviders = response['providers'];

      final List<Map<String, dynamic>> parsedProviders = [];

      if (rawProviders is List) {
        for (final item in rawProviders) {
          if (item is Map) {
            final map = Map<String, dynamic>.from(item);

            int? id;

            final dynamic idRaw = map['id'];

            if (idRaw is int) {
              id = idRaw;
            } else if (idRaw is String) {
              id = int.tryParse(idRaw);
            }

            double price = 0;

            final dynamic priceRaw = map['price'];

            if (priceRaw is num) {
              price = priceRaw.toDouble();
            } else if (priceRaw is String) {
              price = double.tryParse(priceRaw) ?? 0;
            }

            parsedProviders.add({
              'id': id,
              'name': map['name']?.toString() ?? '',
              'price': price,
              'estimatedDays':
                  (map['estimated_days'] ?? map['estimatedDays'] ?? '')
                      .toString(),
            });
          }
        }
      }

      if (!mounted) return;

      setState(() {
        shippingProviders = parsedProviders;

        if (parsedProviders.isEmpty) {
          selectedProviderId = null;
        } else if (selectedProviderId == null ||
            !parsedProviders.any(
              (provider) => provider['id'] == selectedProviderId,
            )) {
          selectedProviderId = parsedProviders.first['id'];
        }
      });
    } catch (e) {
      _showMessage('Failed to process shipping providers data.', isError: true);
    }
  }

  // ============================================================
  // Snackbar
  // ============================================================

  void _showMessage(String message, {required bool isError}) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError ? Colors.redAccent : appTheme.primarycolor,
        ),
      );
  }

  // ============================================================
  // Title
  // ============================================================

  Widget _buildTitle() {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.h, 22.h, 20.h, 10.h),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(
              Icons.arrow_back_ios_new,
              size: 19,
              color: appTheme.primarycolor,
            ),
          ),
          SizedBox(width: 12.h),
          Text(
            'Delivery Address',
            style: TextStyleHelper.instance.headline24Bold.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // Stepper
  // ============================================================

  Widget _buildStepper() {
    return Padding(
      padding: EdgeInsets.fromLTRB(22.h, 12.h, 22.h, 18.h),
      child: Column(
        children: [
          Row(
            children: [
              _stepCircle(active: true, icon: Icons.check),
              _stepLine(),
              _stepCircle(active: false, number: '2'),
              _stepLine(),
              _stepCircle(active: false, number: '3'),
              _stepLine(),
              _stepCircle(active: false, number: '4'),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('Cart', style: TextStyle(fontSize: 10)),
              Text('Address', style: TextStyle(fontSize: 10)),
              Text('Payment', style: TextStyle(fontSize: 10)),
              Text('Summary', style: TextStyle(fontSize: 10)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _stepCircle({required bool active, String? number, IconData? icon}) {
    return Container(
      width: 24.h,
      height: 24.h,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: active ? appTheme.primarycolor : appTheme.whitecolor,
        border: Border.all(
          color: active ? appTheme.primarycolor : appTheme.backgroundcolor,
          width: 1.5,
        ),
      ),
      child: Center(
        child: icon != null
            ? Icon(icon, color: appTheme.whitecolor, size: 14)
            : Text(
                number ?? '',
                style: TextStyleHelper.instance.headline24Bold.copyWith(
                  fontSize: 10,
                  fontWeight: FontWeight.w300,
                ),
              ),
      ),
    );
  }

  Widget _stepLine() {
    return Expanded(
      child: Container(height: 2.h, color: appTheme.primarycolor),
    );
  }

  // ============================================================
  // Addresses
  // ============================================================

  Widget _buildAddresses() {
    if (addresses.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 18.h, vertical: 15.h),
        child: Text(
          'No addresses found.',
          style: TextStyleHelper.instance.headline24Bold.copyWith(
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
      );
    }

    return Column(
      children: addresses.map((address) {
        final selected = selectedAddressId == address['id'];

        return _buildAddressCard(address: address, selected: selected);
      }).toList(),
    );
  }

  // ============================================================
  // Address Card
  // ============================================================

  Widget _buildAddressCard({
    required Map<String, dynamic> address,
    required bool selected,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 18.h, vertical: 5.h),
      padding: EdgeInsets.all(12.h),
      decoration: BoxDecoration(
        color: selected ? const Color(0xFFE8D9E6) : const Color(0xFFF4EFF4),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  final int? addressId = _parseId(address['id']);

                  if (addressId == null) return;

                  setState(() {
                    selectedAddressId = addressId;
                  });

                  context.read<ShippingandaddressCubit>().selectAddress(
                    addressId: addressId,
                  );
                },
                child: Container(
                  width: 20.h,
                  height: 20.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: appTheme.primarycolor,
                      width: 2.h,
                    ),
                  ),
                  child: selected
                      ? Center(
                          child: Container(
                            width: 10.h,
                            height: 10.h,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: appTheme.primarycolor,
                            ),
                          ),
                        )
                      : null,
                ),
              ),
              SizedBox(width: 8.h),
              Expanded(
                child: Text(
                  '${address['firstName']} ${address['lastName']}'.trim(),
                  style: TextStyleHelper.instance.headline24Bold.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),

              // Edit Button
              GestureDetector(
                onTap: () => _showAddressDialog(existingAddress: address),
                child: Text(
                  'Edit',
                  style: TextStyleHelper.instance.headline24Bold.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              SizedBox(width: 12.h),

              // Delete Button
              GestureDetector(
                onTap: () => _deleteAddress(address),
                child: const Icon(
                  Icons.close,
                  size: 16,
                  color: Colors.redAccent,
                ),
              ),
            ],
          ),

          SizedBox(height: 7.h),

          Padding(
            padding: EdgeInsets.only(left: 28.h),
            child: Text(
              address['streetAddress']?.toString() ?? '',
              style: TextStyleHelper.instance.headline24Bold.copyWith(
                fontSize: 12,
                height: 1.3,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),

          if ((address['streetAddress2'] ?? '').toString().isNotEmpty) ...[
            SizedBox(height: 2.h),
            Padding(
              padding: EdgeInsets.only(left: 28.h),
              child: Text(
                address['streetAddress2']?.toString() ?? '',
                style: TextStyleHelper.instance.headline24Bold.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],

          SizedBox(height: 2.h),

          Padding(
            padding: EdgeInsets.only(left: 28.h),
            child: Text(
              '${address['city'] ?? ''}, '
              '${address['state'] ?? ''}, '
              '${address['country'] ?? ''}',
              style: TextStyleHelper.instance.headline24Bold.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),

          SizedBox(height: 2.h),

          Padding(
            padding: EdgeInsets.only(left: 28.h),
            child: Text(
              address['phone']?.toString() ?? '',
              style: TextStyleHelper.instance.headline24Bold.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),

          if (selected) ...[
            SizedBox(height: 14.h),
            Center(
              child: SizedBox(
                width: 190.h,
                height: 40.h,
                child: ElevatedButton(
                  onPressed: () {
                    final int? addressId = _parseId(address['id']);

                    if (addressId == null) return;

                    setState(() {
                      selectedAddressId = addressId;
                    });

                    context.read<ShippingandaddressCubit>().selectAddress(
                      addressId: addressId,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: appTheme.primarycolor,
                    foregroundColor: appTheme.whitecolor,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9),
                    ),
                  ),
                  child: Text(
                    'Deliver to this address',
                    style: TextStyleHelper.instance.headline24Bold.copyWith(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: appTheme.secondcolor,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ============================================================
  // Delete Address
  // ============================================================

  void _deleteAddress(Map<String, dynamic> address) {
    final int? addressId = _parseId(address['id']);

    if (addressId == null) return;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Address'),
          content: const Text('Are you sure you want to delete this address?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
              ),
              onPressed: () {
                Navigator.pop(dialogContext);

                context.read<ShippingandaddressCubit>().deleteAddress(
                  addressId: addressId,
                );
              },
              child: Text(
                'Delete',
                style: TextStyle(color: appTheme.whitecolor),
              ),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // Add / Edit Address Dialog
  // ============================================================

  void _showAddressDialog({Map<String, dynamic>? existingAddress}) {
    final firstNameController = TextEditingController(
      text: existingAddress?['firstName']?.toString() ?? '',
    );

    final lastNameController = TextEditingController(
      text: existingAddress?['lastName']?.toString() ?? '',
    );

    final phoneController = TextEditingController(
      text: existingAddress?['phone']?.toString() ?? '',
    );

    final streetAddressController = TextEditingController(
      text: existingAddress?['streetAddress']?.toString() ?? '',
    );

    final streetAddress2Controller = TextEditingController(
      text: existingAddress?['streetAddress2']?.toString() ?? '',
    );

    final cityController = TextEditingController(
      text: existingAddress?['city']?.toString() ?? '',
    );

    final stateController = TextEditingController(
      text: existingAddress?['state']?.toString() ?? '',
    );

    final countryController = TextEditingController(
      text: existingAddress?['country']?.toString() ?? '',
    );

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(
            existingAddress == null ? 'Add New Address' : 'Edit Address',
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: firstNameController,
                  decoration: const InputDecoration(labelText: 'First Name'),
                ),
                TextField(
                  controller: lastNameController,
                  decoration: const InputDecoration(labelText: 'Last Name'),
                ),
                TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(labelText: 'Phone'),
                ),
                TextField(
                  controller: streetAddressController,
                  decoration: const InputDecoration(
                    labelText: 'Street Address',
                  ),
                ),
                TextField(
                  controller: streetAddress2Controller,
                  decoration: const InputDecoration(
                    labelText: 'Street Address 2 (Optional)',
                  ),
                ),
                TextField(
                  controller: cityController,
                  decoration: const InputDecoration(labelText: 'City'),
                ),
                TextField(
                  controller: stateController,
                  decoration: const InputDecoration(labelText: 'State'),
                ),
                TextField(
                  controller: countryController,
                  decoration: const InputDecoration(labelText: 'Country'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: appTheme.primarycolor,
              ),
              onPressed: () {
                // Validation
                if (firstNameController.text.trim().isEmpty ||
                    lastNameController.text.trim().isEmpty ||
                    phoneController.text.trim().isEmpty ||
                    streetAddressController.text.trim().isEmpty ||
                    cityController.text.trim().isEmpty ||
                    stateController.text.trim().isEmpty ||
                    countryController.text.trim().isEmpty) {
                  _showMessage(
                    'Please fill all required fields.',
                    isError: true,
                  );

                  return;
                }

                final cubit = context.read<ShippingandaddressCubit>();

                // ------------------------------------------------
                // Add
                // ------------------------------------------------

                if (existingAddress == null) {
                  cubit.addAddress(
                    country: countryController.text.trim(),
                    firstName: firstNameController.text.trim(),
                    lastName: lastNameController.text.trim(),
                    streetAddress: streetAddressController.text.trim(),
                    streetAddress2: streetAddress2Controller.text.trim(),
                    city: cityController.text.trim(),
                    state: stateController.text.trim(),
                    phone: phoneController.text.trim(),
                  );
                }
                // ------------------------------------------------
                // Update
                // ------------------------------------------------
                else {
                  final int? addressId = _parseId(existingAddress['id']);

                  if (addressId == null) {
                    _showMessage('Invalid address ID.', isError: true);

                    return;
                  }

                  cubit.updateAddress(
                    addressId: addressId,
                    country: countryController.text.trim(),
                    firstName: firstNameController.text.trim(),
                    lastName: lastNameController.text.trim(),
                    streetAddress: streetAddressController.text.trim(),
                    streetAddress2: streetAddress2Controller.text.trim(),
                    city: cityController.text.trim(),
                    state: stateController.text.trim(),
                    phone: phoneController.text.trim(),
                  );
                }

                Navigator.pop(dialogContext);
              },
              child: Text(
                'Save',
                style: TextStyle(color: appTheme.secondcolor),
              ),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // Add Address Button
  // ============================================================

  Widget _buildAddAddress() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.h),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => _showAddressDialog(),
              child: Row(
                children: [
                  Icon(Icons.add, size: 17, color: appTheme.primarycolor),
                  SizedBox(width: 3),
                  Text(
                    'Add new address',
                    style: TextStyleHelper.instance.headline24Bold.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // Shipping Providers
  // ============================================================

  Widget _buildShippingProviders() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select a Shipping Provider',
            style: TextStyleHelper.instance.headline24Bold.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),

          SizedBox(height: 15.h),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ==================================================
              // Government
              // ==================================================
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isGovernmentExpanded = !isGovernmentExpanded;
                          isCityExpanded = false;
                        });
                      },
                      child: Text(
                        'government ($selectedGovernment) ›',
                        style: TextStyleHelper.instance.headline24Bold.copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),

                    if (isGovernmentExpanded) ...[
                      SizedBox(height: 8.h),
                      Container(
                        padding: EdgeInsets.all(8.h),
                        decoration: BoxDecoration(
                          color: appTheme.backgroundcolor,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: appTheme.backgroundcolor),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: governmentsList.map((gov) {
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  selectedGovernment = gov;
                                  isGovernmentExpanded = false;
                                });
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: 6.h,
                                  horizontal: 8.h,
                                ),
                                child: Text(
                                  gov,
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              SizedBox(width: 10.h),

              // ==================================================
              // City
              // ==================================================
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isCityExpanded = !isCityExpanded;
                          isGovernmentExpanded = false;
                        });
                      },
                      child: Text(
                        'City ($selectedCity) ›',
                        textAlign: TextAlign.right,
                        style: TextStyleHelper.instance.headline24Bold.copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),

                    if (isCityExpanded) ...[
                      SizedBox(height: 8.h),
                      Container(
                        padding: EdgeInsets.all(8.h),
                        decoration: BoxDecoration(
                          color: appTheme.backgroundcolor,
                          borderRadius: BorderRadius.circular(8.h),
                          border: Border.all(color: appTheme.backgroundcolor),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: citiesList.map((city) {
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  selectedCity = city;
                                  isCityExpanded = false;
                                });
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: 6.h,
                                  horizontal: 8.h,
                                ),
                                child: Text(
                                  city,
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 15.h),

          // ======================================================
          // Backend Shipping Providers
          // ======================================================
          if (shippingProviders.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h),
              child: Text(
                'No shipping providers available.',
                style: TextStyleHelper.instance.headline24Bold.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            )
          else
            ...shippingProviders.map((provider) {
              return _buildShippingProvider(provider);
            }),
        ],
      ),
    );
  }

  // ============================================================
  // Shipping Provider Card
  // ============================================================

  Widget _buildShippingProvider(Map<String, dynamic> provider) {
    final selected = selectedProviderId == provider['id'];

    return GestureDetector(
      onTap: () {
        final int? providerId = _parseId(provider['id']);

        if (providerId == null) return;

        setState(() {
          selectedProviderId = providerId;
        });

        context.read<ShippingandaddressCubit>().selectShippingProvider(
          providerId: providerId,
        );
      },
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(bottom: 8.h),
        padding: EdgeInsets.symmetric(horizontal: 10.h, vertical: 9.h),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFDCCBD9) : const Color(0xFFF2EDF2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              width: 23,
              height: 23,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: appTheme.primarycolor, width: 2),
              ),
              child: selected
                  ? Center(
                      child: Container(
                        width: 11.h,
                        height: 11.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: appTheme.primarycolor,
                        ),
                      ),
                    )
                  : null,
            ),

            SizedBox(width: 10.h),

            Expanded(
              child: Text(
                provider['name']?.toString() ?? '',
                style: TextStyleHelper.instance.headline24Bold.copyWith(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            Text(
              '\$${_formatPrice(provider['price'])}',
              style: TextStyleHelper.instance.headline24Bold.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),

            SizedBox(width: 8.h),

            Text(
              provider['estimatedDays']?.toString() ?? '',
              style: TextStyleHelper.instance.headline24Bold.copyWith(
                fontSize: 10,
                color: const Color(0xFF777177),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================
  // Next Page Button
  // ============================================================

  Widget _buildNextButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.h),
      child: Align(
        alignment: Alignment.centerRight,
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Paymentmethods()),
            );
          },
          child: Container(
            width: 52.h,
            height: 52.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: appTheme.primarycolor,
            ),
            child: Icon(
              Icons.arrow_forward,
              color: appTheme.whitecolor,
              size: 24.h,
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // Helpers
  // ============================================================

  int? _parseId(dynamic value) {
    if (value is int) {
      return value;
    }

    if (value is String) {
      return int.tryParse(value);
    }

    return null;
  }

  String _formatPrice(dynamic value) {
    if (value == null) {
      return '0';
    }

    if (value is num) {
      return value.toStringAsFixed(0);
    }

    final parsed = double.tryParse(value.toString());

    if (parsed == null) {
      return '0';
    }

    return parsed.toStringAsFixed(0);
  }

  // ============================================================
  // Dispose
  // ============================================================

  @override
  void dispose() {
    super.dispose();
  }
}
