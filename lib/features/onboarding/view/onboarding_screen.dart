import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '/features/auth/data/models/Repository/signup_repository.dart';
import '/features/auth/view/WelcomeLogin.dart';
import '/features/auth/view_model/bloc/signup_bloc.dart';
import '/features/onboarding/view%20model/OnboardingBloc.dart';
import '/features/onboarding/view%20model/onboarding_event.dart';
import '/features/onboarding/view%20model/onboarding_state.dart';

class OnboardingScreen extends StatelessWidget {
  final PageController _pageController = PageController();

  // الألوان الأساسية المستوحاة من تصميمك
  final Color primaryPurple = const Color(0xFF6A3B65);
  final Color textGrey = const Color(0xFF555555);

  OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // تزويد الشاشة بالـ BLoC
    return BlocProvider(
      create: (context) => OnboardingBloc(),
      child: Scaffold(
        backgroundColor: Colors.grey[50], // لون خلفية فاتح
        body: SafeArea(
          child: BlocBuilder<OnboardingBloc, OnboardingState>(
            builder: (context, state) {
              return Column(
                children: [
                  // 1. زر التخطي (Skip)
                  Align(
                    alignment: Alignment.topRight,
                    child: TextButton(
                      onPressed: () async {
                        // 1. حفظ في الذاكرة أن المستخدم لم يعد "أول مرة"
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setBool('isFirstTime', false);
                        if (!context.mounted) return;

                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder:
                                (_) => BlocProvider(
                                  create:
                                      (context) =>
                                          SignupBloc(SignupRepository()),
                                  child: const WelcomeLoginScreen(),
                                ),
                          ),
                        );
                      },
                      child: Text(
                        'Skip'.tr(),
                        style: TextStyle(
                          color: primaryPurple,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  // 2. المحتوى الرئيسي (PageView)
                  Expanded(
                    child: PageView(
                      controller: _pageController,
                      onPageChanged: (index) {
                        // إرسال حدث عند سحب الشاشة
                        context.read<OnboardingBloc>().add(
                          PageChangedEvent(index),
                        );
                      },
                      children: [
                        _buildFirstPage(context, state),
                        _buildSecondPage(),
                        // يمكنك إضافة الصفحة الثالثة هنا
                      ],
                    ),
                  ),

                  // 3. النقاط السفلية (Indicators)
                  SmoothPageIndicator(
                    controller: _pageController,
                    count: 3, // عدد الصفحات
                    effect: ExpandingDotsEffect(
                      activeDotColor: primaryPurple,
                      dotColor: Colors.grey.shade300,
                      dotHeight: 8,
                      dotWidth: 8,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 4. زر المتابعة الدائري
                  Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: InkWell(
                      onTap: () async {
                        // 1. إذا كان المستخدم في الصفحات الأولى، ينتقل للصفحة التالية داخل الـ Onboarding
                        if (state.currentPage < 1) {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                        // 2. إذا كان المستخدم في الصفحة الأخيرة وضغط على الزر (إنهاء الـ Onboarding)
                        else {
                          // حفظ في ذاكرة الهاتف أن المستخدم شاهد الـ Onboarding ولن تظهر له مجدداً
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.setBool('isFirstTime', false);

                          // التأكد من أن الـ Context ما زال متاحاً وموجوداً في شجرة الـ Widgets (ممارسة أمنية في Flutter)
                          if (!context.mounted) return;

                          // الانتقال إلى الشاشة الترحيبية وتدمير شاشة الـ Onboarding من الخلفية
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder:
                                  (_) =>
                                      const WelcomeLoginScreen(), // الانتقال للواجهة الترحيبية الاحترافية
                            ),
                          );
                        }
                      },
                      child: Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.grey.shade300,
                            width: 3,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: primaryPurple,
                            ),
                            child: const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 35,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildFirstPage(BuildContext context, OnboardingState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Select\nLanguage".tr(),
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: primaryPurple,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 15),
          Text(
            "Easy. Seamless. Delightful.\nShop your favorites anytime".tr(),
            style: TextStyle(
              fontSize: 16,
              color: primaryPurple.withOpacity(0.8),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 15),
          Center(
            child: SizedBox(
              width: 200,
              height: 200,
              child: Center(
                child: Image.asset(
                  'assets/images/Screenshot 2026-05-25 135830.png',
                ),
              ),
            ),
          ),

          //
          const SizedBox(height: 15),
          Text(
            "Your Language Preference".tr(),
            style: TextStyle(
              fontSize: 16,
              color: primaryPurple,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Divider(),
          // أزرار اختيار اللغة
          ListTile(
            title: Text('English'.tr()),
            leading: Radio<String>(
              value: 'English',
              groupValue: state.language,
              activeColor: primaryPurple,
              onChanged:
                  (value) => context.read<OnboardingBloc>().add(
                    LanguageSelectedEvent(value!),
                  ),
            ),
          ),
          ListTile(
            title: Text('Arabic'.tr()),
            leading: Radio<String>(
              value: 'Arabic',
              groupValue: state.language,
              activeColor: primaryPurple,
              onChanged:
                  (value) => context.read<OnboardingBloc>().add(
                    LanguageSelectedEvent(value!),
                  ),
            ),
          ),
        ],
      ),
    );
  }

  // ---- تفاصيل الصفحة الثانية (التريندات) ----
  Widget _buildSecondPage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Discover New\nTrends".tr(),
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: primaryPurple,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 15),
          Text(
            "Explore millions of products from\nyour favorite brands".tr(),
            style: TextStyle(
              fontSize: 16,
              color: primaryPurple.withOpacity(0.8),
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          Center(
            child: SizedBox(
              height: 250,
              width: 250,
              child: Image.asset(
                'assets/images/Screenshot 2026-05-25 135627.png',
              ),
            ),
          ), // استبدل بمسار صورتك
          const Spacer(),
        ],
      ),
    );
  }
}
