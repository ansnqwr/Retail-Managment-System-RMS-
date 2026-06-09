import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/features/auth/data/models/Repository/signin_repository.dart';
import 'package:untitled/features/auth/view_model/bloc/login_bloc.dart';
import 'package:untitled/features/auth/view_model/bloc/signup_bloc.dart';
import 'package:untitled/features/auth/view_model/bloc/signup_event.dart';
import 'package:untitled/features/auth/view_model/bloc/signup_state.dart';
import 'package:untitled/features/auth/view/login_screen.dart';
import 'package:untitled/features/auth/data/models/registration_data.dart';
import 'package:untitled/features/home/view/HomeScreen.dart';

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
  final TextEditingController _jobCtrl = TextEditingController();
  final TextEditingController _birthCtrl = TextEditingController();

  List<LocationItem> _cities = [];
  List<LocationItem> _towns = [];

  int? _selectedCityId;
  String? _selectedCityName;
  int? _selectedTownId;
  String? _selectedTownName;
  bool _isLoadingTowns = false;

  @override
  void initState() {
    super.initState();
    context.read<SignupBloc>().add(FetchCitiesEvent());
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFFCF9FC),
      body: SafeArea(
        child: BlocListener<SignupBloc, SignupState>(
          listener: (context, state) {
            if (state is CitiesLoadedState) {
              setState(() {
                _cities = state.cities;
              });
            } else if (state is TownsLoadingState) {
              setState(() {
                _isLoadingTowns = true;
                _towns = [];
                _selectedTownId = null;
              });
            } else if (state is TownsLoadedState) {
              setState(() {
                _isLoadingTowns = false;
                _towns = state.towns;
              });
            } else if (state is SignupSuccess) {
              // 1. التعديل الأول: الانتقال للشاشة الرئيسية يحدث هنا فقط عند النجاح
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
            } else if (state is SignupFailure) {
              // إظهار رسالة خطأ في حال فشل السيرفر في تسجيل الدخول
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage),
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
                const Text(
                  "Continue\nSign up",
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
                  "Confirm Password",
                  _confirmPassCtrl,
                  isObscure: true,
                ),
                _buildField("Number", _numberCtrl),
                _buildField("Job", _jobCtrl),
                _buildField("Birthday", _birthCtrl),

                const SizedBox(height: 15),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // قائمة المحافظات
                    Expanded(
                      child: _buildDropdown("City", _cities, _selectedCityId, (
                        val,
                      ) {
                        setState(() {
                          _selectedCityId = val;
                          // حفظ اسم المدينة لإرساله للسيرفر
                          _selectedCityName =
                              _cities.firstWhere((city) => city.id == val).name;
                        });
                        if (val != null) {
                          context.read<SignupBloc>().add(
                            FetchTownsEvent(cityId: val),
                          );
                        }
                      }),
                    ),
                    SizedBox(width: size.width * 0.04),

                    // قائمة البلدات
                    Expanded(
                      child:
                          _isLoadingTowns
                              ? const Padding(
                                padding: EdgeInsets.only(top: 30),
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: Color(0xFF6B2D5C),
                                  ),
                                ),
                              )
                              : _buildDropdown(
                                "Town",
                                _towns,
                                _selectedTownId,
                                (val) {
                                  setState(() {
                                    _selectedTownId = val;
                                    // حفظ اسم البلدة لإرساله للسيرفر
                                    _selectedTownName =
                                        _towns
                                            .firstWhere(
                                              (town) => town.id == val,
                                            )
                                            .name;
                                  });
                                },
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
          label,
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
            // تجاهل التحقق من حقلي الوظيفة وتاريخ الميلاد
            // if (label == "Job" || label == "Birthday") return null;

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
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF6B2D5C),
          ),
        ),
        const SizedBox(height: 5),
        DropdownButtonFormField<int>(
          isExpanded: true,
          value: value,
          items:
              items
                  .map(
                    (item) => DropdownMenuItem<int>(
                      value: item.id,
                      child: Text(item.name, overflow: TextOverflow.ellipsis),
                    ),
                  )
                  .toList(),
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
                        "governorate": _selectedTownName ?? '',
                        "phone_number": _numberCtrl.text,
                        "city": _selectedCityName ?? '',   
                        // "job": _jobCtrl.text,        
                        // "birthday": _birthCtrl.text,
                      };

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
                  : const Text(
                    "Sign up",
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
        text: const TextSpan(
          text: "Already have an account? Login ",
          style: TextStyle(color: Colors.grey),
          children: [
            TextSpan(
              text: "here.",
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
