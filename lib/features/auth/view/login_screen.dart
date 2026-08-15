import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/features/home/view/RootScreen.dart';
import '/features/auth/view/forgot_password_screen.dart';
import '/features/auth/view/otp_screen.dart';
import '/features/auth/view/googleDataCollectionScreen.dart';
import '../../../../core/widgets/login_background_painter.dart';
import '../view_model/bloc/login_bloc.dart';
import 'SignupScreen.dart';
import 'register_first_step.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _saveRememberMeStatus() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('remember_me', _rememberMe);
  }

  @override
  Widget build(BuildContext context) {
    const Color darkPurple = Color(0xFF6B2D5C);

    return Scaffold(
      backgroundColor: const Color(0xFFFCF9FC),
      body: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) async {
          if (state is LoginLoading) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder:
                  (context) => const Center(
                    child: CircularProgressIndicator(color: Color(0xFFF2A488)),
                  ),
            );
          }

          if (state is GoogleAccountPicked) {
            if (Navigator.of(context).canPop()) Navigator.of(context).pop();

            Navigator.of(context).push(
              MaterialPageRoute(
                builder:
                    (_) => BlocProvider.value(
                      value: context.read<LoginBloc>(),
                      child: GoogleDataCollectionScreen(
                        email: state.email,
                        googleId: state.googleId,
                      ),
                    ),
              ),
            );
          }

          if (state is GoogleOtpSentSuccess) {
            if (Navigator.of(context).canPop()) Navigator.of(context).pop();

            Navigator.of(context).push(
              MaterialPageRoute(
                builder:
                    (_) => BlocProvider.value(
                      value: context.read<LoginBloc>(),
                      child: OtpScreen(
                        email: state.email,
                        flow: OtpFlow.googleLogin,
                        googleId: state.googleId,
                      ),
                    ),
              ),
            );
          }
          if (state is LoginFailure) {
            if (Navigator.of(context).canPop()) Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.redAccent,
                content: Text(state.error),
              ),
            );
          }

          if (state is LoginSuccess) {
            if (Navigator.of(context).canPop()) Navigator.of(context).pop();

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const RootScreen(isGuest: false),
              ),
            );
            await _saveRememberMeStatus();
            if (!context.mounted) return;
          }
        },
        child: Center(
          child: Container(
            width: 411,
            height: 823,
            decoration: BoxDecoration(
              color: const Color(0xFFFCF9FC),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 40,
                  offset: const Offset(10, 10),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: CustomPaint(painter: LoginBackgroundPainter()),
                  ),
                  SafeArea(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 180),
                            Text(
                              "Login",
                              style: TextStyle(
                                fontSize: 42,
                                fontWeight: FontWeight.w900,
                                color: darkPurple,
                              ),
                            ),
                            const SizedBox(height: 30),
                            Text(
                              "Email",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 5),
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              validator:
                                  (value) =>
                                      (value == null || value.isEmpty)
                                          ? 'Please enter the Email.'
                                          : null,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 15,
                                  vertical: 15,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              "Password",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 5),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: true,
                              validator:
                                  (value) =>
                                      (value == null || value.isEmpty)
                                          ? 'Please enter the password.'
                                          : null,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 15,
                                  vertical: 15,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Checkbox(
                                      value: _rememberMe,
                                      activeColor: const Color(0xFFF2A488),
                                      onChanged:
                                          (val) => setState(
                                            () => _rememberMe = val!,
                                          ),
                                    ),
                                    Text(
                                      "remember me",
                                      style: TextStyle(
                                        color: darkPurple,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder:
                                            (_) => BlocProvider.value(
                                              value: context.read<LoginBloc>(),
                                              child:
                                                  const ForgotPasswordScreen(),
                                            ),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    "Forgot Your Password?",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),
                            OutlinedButton(
                              onPressed: () {
                                context.read<LoginBloc>().add(
                                  TriggerGoogleSignInEvent(),
                                );
                              },
                              style: OutlinedButton.styleFrom(
                                minimumSize: const Size(double.infinity, 55),
                                side: const BorderSide(color: darkPurple),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.network(
                                    'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Google_"G"_Logo.svg/1200px-Google_"G"_Logo.svg.png',
                                    height: 22,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            const Icon(
                                              Icons.g_mobiledata,
                                              size: 30,
                                            ),
                                  ),
                                  const SizedBox(width: 15),
                                  Text(
                                    "Sign up with google",
                                    style: TextStyle(
                                      color: darkPurple,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 30),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Don't have an account? ",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder:
                                            (_) => BlocProvider.value(
                                              value: context.read<LoginBloc>(),
                                              child: RegisterFirstStep(),
                                            ),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    "Sign up",
                                    style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      decorationColor: Colors.blue,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 30),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      context.read<LoginBloc>().add(
                                        SubmitPasswordLoginEvent(
                                          email: _emailController.text,
                                          password: _passwordController.text,
                                        ),
                                      );
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: darkPurple,
                                    minimumSize: const Size(120, 55),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                  child: Text(
                                    "Login",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
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
  }
}
