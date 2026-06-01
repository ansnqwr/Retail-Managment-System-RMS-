import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/login_bloc.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;
  const ResetPasswordScreen({super.key, required this.email});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color darkPurple = Color(0xFF6B2D5C);
    const Color peachColor = Color(0xFFF2A488);

    return Scaffold(
      backgroundColor: const Color(0xFFFCF9FC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: darkPurple),
      ),
      body: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoginLoading) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder:
                  (_) => const Center(
                    child: CircularProgressIndicator(color: peachColor),
                  ),
            );
          }
          if (state is LoginFailure) {
            Navigator.of(context).pop(); 
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.redAccent,
                content: Text(state.error),
              ),
            );
          }
          if (state is ResetPasswordSuccess) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: Colors.green,
                content: Text("تمت إعادة تعيين كلمة المرور بنجاح!"),
              ),
            );
            Navigator.of(context).popUntil((route) => route.isFirst);
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),
                  Icon(
                    Icons.door_back_door_outlined,
                    size: 90,
                    color: darkPurple.withOpacity(0.8),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Forgot Password",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      color: darkPurple,
                      fontFamily: 'Cairo',
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Enter your email in this field to receive a link for resetting your password.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.black54,
                      height: 1.4,
                      fontFamily: 'Cairo',
                    ),
                  ),
                  const SizedBox(height: 30),

                  _buildPasswordTextField(
                    title: "Current Password",
                    controller: _currentPasswordController,
                    obscureText: _obscureCurrent,
                    onToggle:
                        () =>
                            setState(() => _obscureCurrent = !_obscureCurrent),
                    validator:
                        (val) =>
                            (val == null || val.isEmpty)
                                ? 'الرجاء إدخال كلمة المرور الحالية'
                                : null,
                  ),
                  const SizedBox(height: 20),

                  _buildPasswordTextField(
                    title: "Create Password",
                    controller: _newPasswordController,
                    obscureText: _obscureNew,
                    onToggle: () => setState(() => _obscureNew = !_obscureNew),
                    validator: (val) {
                      if (val == null || val.isEmpty)
                        return 'الرجاء إدخال كلمة المرور الجديدة';
                      if (val.length < 6)
                        return 'يجب أن لا تقل كلمة المرور عن 6 محارف';
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  _buildPasswordTextField(
                    title: "Confirm Password",
                    controller: _confirmPasswordController,
                    obscureText: _obscureConfirm,
                    onToggle:
                        () =>
                            setState(() => _obscureConfirm = !_obscureConfirm),
                    validator: (val) {
                      if (val == null || val.isEmpty)
                        return 'الرجاء تأكيد كلمة المرور';
                      if (val != _newPasswordController.text)
                        return 'كلمات المرور غير متطابقة!';
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),

               Padding(
        padding: const EdgeInsets.all(30.0),
        child: ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              context.read<LoginBloc>().add(
                ResetPasswordSubmittedEvent(
                  email: widget.email, 
                  currentPassword: _currentPasswordController.text,
                  newPassword: _newPasswordController.text,
                ),
              );
          }
          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: darkPurple,
                      minimumSize: const Size(double.infinity, 55),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 3,
                    ),
                    child: const Text(
                      "Reset",
                      style: TextStyle(
                        color: Color(0xFFE2B78B),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordTextField({
    required String title,
    required TextEditingController controller,
    required bool obscureText,
    required VoidCallback onToggle,
    required String? Function(String?)? validator,
  }) {
    const Color darkPurple = Color(0xFF6B2D5C);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.center,
          child: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: darkPurple,
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.w600),
          validator: validator,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 15,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                obscureText
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: Colors.black54,
              ),
              onPressed: onToggle,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: darkPurple, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: darkPurple, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: Colors.redAccent, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
