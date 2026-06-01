import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:untitled/Repository/signin_repository.dart';
import 'package:untitled/Repository/signup_repository.dart';

import 'package:untitled/features/auth/bloc/login_bloc.dart';
import 'package:untitled/features/auth/bloc/signup_bloc.dart';
import 'package:untitled/features/auth/presentation/email_changed_screen.dart';
import 'package:untitled/features/auth/presentation/forgot_password_screen.dart';
import 'package:untitled/features/auth/presentation/password_changed_screen.dart';
import 'package:untitled/features/auth/presentation/reset_password_screen.dart';
import 'package:untitled/features/splash/presentation/bloc/splash_bloc.dart';
import 'package:untitled/features/splash/presentation/bloc/splash_event.dart';

import 'package:untitled/features/splash/presentation/pages/splash_screen.dart'; 

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const DelniApp());
}

class DelniApp extends StatelessWidget {
  const DelniApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SplashBloc>(
          create:
              (context) =>
                  SplashBloc()..add(
                    CheckSplashEvent(),
                  ),
        ),
        BlocProvider<LoginBloc>(
          create: (context) => LoginBloc(SigninRepository()),
        ),
        BlocProvider<SignupBloc>(
          create:
              (context) => SignupBloc(
                SignupRepository(),
              ),
        ),
      ],
      child: MaterialApp(
        title: 'دلني - Delni',
        debugShowCheckedModeBanner: false,

        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: const Color(
            0xFFFCF9FC,
          ),
          primaryColor: const Color(
            0xFF6B2D5C,
          ),
          
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF6B2D5C),
            primary: const Color(0xFF6B2D5C),
            secondary: const Color(
              0xFFF2A488,
            ),
          ),

          // fontFamily: 'Cairo',

          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.transparent,
            elevation: 0,
            iconTheme: IconThemeData(color: Color(0xFF6B2D5C)),
            centerTitle: true,
          ),
        ),

        home:
        //  const EmailChangedScreen(),
        const SplashScreen(),
// BlocProvider(
//           create:
//               (context) => LoginBloc(
//                 SigninRepository(),
//               ),
//           child: const ResetPasswordScreen(
//             email: "test_user@gmail.com",
//           ), 
//         ), 
        
             ),
    );
  }
}
