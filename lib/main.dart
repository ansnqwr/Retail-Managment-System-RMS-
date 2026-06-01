import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// استيراد المستودعات (Repositories)
import 'package:untitled/Repository/signin_repository.dart';
import 'package:untitled/Repository/signup_repository.dart'; // تأكد من وجود هذا الملف لديك

// استيراد الـ Blocs الخاصة بالتطبيق
import 'package:untitled/features/auth/bloc/login_bloc.dart';
import 'package:untitled/features/auth/bloc/signup_bloc.dart';
import 'package:untitled/features/splash/presentation/bloc/splash_bloc.dart'; // عدل المسار حسب مجلد الـ Splash لديك
import 'package:untitled/features/splash/presentation/bloc/splash_event.dart';

// استيراد الشاشة الافتراضية الأولى عند إقلاع التطبيق
import 'package:untitled/features/splash/presentation/pages/splash_screen.dart'; // عدل المسار حسب مجلد الـ Splash لديك

void main() {
  // التأكد من تهيئة كل خدمات الواجهات بنجاح قبل إقلاع التطبيق
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const DelniApp());
}

class DelniApp extends StatelessWidget {
  const DelniApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      // 🚀 حقن مركزي لجميع البلوكات لضمان توفرها في أي Context وأي شاشة داخل التطبيق
      providers: [
        BlocProvider<SplashBloc>(
          create:
              (context) =>
                  SplashBloc()..add(
                    CheckSplashEvent(),
                  ), // بدء فحص حالة تسجيل الدخول فوراً
        ),
        BlocProvider<LoginBloc>(
          create: (context) => LoginBloc(SigninRepository()),
        ),
        BlocProvider<SignupBloc>(
          create:
              (context) => SignupBloc(
                SignupRepository(),
              ), // تم الحاق هنا لحل مشكلة الـ ProviderNotFound
        ),
      ],
      child: MaterialApp(
        title: 'دلني - Delni',
        debugShowCheckedModeBanner: false,

        // إعدادات الثيم البصري الموحد للتطبيق بناءً على هويتك البصرية
        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: const Color(
            0xFFFCF9FC,
          ), // الخلفية الموحدة الهادئة للشاشات
          primaryColor: const Color(
            0xFF6B2D5C,
          ), // اللون البنفسجي الغامق الأساسي
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF6B2D5C),
            primary: const Color(0xFF6B2D5C),
            secondary: const Color(
              0xFFF2A488,
            ), // اللون المشمشي/البرتقالي الهادئ
          ),

          // توحيد الخط الافتراضي للتطبيق (يدعم العربية والإنكليزية بجمالية عالية)
          fontFamily: 'Cairo',

          // تخصيص افتراضي شفاف ومريح للـ AppBar في التطبيق بالكامل
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.transparent,
            elevation: 0,
            iconTheme: IconThemeData(color: Color(0xFF6B2D5C)),
            centerTitle: true,
          ),
        ),

        // الشاشة الافتراضية الأولى عند تشغيل التطبيق
        home: const SplashScreen(),
      ),
    );
  }
}
