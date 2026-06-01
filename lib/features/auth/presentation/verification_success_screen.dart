import 'package:flutter/material.dart';
import 'package:untitled/features/home/presentation/pages/HomeScreen.dart';

class VerificationSuccessScreen extends StatelessWidget {
  const VerificationSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color darkPurple = Color(0xFF6B2D5C);
    const Color peachColor = Color(0xFFF2A488);

    return Scaffold(
      backgroundColor: const Color(0xFFFCF9FC),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),

              const Text(
                "Verification Successful",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: darkPurple,
                  fontFamily: 'Cairo',
                ),
              ),
              const SizedBox(height: 40),

              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  color: darkPurple,
                  shape: BoxShape.circle,
                  border: Border.all(color: peachColor, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: darkPurple.withOpacity(0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Icon(Icons.check, size: 70, color: peachColor),
              ),
              const SizedBox(height: 40),

              const Text(
                "Your account is now verified. You can now explore our latest products and enjoy a seamless shopping experience",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black54,
                  height: 1.5,
                  fontFamily: 'Cairo',
                ),
              ),

              const Spacer(),

              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const HomeScreen()),
                    (route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: darkPurple,
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 2,
                ),
                child: const Text(
                  "Next",
                  style: TextStyle(
                    color: peachColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
