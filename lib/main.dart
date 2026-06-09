import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:untitled/features/auth/data/models/Repository/signin_repository.dart';
import 'package:untitled/features/auth/data/models/Repository/signup_repository.dart';

import 'package:untitled/features/auth/view_model/bloc/login_bloc.dart';
import 'package:untitled/features/auth/view_model/bloc/signup_bloc.dart';
import 'package:untitled/features/home/Model/profile_repository.dart';
import 'package:untitled/features/home/view%20model/profile_bloc.dart';

import 'package:untitled/features/splash/view%20model/splash_bloc.dart';
import 'package:untitled/features/splash/view%20model/splash_event.dart';

import 'package:untitled/features/splash/view/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const DelniApp());
}
class DelniApp extends StatelessWidget {
  const DelniApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. نوفر الـ Repositories أولاً
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => SigninRepository()),
        RepositoryProvider(create: (context) => SignupRepository()),
        RepositoryProvider(
          create: (context) => ProfileRepository(),
        ), // <--- هذا كان ناقصاً
      ],
      // 2. الآن يمكننا بناء الـ BlocProvider لأنه يرى الـ Repository
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

            // fontFamily: 'Cairo',
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.transparent,

              elevation: 0,

              iconTheme: IconThemeData(color: Color(0xFF6B2D5C)),

              centerTitle: true,
            ),          ),
          home: const SplashScreen(),
        ),
      ),
    );
  }
}
