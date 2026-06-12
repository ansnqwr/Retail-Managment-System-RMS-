import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/features/auth/view/email_changed_screen.dart';
import '/features/auth/view/forgot_password_screen.dart';
import '/features/auth/view_model/bloc/login_bloc.dart';
import '../ViewModel/profile_bloc.dart'
    show
        ChangeEmailEvent,
        ProfileActionSuccess,
        ProfileBloc,
        ProfileError,
        ProfileLoading,
        ProfileState;

class ChangeEmailView extends StatefulWidget {
  const ChangeEmailView({super.key});

  @override
  State<ChangeEmailView> createState() => _ChangeEmailViewState();
}

class _ChangeEmailViewState extends State<ChangeEmailView> {
  final _formKey = GlobalKey<FormState>();
  final _newEmailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  final Color _primaryColor = const Color(0xFF6B2D5C);
  final Color _accentColor = const Color(0xFFF3A886);

  @override
  void dispose() {
    _newEmailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocListener<ProfileBloc, ProfileState>(
          listener: (context, state) {
            // الانتقال يتم هنا فقط وبشكل آمن بعد نجاح العملية تماماً
            if (state is ProfileActionSuccess && state.requiresRelogin) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
              Navigator.of(
                context,
              ).pushNamedAndRemoveUntil('/login', (route) => false);
            } else if (state is ProfileError) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBackButton(),
                  const SizedBox(height: 32),
                  Text(
                    'Create new Email',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: _primaryColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Create a new account with your email and password, then go to the login page',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 32),
                  _buildTextField(
                    controller: _newEmailCtrl,
                    hint: 'New Email',
                    isObscure: false,
                    keyboardType: TextInputType.emailAddress,
                    validator:
                        (val) =>
                            val == null || !val.contains('@')
                                ? 'Enter a valid email'
                                : null,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _passwordCtrl,
                    hint: 'Current Password',
                    isObscure: true,
                    validator:
                        (val) =>
                            val == null || val.isEmpty
                                ? 'Required to confirm identity'
                                : null,
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder:
                                (_) => BlocProvider.value(
                                  value: context.read<LoginBloc>(),
                                  child: const ForgotPasswordScreen(),
                                ),
                          ),
                        );
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        'forgot old password?',
                        style: TextStyle(color: _primaryColor, fontSize: 13),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  BlocBuilder<ProfileBloc, ProfileState>(
                    builder: (context, state) {
                      if (state is ProfileLoading) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF6B2D5C),
                          ),
                        );
                      }
                      return SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              context.read<ProfileBloc>().add(
                                ChangeEmailEvent(
                                  _newEmailCtrl.text.trim(),
                                  _passwordCtrl.text.trim(),
                                ),
                              );
                            }
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => const EmailChangedScreen(),
                              ),
                            );

                            //    Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder:
                            //         (context) => BlocProvider(
                            //           create:
                            //               (context) =>
                            //                   ProfileBloc(ProfileRepository())
                            //                     ..add(LoadProfileEvent()),
                            //           child: const ProfileView(),
                            //         ),
                            //   ),
                            // );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'Reset Email',
                            style: TextStyle(
                              color: _accentColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackButton() {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: _accentColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(Icons.arrow_back_ios_new, color: _primaryColor, size: 20),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required String? Function(String?) validator,
    bool isObscure = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isObscure,
      keyboardType: keyboardType,
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: _primaryColor.withOpacity(0.7),
          fontSize: 14,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: _primaryColor, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: _primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
      ),
      validator: validator,
    );
  }
}
