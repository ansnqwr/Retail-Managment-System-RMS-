import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/features/auth/bloc/login_bloc.dart';
import 'package:untitled/features/auth/presentation/SignupScreen.dart';
import 'package:untitled/models/registration_data.dart';

class RegisterFirstStep extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _firstCtrl = TextEditingController();
  final _lastCtrl = TextEditingController();

  RegisterFirstStep({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCF9FC),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            children: [
              // الشعار العلوي للتطبيق
              Center(
                child: Container(
                  width: 350,
                  height: 200,
                  padding: const EdgeInsets.all(12),
                  child: Image.asset(
                    'assets/images/logo.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              // نص الترحيب الملون
              const Center(
                child: Text(
                  "Welcome Back!",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 40.33,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFFF2A488),
                  ),
                ),
              ),

              // نص إرشادي لبدء التسجيل
              const Text(
                "Get Started Free",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF6B2D5C),
                ),
              ),
              const SizedBox(height: 20),

              // حقول الإدخال الأساسية
              _buildField("Email Address", _emailCtrl, Icons.email_outlined),
              _buildField("First Name", _firstCtrl, Icons.person_outline),
              _buildField("Last Name", _lastCtrl, Icons.person_outline),

              const SizedBox(height: 20),

              // زر الانتقال للمرحلة التالية
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6B2D5C),
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // تجميع البيانات المدخلة في كائن الـ Model
                    final data =
                        UserRegistrationData()
                          ..email = _emailCtrl.text.trim()
                          ..firstName = _firstCtrl.text.trim()
                          ..lastName = _lastCtrl.text.trim();

                    // 🚀 الانتقال المباشر والآمن وحقن الـ LoginBloc للشاشة القادمة
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (currentContext) => BlocProvider.value(
                              value:
                                  context
                                      .read<
                                        LoginBloc
                                      >(), // تمرير نفس الـ Instance النشط
                              child: SignupScreen(userData: data),
                            ),
                      ),
                    );
                  } else {
                    debugPrint("***********Form validation failed**********");
                  }
                },
                child: const Text(
                  "Next",
                  style: TextStyle(
                    color: Color(0xFFF2A488),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // وجبة بناء حقول الإدخال المخصصة المطابقة لتصميمك
  Widget _buildField(
    String label,
    TextEditingController controller,
    IconData icon,
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
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          validator:
              (val) => (val == null || val.isEmpty) ? 'Field required' : null,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFDED3DC).withOpacity(0.4),
            prefixIcon: Icon(icon, color: const Color(0xFF6B2D5C)),
            hintText: "@yourname",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }
}
