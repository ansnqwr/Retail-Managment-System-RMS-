import 'package:delni_rms/features/home/view%20model/CartBloc.dart';
import 'package:delni_rms/features/home/view%20model/CartRepository.dart';
import 'package:delni_rms/features/home/view%20model/FavoritesRepository.dart';
import 'package:delni_rms/features/home/view%20model/favorites_bloc.dart';
import 'package:delni_rms/features/home/view%20model/store_details_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart'; // تمت إضافة المكتبة هنا

import '/features/auth/data/models/Repository/signin_repository.dart';
import '/features/auth/data/models/Repository/signup_repository.dart';
import '/features/auth/view_model/bloc/login_bloc.dart';
import '/features/auth/view_model/bloc/signup_bloc.dart';
import 'features/profiles/Model/profile_repository.dart';
import 'features/profiles/ViewModel/profile_bloc.dart';
import '/features/splash/view%20model/splash_bloc.dart';
import '/features/splash/view%20model/splash_event.dart';
import '/features/splash/view/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final bool isGuest = prefs.getBool('is_guest') ?? false;
  final bool isLoggedIn = prefs.getBool('is_logged_in') ?? false;

  runApp(DelniApp(isGuest: isGuest, isLoggedIn: isLoggedIn));
}

class DelniApp extends StatelessWidget {
  final bool isGuest;
  final bool isLoggedIn;

  const DelniApp({super.key, required this.isGuest, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => SigninRepository()),
        RepositoryProvider(create: (context) => SignupRepository()),
        RepositoryProvider(create: (context) => ProfileRepository()),
        RepositoryProvider(
          create: (context) => StoreDetailsRepository(http.Client()),
        ),
        BlocProvider(
          create: (context) => CartBloc(CartRepository(http.Client())),
        ),
        BlocProvider(
          create:
              (context) => FavoritesBloc(FavoritesRepository(http.Client())),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<SplashBloc>(
            create: (context) => SplashBloc()..add(CheckSplashEvent()),
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
        child: MaterialApp(
          title: 'دلني - Delni',
          debugShowCheckedModeBanner: false,
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
        ),
      ),
    );
  }
}
