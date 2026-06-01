import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/features/auth/presentation/WelcomeLogin.dart';
import 'package:untitled/features/home/presentation/pages/HomeScreen.dart';
import 'package:untitled/features/onboarding/presentation/pages/onboarding_screen.dart';
import '../bloc/splash_bloc.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<SplashBloc, SplashState>(
        listener: (context, state) {
          if (state is SplashNavigateToOnboarding) {
            if (!context.mounted) return; // تأمين إضافي
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => OnboardingScreen()),
            );
          } else if (state is SplashNavigateToHome) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const HomeScreen()),
            );
          } else if (state is SplashNavigateToWelcome) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const WelcomeLoginScreen()),
            );
          }
        },
        builder: (context, state) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFFFFFFF),
                  Color(0xFFFDFAFD),
                  Color(0xFFFAF2FA),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // تمثيل الشعار باستخدام Hero Animation لتسهيل التحول للشاشات الأخرى بسلاسة
                    Hero(
                      tag: 'app_logo',
                      child: Container(
                        width: 310,
                        height: 310,
                        padding: const EdgeInsets.all(12),
                        child: Image.asset(
                          'assets/images/logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // تفعيل اسم التطبيق لإبراز الهوية البصرية
                    // const Text(
                    //   'دلني',
                    //   style: TextStyle(
                    //     fontFamily: 'Cairo', // خط Cairo العربي الأنيق
                    //     fontWeight: FontWeight.bold,
                    //     fontSize: 48,
                    //     color: Color(
                    //       0xFF6B2D5C,
                    //     ), // اللون البنفسجي الدافئ المطابق للشعار
                    //     letterSpacing: 1.2,
                    //   ),
                    // ),
                    const SizedBox(height: 48),

                    // يظهر مؤشر التقدم الدائري فقط أثناء انتظار استجابة البلوك ومحاكاة التحقق
                    if (state is SplashLoading || state is SplashInitial)
                      const SizedBox(
                        width: 28,
                        height: 28,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Color(0xFF9E497C),
                          ),
                        ),
                      ),
                  ],
                ),
                // كتابة الحقوق في أسفل الواجهة
                Positioned(
                  bottom: 40,
                  child: Text(
                    'تطبيق بيع بالتجزئة ذكي',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 14,
                      color: const Color(0xFF6B2D5C).withOpacity(0.5),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
