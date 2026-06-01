import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/features/splash/presentation/bloc/splash_event.dart';
import '../../../../Repository/auth_local_data.dart'; // تأكد من صحة مسار ملف TokenManager لديك


part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(SplashInitial()) {
    // ربط الحدث بالدالة المسؤولة عن الفحص
    on<CheckSplashEvent>(_onCheckSplash);
  }

  Future<void> _onCheckSplash(
    CheckSplashEvent event,
    Emitter<SplashState> emit,
  ) async {
    emit(SplashLoading());

    // 1. تأخير زمني بسيط (ثانيتين) لرؤية شعار التطبيق (Splash Screen)
    await Future.delayed(const Duration(seconds: 2));

    try {
      // 2. فتح الـ SharedPreferences لقراءة البيانات من ذاكرة الهاتف
      final prefs = await SharedPreferences.getInstance();

      // إذا لم يجد القيمة، سيعتبرها true (أي أول مرة يفتح التطبيق)
      final bool isFirstTime = prefs.getBool('isFirstTime') ?? true;

      // 3. التوجيه بناءً على حالة فتح التطبيق لأول مرة
      if (isFirstTime) {
        emit(SplashNavigateToOnboarding());
        return; // إنهاء الدالة هنا وتوجيهه للمقدمة
      }

      // 4. قراءة حالة "تذكرني" المحفوظة محلياً عند تسجيل الدخول الناجح
      final bool rememberMe = prefs.getBool('remember_me') ?? false;

      // 5. تحميل التوكنز المحفوظة من ذاكرة الهاتف إلى متغيرات الـ Global داخل الـ TokenManager
      await TokenManager().loadTokens();
      final bool hasToken = TokenManager().accessToken != null;

      // 6. اتخاذ قرار التوجيه الذكي
      if (rememberMe && hasToken) {
        // إذا كان المستخدم قد فعّل "تذكرني" والتوكن موجود -> نتوجه للرئيسية مباشرة 🚀
        emit(SplashNavigateToHome());
      } else {
        // إذا لم يفعّل الخيار أو سجل خروجه سابقاً -> يذهب لصفحة الترحيب/تسجيل الدخول المعتادة
        emit(SplashNavigateToWelcome());
      }
    } catch (e) {
      // في حال حدوث أي خطأ غير متوقع أثناء القراءة، نتوجه للأمان (واجهة الترحيب)
      emit(SplashNavigateToWelcome());
    }
  }
}
