import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/features/home/view/RootScreen.dart';
import '../view_model/bloc/login_bloc.dart';
import '/features/auth/view/reset_password_screen.dart';

enum OtpFlow { googleLogin, forgotPassword }

class OtpScreen extends StatefulWidget {
  final String email;
  final OtpFlow flow;

  const OtpScreen({super.key, required this.email, required this.flow});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  int _start = 30;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _start = 30;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_start == 0) {
        setState(() => _timer?.cancel());
      } else {
        setState(() => _start--);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var c in _controllers) c.dispose();
    for (var f in _focusNodes) f.dispose();
    super.dispose();
  }

  void _submitOtp(BuildContext context) {
    String otp = _controllers.map((c) => c.text).join();
    if (otp.length == 6) {
      context.read<LoginBloc>().add(
        VerifyOtpEvent(
          email: widget.email,
          otpCode: otp,
          isForgotPassword: widget.flow == OtpFlow.forgotPassword,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter the entire code".tr())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color darkPurple = Color(0xFF6B2D5C);

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
                    child: CircularProgressIndicator(color: Color(0xFFF2A488)),
                  ),
            );
          }

          if (state is LoginFailure) {
            if (Navigator.of(context).canPop()) Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.redAccent,
                content: Text(state.error.tr()),
              ),
            );
          }

          if (state is OtpVerifiedSuccess) {
            // Forgot-password OTP verified → let user reset password
            if (Navigator.of(context).canPop()) Navigator.of(context).pop();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => ResetPasswordScreen(email: state.email),
              ),
            );
          } else if (state is LoginSuccess) {
            // Google or normal login OTP verified → home
            if (Navigator.of(context).canPop()) Navigator.of(context).pop();
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (_) => const RootScreen(isGuest: false),
              ),
              (route) => false,
            );
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 30),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Almost there".tr(),
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: darkPurple,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    widget.flow == OtpFlow.forgotPassword
                        ? "Please enter the 6-digit code sent to your\nemail to reset your password."
                            .tr()
                        : "Please enter the 6-digit code sent to your\nemail for verification."
                            .tr(),
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.black54,
                      height: 1.4,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(6, (index) {
                    return Container(
                      width: 48,
                      height: 52,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEBE3EB),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextFormField(
                        controller: _controllers[index],
                        focusNode: _focusNodes[index],
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: darkPurple,
                        ),
                        decoration: const InputDecoration(
                          counterText: "",
                          border: InputBorder.none,
                        ),
                        onChanged: (value) {
                          if (value.isNotEmpty && index < 5) {
                            _focusNodes[index + 1].requestFocus();
                          }
                          if (value.isEmpty && index > 0) {
                            _focusNodes[index - 1].requestFocus();
                          }
                          if (index == 5 && value.isNotEmpty) {
                            _focusNodes[index].unfocus();
                          }
                        },
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () => _submitOtp(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: darkPurple,
                    minimumSize: const Size(double.infinity, 55),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Text(
                    "VERIFY".tr(),
                    style: TextStyle(
                      color: Color(0xFFE2B78B),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 60),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Didn’t receive any code? ".tr(),
                      style: TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap:
                          _start == 0
                              ? () {
                                if (widget.flow == OtpFlow.googleLogin) {
                                  context.read<LoginBloc>().add(
                                    TriggerGoogleSignInEvent(),
                                  );
                                } else {
                                  context.read<LoginBloc>().add(
                                    ForgotPasswordRequestedEvent(
                                      email: widget.email,
                                    ),
                                  );
                                }
                                _startTimer();
                              }
                              : null,
                      child: Text(
                        "Resend Again".tr(),
                        style: TextStyle(
                          color: _start == 0 ? darkPurple : Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  _start == 0
                      ? "You can request a new code now".tr()
                      : "Request new code in 00:${_start.toString().padLeft(2, '0')}s",
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
