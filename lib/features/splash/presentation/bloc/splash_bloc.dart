import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/features/splash/presentation/bloc/splash_event.dart';
import '../../../../Repository/auth_local_data.dart'; 


part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(SplashInitial()) {
    on<CheckSplashEvent>(_onCheckSplash);
  }

  Future<void> _onCheckSplash(
    CheckSplashEvent event,
    Emitter<SplashState> emit,
  ) async {
    emit(SplashLoading());

    await Future.delayed(const Duration(seconds: 2));

    try {
      final prefs = await SharedPreferences.getInstance();

      final bool isFirstTime = prefs.getBool('isFirstTime') ?? true;

      if (isFirstTime) {
        emit(SplashNavigateToOnboarding());
        return; 
      }

      final bool rememberMe = prefs.getBool('remember_me') ?? false;

      await TokenManager().loadTokens();
      final bool hasToken = TokenManager().accessToken != null;

      if (rememberMe && hasToken) {
        emit(SplashNavigateToHome());
      } else {
        emit(SplashNavigateToWelcome());
      }
    } catch (e) {
      emit(SplashNavigateToWelcome());
    }
  }
}
