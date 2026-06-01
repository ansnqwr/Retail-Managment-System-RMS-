part of 'splash_bloc.dart';

// @immutable
abstract class SplashState {}

class SplashInitial extends SplashState {}

class SplashLoading extends SplashState {}

class SplashNavigateToOnboarding extends SplashState {}

class SplashNavigateToWelcome extends SplashState {}

class SplashNavigateToHome extends SplashState {}
