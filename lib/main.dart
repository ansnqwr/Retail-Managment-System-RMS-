import 'package:delni_rms/features/orders/view%20model/ordersRepository.dart';
import 'package:delni_rms/features/settings/view%20model/settingsRepository.dart';
import 'package:delni_rms/features/stores/view%20model/store_details_repository.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '/features/auth/data/models/Repository/signin_repository.dart';
import '/features/auth/data/models/Repository/signup_repository.dart';
import '/features/auth/view_model/bloc/login_bloc.dart';
import '/features/auth/view_model/bloc/signup_bloc.dart';
import 'features/auth/data/models/Repository/auth_local_data.dart';
import 'features/profiles/Model/profile_repository.dart';
import 'features/profiles/ViewModel/profile_bloc.dart';
import '/features/splash/view%20model/splash_bloc.dart';
import '/features/splash/view%20model/splash_event.dart';
import '/features/splash/view/splash_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  // await prefs.remove('settings_language');

  await TokenManager().loadTokens();

  final isGuest = prefs.getBool('is_guest') ?? false;
  final isLoggedIn = prefs.getBool('is_logged_in') ?? false;

  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en'),
        Locale('ar'),
        Locale('de'),
        Locale('fr'),
        Locale('es'),
        Locale('tr'),
        Locale('it'),
        Locale('ru'),
        Locale('zh'),
        Locale('ja'),
        Locale('fa'),
        Locale('ko'),
        // Locale('ga'),
        Locale('nl'),
        Locale('sv'),
        Locale('el'),
      ],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      useFallbackTranslations: true,
      child: DelniApp(isGuest: isGuest, isLoggedIn: isLoggedIn),
    ),
  );
}

class DelniApp extends StatelessWidget {
  final bool isGuest;
  final bool isLoggedIn;

  const DelniApp({super.key, required this.isGuest, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<SigninRepository>(create: (_) => SigninRepository()),
        RepositoryProvider<SignupRepository>(create: (_) => SignupRepository()),
        RepositoryProvider<ProfileRepository>(
          create: (_) => ProfileRepository(),
        ),
        RepositoryProvider<StoreDetailsRepository>(
          create: (_) => StoreDetailsRepository(http.Client()),
        ),

        RepositoryProvider<SettingsRepository>(
          create: (_) => SettingsRepositoryImpl(),
        ),

        RepositoryProvider<OrdersRepository>(
          create: (_) => OrdersRepositoryImpl(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<SplashBloc>(
            lazy: false,
            create: (_) => SplashBloc()..add(CheckSplashEvent()),
          ),
          BlocProvider<LoginBloc>(
            create: (context) => LoginBloc(context.read<SigninRepository>()),
          ),
          BlocProvider<SignupBloc>(
            create: (context) => SignupBloc(context.read<SignupRepository>()),
          ),
          BlocProvider<ProfileBloc>(
            create: (context) => ProfileBloc(context.read<ProfileRepository>()),
          ),
        ],
        child: Builder(
          builder: (context) {
            return MaterialApp(
              title: 'دلني - Delni',
              debugShowCheckedModeBanner: false,
              localizationsDelegates: [
                ...context.localizationDelegates,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: context.supportedLocales,
              locale: context.locale,
              theme: ThemeData(
                useMaterial3: true,
                scaffoldBackgroundColor: const Color(0xFFFCF9FC),
                primaryColor: const Color(0xFF6B2D5C),
                colorScheme: ColorScheme.fromSeed(
                  seedColor: const Color(0xFF6B2D5C),
                  primary: const Color(0xFF6B2D5C),
                  secondary: const Color(0xFFF2A488),
                ),
                appBarTheme: const AppBarTheme(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  iconTheme: IconThemeData(color: Color(0xFF6B2D5C)),
                  centerTitle: true,
                ),
              ),
              home: SplashScreen(isGuest: isGuest, isLoggedIn: isLoggedIn),
            );
          },
        ),
      ),
    );
  }
}
