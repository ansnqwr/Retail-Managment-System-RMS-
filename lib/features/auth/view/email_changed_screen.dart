import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/features/auth/data/models/Repository/signin_repository.dart'
    show SigninRepository;
import '/features/auth/view_model/bloc/login_bloc.dart';
import '/features/auth/view/login_screen.dart';

class EmailChangedScreen extends StatelessWidget {
  const EmailChangedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color darkPurple = Color(0xFF6B2D5C);
    const Color peachColor = Color(0xFFF2A488);
    const Color backgroundColor = Color(0xFFFCF9FC);

    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.08),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(flex: 3),

              // Success Checkmark Badge
              Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(
                  color: darkPurple,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(Icons.check, color: peachColor, size: 50),
                ),
              ),
              const SizedBox(height: 35),

              // Title: Password Changed!
              const SizedBox(
                width: 300,
                height: 31,
                child: Text(
                  "Email has been changed successfully!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Urbanist',
                    fontWeight: FontWeight.w700,
                    fontSize: 26,
                    color: darkPurple,
                    height: 1.0,
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // Subtitle Description Text
              const SizedBox(
                width: 226,
                height: 46,
                child: Text(
                  "Your email has been changed successfully.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Urbanist',
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                    color: Colors.black54,
                    height: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // Action Button: Back to Login
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder:
                          (_) => BlocProvider(
                            create: (context) => LoginBloc(SigninRepository()),
                            child: const LoginScreen(),
                          ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: darkPurple,
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  "Back to Login",
                  style: TextStyle(
                    fontFamily: 'Urbanist',
                    color: peachColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const Spacer(flex: 4),
            ],
          ),
        ),
      ),
    );
  }
}
