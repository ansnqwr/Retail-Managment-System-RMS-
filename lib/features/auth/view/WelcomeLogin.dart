import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/features/auth/data/models/Repository/signin_repository.dart';
import 'package:untitled/features/auth/view_model/bloc/login_bloc.dart';
import 'package:untitled/features/auth/view/login_screen.dart';
import 'package:untitled/features/auth/view/register_first_step.dart';
import 'package:untitled/features/home/HomeScreen.dart';

class WelcomeLoginScreen extends StatelessWidget {
  const WelcomeLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    const Color darkPurple = Color(0xFF603055); 
    const Color peachColor = Color(0xFFE79476); 
    const Color bgColor = Color(0xFFFCF9FC); 

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.08,
            vertical: size.height * 0.05,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. عنوان الصفحة
              const Text(
                "Welcome to Our\nStore!",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 38,
                  fontWeight: FontWeight.w900,
                  color: darkPurple,
                  height: 1.2,
                ),
              ),

              SizedBox(height: size.height * 0.08),

              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                   Center(
                child: Container(
                  width: 300,
                  height: 300,
                  padding: const EdgeInsets.all(12),
                  child: Image.asset(
                    'assets/images/SignIn.png',
                    fit: BoxFit.contain,
                  ),
                ),   
             )
                  ,
                 
                ],
              ),


              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder:
                          (_) => BlocProvider(
                            create:
                                (context) => LoginBloc(
                                  SigninRepository(),
                                ), 
                            child: const LoginScreen(),
                          )
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: darkPurple,
                  minimumSize: const Size(
                    double.infinity,
                    60,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  "log in",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: peachColor,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              SizedBox(height: size.height * 0.02),

              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const HomeScreen()),
                    );

                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                  ),
                  child: const Text(
                    "Continue as A Guest",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: darkPurple,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),


               Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => RegisterFirstStep()),
                    );
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                  ),
                  child: const Text(
                    "Sign up",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: darkPurple,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
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
}
