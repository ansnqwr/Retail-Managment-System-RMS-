import 'package:easy_localization/easy_localization.dart';

import '/features/home/view/RootScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/features/auth/data/models/Repository/signin_repository.dart';
import '/features/auth/view_model/bloc/login_bloc.dart';
import '/features/auth/view_model/bloc/signup_bloc.dart';
import '/features/auth/view_model/bloc/signup_event.dart';
import '/features/auth/view_model/bloc/signup_state.dart';
import '/features/auth/view/login_screen.dart';
import '/features/auth/data/models/registration_data.dart';

class LocationItem {
  final int id;
  final String name;
  LocationItem({required this.id, required this.name});
}

class SignupScreen extends StatefulWidget {
  final UserRegistrationData userData;

  const SignupScreen({super.key, required this.userData});
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passCtrl = TextEditingController();
  final TextEditingController _confirmPassCtrl = TextEditingController();
  final TextEditingController _numberCtrl = TextEditingController();

  List<LocationItem> _governorates = [];
  List<LocationItem> _cities = [];

  int? _selectedGovernorateId;
  String? _selectedGovernorateName;
  int? _selectedCityId;
  String? _selectedCityName;
  bool _isLoadingCities = false;

  @override
  void initState() {
    super.initState();
    context.read<SignupBloc>().add(FetchGovernoratesEvent());
  }

  @override
  void dispose() {
    _passCtrl.dispose();
    _confirmPassCtrl.dispose();
    _numberCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFFCF9FC),
      body: SafeArea(
        child: BlocListener<SignupBloc, SignupState>(
          listener: (context, state) {
            // معالجة حالات المحافظات
            if (state is GovernoratesLoadedState) {
              setState(() {
                _governorates = state.governorates;
                print(
                  'تم تحميل ${state.governorates.length} محافظة',
                ); // للتصحيح
              });
            } else if (state is GovernoratesErrorState) {
              print('خطأ في المحافظات: ${state.message}'); // للتصحيح
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message.tr()),
                  backgroundColor: Colors.red,
                ),
              );
            } else if (state is CitiesLoadingState) {
              setState(() {
                _isLoadingCities = true;
                _cities = [];
                _selectedCityId = null;
                _selectedCityName = null;
              });
              print('جاري تحميل المدن...'); // للتصحيح
            } else if (state is CitiesLoadedState) {
              setState(() {
                _isLoadingCities = false;
                _cities = state.cities;
              });
              print('تم تحميل ${state.cities.length} مدينة'); // للتصحيح
            } else if (state is CitiesErrorState) {
              setState(() {
                _isLoadingCities = false;
              });
              print('خطأ في المدن: ${state.message}'); // للتصحيح
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message.tr()),
                  backgroundColor: Colors.red,
                ),
              );
            }
            // معالجة حالات التسجيل
            else if (state is SignupSuccess) {
              print('تم التسجيل بنجاح'); // للتصحيح
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const RootScreen(isGuest: false),
                ),
              );
            } else if (state is SignupFailure) {
              print('خطأ في التسجيل: ${state.errorMessage}'); // للتصحيح
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage.tr()),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          child: Form(
            key: _formKey,
            child: ListView(
              padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.08,
                vertical: size.height * 0.02,
              ),
              children: [
                Text(
                  "Continue\nSign up".tr(),
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFFF2A488),
                    height: 1.0,
                  ),
                ),
                SizedBox(height: size.height * 0.03),

                _buildField("Create Password", _passCtrl, isObscure: true),
                _buildField(
                  "Confirm Password".tr(),
                  _confirmPassCtrl,
                  isObscure: true,
                ),
                _buildField("Number", _numberCtrl),
                const SizedBox(height: 15),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // قائمة المحافظات
                    Expanded(
                      child: _buildDropdown(
                        "Governorate",
                        _governorates,
                        _selectedGovernorateId,
                        (val) {
                          setState(() {
                            _selectedGovernorateId = val;
                            _selectedCityId = null;
                            _selectedCityName = null;
                            _cities = [];

                            if (val != null) {
                              _selectedGovernorateName =
                                  _governorates
                                      .firstWhere((g) => g.id == val)
                                      .name;
                            }
                          });

                          if (val != null) {
                            context.read<SignupBloc>().add(
                              FetchCitiesEvent(governorateId: val),
                            );
                          }
                        },
                      ),
                    ),
                    SizedBox(width: size.width * 0.04),

                    // قائمة المدن مع حالة التحميل
                    Expanded(
                      child: _buildDropdownWithLoading(
                        "City",
                        _cities,
                        _selectedCityId,
                        (val) {
                          setState(() {
                            _selectedCityId = val;
                            if (val != null) {
                              _selectedCityName =
                                  _cities.firstWhere((c) => c.id == val).name;
                            }
                          });
                        },
                        _isLoadingCities,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: size.height * 0.04),
                _buildSignupButton(),
                _buildLoginLink(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField(
    String label,
    TextEditingController controller, {
    bool isObscure = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.tr(),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF6B2D5C),
          ),
        ),
        const SizedBox(height: 5),
        TextFormField(
          controller: controller,
          obscureText: isObscure,
          validator: (val) {
            if (val == null || val.isEmpty) return 'Required';
            if (label == "Confirm Password" && val != _passCtrl.text) {
              return 'Passwords do not match';
            }
            return null;
          },
          decoration: _inputDecoration(),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildDropdown(
    String label,
    List<LocationItem> items,
    int? value,
    Function(int?) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.tr(),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF6B2D5C),
          ),
        ),
        const SizedBox(height: 5),
        DropdownButtonFormField<int>(
          isExpanded: true,
          value: value,
          hint: Text(' $label'),
          items:
              items.map((item) {
                return DropdownMenuItem<int>(
                  value: item.id,
                  child: Text(item.name.tr(), overflow: TextOverflow.ellipsis),
                );
              }).toList(),
          onChanged: onChanged,
          decoration: _inputDecoration(),
          validator: (val) => val == null ? 'Select $label' : null,
        ),
      ],
    );
  }

  // دالة جديدة للـ Dropdown مع حالة التحميل
  Widget _buildDropdownWithLoading(
    String label,
    List<LocationItem> items,
    int? value,
    Function(int?) onChanged,
    bool isLoading,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.tr(),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF6B2D5C),
          ),
        ),
        const SizedBox(height: 5),
        if (isLoading)
          Container(
            height: 55,
            decoration: BoxDecoration(
              color: const Color(0xFFDED3DC).withOpacity(0.4),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Color(0xFF6B2D5C),
                  strokeWidth: 2.5,
                ),
              ),
            ),
          )
        else
          DropdownButtonFormField<int>(
            isExpanded: true,
            value: value,
            hint: Text(' $label'),
            items:
                items.map((item) {
                  return DropdownMenuItem<int>(
                    value: item.id,
                    child: Text(
                      item.name.tr(),
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList(),
            onChanged: onChanged,
            decoration: _inputDecoration(),
            validator: (val) => val == null ? 'Select $label' : null,
          ),
      ],
    );
  }

  Widget _buildSignupButton() {
    return BlocBuilder<SignupBloc, SignupState>(
      builder: (context, state) {
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF6B2D5C),
            minimumSize: const Size(double.infinity, 55),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          onPressed:
              state is SignupLoading
                  ? null
                  : () {
                    if (_formKey.currentState!.validate()) {
                      Map<String, dynamic> finalRequest = {
                        "email": widget.userData.email,
                        "first_name": widget.userData.firstName,
                        "last_name": widget.userData.lastName,
                        "password": _passCtrl.text,
                        "confirm_password": _confirmPassCtrl.text,
                        "governorate": _selectedGovernorateName ?? '',
                        "phone_number": _numberCtrl.text,
                        "city": _selectedCityName ?? '',
                      };

                      print('Register Data: $finalRequest'); // للتصحيح
                      context.read<SignupBloc>().add(
                        SubmitSignupEvent(finalRequest),
                      );
                    }
                  },
          child:
              state is SignupLoading
                  ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: Color(0xFFF2A488),
                      strokeWidth: 2.5,
                    ),
                  )
                  : Text(
                    "Sign up".tr(),
                    style: TextStyle(
                      color: Color(0xFFF2A488),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
        );
      },
    );
  }

  Widget _buildLoginLink() {
    return TextButton(
      onPressed:
          () => Navigator.of(context).push(
            MaterialPageRoute(
              builder:
                  (_) => BlocProvider(
                    create: (context) => LoginBloc(SigninRepository()),
                    child: const LoginScreen(),
                  ),
            ),
          ),
      child: RichText(
        text: TextSpan(
          text: "Already have an account? Login ".tr(),
          style: TextStyle(color: Colors.grey),
          children: [
            TextSpan(
              text: "here.".tr(),
              style: TextStyle(
                color: Color(0xFFF2A488),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: const Color(0xFFDED3DC).withOpacity(0.4),
      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }
}
