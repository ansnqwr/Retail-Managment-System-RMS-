import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/features/auth/data/models/Repository/signup_repository.dart';
import '../Model/user_model.dart';
import '../ViewModel/profile_bloc.dart';
import '/features/auth/view/SignupScreen.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final _formKey = GlobalKey<FormState>();
  final SignupRepository _signupRepository = SignupRepository();

  late TextEditingController _fNameCtrl;
  late TextEditingController _lNameCtrl;
  late TextEditingController _phoneCtrl;
  late UserModel _initialUser;

  List<LocationItem> governorates = [];
  List<LocationItem> cities = [];

  LocationItem? selectedGovernorate;
  LocationItem? selectedCity;

  bool isLoadingLocations = true;
  bool isLoadingCities = false;

  @override
  void initState() {
    super.initState();
    final state = context.read<ProfileBloc>().state;

    if (state is ProfileLoaded) {
      _initialUser = state.user;
      _fNameCtrl = TextEditingController(text: _initialUser.firstName);
      _lNameCtrl = TextEditingController(text: _initialUser.lastName);
      _phoneCtrl = TextEditingController(text: _initialUser.phone);
    } else {
      _initialUser = UserModel(
        id: '0',
        firstName: '',
        lastName: '',
        email: '',
        phone: '',
        governorate: '',
        city: '',
      );
      _fNameCtrl = TextEditingController();
      _lNameCtrl = TextEditingController();
      _phoneCtrl = TextEditingController();
    }

    _loadInitialLocations();
  }

  @override
  void dispose() {
    _fNameCtrl.dispose();
    _lNameCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadInitialLocations() async {
    try {
      final fetchedGovernorates = await _signupRepository.getGovernorates();
      setState(() {
        governorates = fetchedGovernorates;
        isLoadingLocations = false;
      });

      if (_initialUser.governorate.isNotEmpty) {
        try {
          final matchedGov = governorates.firstWhere(
            (g) => g.name == _initialUser.governorate,
          );
          setState(() {
            selectedGovernorate = matchedGov;
          });
          await _loadCities(
            matchedGov.id,
            preselectedCityName: _initialUser.city,
          );
        } catch (e) {
          setState(() {
            selectedGovernorate = null;
          });
        }
      }
    } catch (e) {
      setState(() {
        isLoadingLocations = false;
      });
      _showSnackBar(e.toString());
    }
  }

  Future<void> _loadCities(
    int governorateId, {
    String? preselectedCityName,
  }) async {
    setState(() {
      isLoadingCities = true;
    });
    try {
      final fetchedCities = await _signupRepository.getCities(governorateId);
      setState(() {
        cities = fetchedCities;
        isLoadingCities = false;
      });

      if (preselectedCityName != null && preselectedCityName.isNotEmpty) {
        try {
          setState(() {
            selectedCity = cities.firstWhere(
              (c) => c.name == preselectedCityName,
            );
          });
        } catch (e) {
          setState(() {
            selectedCity = null;
          });
        }
      }
    } catch (e) {
      setState(() {
        isLoadingCities = false;
      });
      _showSnackBar(e.toString());
    }
  }

  void _showSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Edit Profile',
          style: TextStyle(color: Color(0xFFF2A488)),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color(0xFFF2A488)),
      ),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileActionSuccess) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
            if (state.requiresRelogin == false) {
              Navigator.pop(context);
            }
          } else if (state is ProfileError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          if (state is ProfileLoading || isLoadingLocations) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF6B2D5C)),
            );
          }
          return _buildForm();
        },
      ),
    );
  }

  Widget _buildForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'Your Information',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),

            _buildTextField('First Name', _fNameCtrl),
            _buildTextField('Last Name', _lNameCtrl),
            _buildTextField('Phone Number', _phoneCtrl, isNumber: true),

            _buildLocationDropdown(
              label: 'Governorate',
              items: governorates,
              selectedItem: selectedGovernorate,
              isLoading: false,
              onChanged: (LocationItem? newValue) {
                if (newValue != null && newValue != selectedGovernorate) {
                  setState(() {
                    selectedGovernorate = newValue;
                    selectedCity = null;
                    cities = [];
                  });
                  _loadCities(newValue.id);
                }
              },
            ),

            _buildLocationDropdown(
              label: 'City',
              items: cities,
              selectedItem: selectedCity,
              isLoading: isLoadingCities,
              onChanged: (LocationItem? newValue) {
                setState(() {
                  selectedCity = newValue;
                });
              },
            ),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6B2D5C),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    if (selectedGovernorate == null || selectedCity == null) {
                      _showSnackBar("please select both governorate and city.");
                      return;
                    }
                    final updatedUser = UserModel(
                      id: _initialUser.id,
                      firstName: _fNameCtrl.text.trim(),
                      lastName: _lNameCtrl.text.trim(),
                      email: _initialUser.email,
                      phone: _phoneCtrl.text.trim(),
                      governorate: selectedGovernorate!.name,
                      city: selectedCity!.name,
                      access_token: _initialUser.access_token,
                    );

                    context.read<ProfileBloc>().add(
                      UpdateProfileEvent(updatedUser),
                    );
                  }
                },
                child: const Text(
                  'Save Changes',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFF2A488),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    bool isNumber = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF6B2D5C),
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            keyboardType: isNumber ? TextInputType.phone : TextInputType.text,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            validator:
                (val) =>
                    val == null || val.trim().isEmpty
                        ? 'Field cannot be empty'
                        : null,
          ),
        ],
      ),
    );
  }

  Widget _buildLocationDropdown({
    required String label,
    required List<LocationItem> items,
    required LocationItem? selectedItem,
    required Function(LocationItem?) onChanged,
    required bool isLoading,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF6B2D5C),
            ),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<LocationItem>(
            value: items.contains(selectedItem) ? selectedItem : null,
            icon:
                isLoading
                    ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Color(0xFF6B2D5C),
                      ),
                    )
                    : const Icon(Icons.arrow_drop_down),
            items:
                items.map((item) {
                  return DropdownMenuItem<LocationItem>(
                    value: item,
                    child: Text(item.name),
                  );
                }).toList(),
            onChanged: items.isEmpty || isLoading ? null : onChanged,
            decoration: InputDecoration(
              hintText:
                  items.isEmpty && !isLoading
                      ? 'choose a governorate first'
                      : 'Select $label',
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            validator: (val) => val == null ? 'Please select an option' : null,
          ),
        ],
      ),
    );
  }
}
