// lib/features/auth/presentation/bloc/login_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../../Repository/signin_repository.dart'; 

// --- Events ---
abstract class LoginEvent {}

class TriggerGoogleSignInEvent extends LoginEvent {}

class SubmitPasswordLoginEvent extends LoginEvent {
  final String email;
  final String password;
  SubmitPasswordLoginEvent({required this.email, required this.password});
}

// --- States ---
abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class GoogleOtpSentSuccess extends LoginState {
  final String email;
  GoogleOtpSentSuccess(this.email);
}

class LoginFailure extends LoginState {
  final String error;
  LoginFailure(this.error);
}

class LoginSuccess extends LoginState {}


class ForgotPasswordRequestedEvent extends LoginEvent {
  final String email;
  ForgotPasswordRequestedEvent({required this.email});
}

class ForgotPasswordEmailSentSuccess extends LoginState {}

class ResetPasswordSubmittedEvent extends LoginEvent {
  final String email;
  final String newPassword;

  ResetPasswordSubmittedEvent({required this.email, required this.newPassword});
}

class ResetPasswordSuccess extends LoginState {}

// --- BLoC Logic ---
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final SigninRepository repository; 
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  LoginBloc(this.repository) : super(LoginInitial()) {
    // 1. معالجة تسجيل الدخول التقليدي (إيميل وباسورد)
    on<SubmitPasswordLoginEvent>((event, emit) async {
      emit(LoginLoading());
      try {
        await repository.loginWithEmailAndPassword(event.email, event.password);
        emit(LoginSuccess()); 
      } catch (e) {
        emit(LoginFailure(e.toString()));
      }
    });

    on<TriggerGoogleSignInEvent>((event, emit) async {
      emit(LoginLoading());
      try {
        final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

        if (googleUser == null) {
          emit(LoginFailure("تم إلغاء عملية تسجيل الدخول عبر جوجل"));
          return;
        }

        await repository.requestGoogleOtp(googleUser.email, googleUser.id);

        emit(GoogleOtpSentSuccess(googleUser.email));
      } catch (e) {
        emit(LoginFailure(e.toString()));
      }
    });



    on<VerifyOtpEvent>((event, emit) async {
      emit(LoginLoading());
      try {
        await repository.verifyOtp(event.email, event.otpCode);
        emit(LoginSuccess()); 
      } catch (e) {
        emit(LoginFailure(e.toString()));
      }
    });

 
 on<ForgotPasswordRequestedEvent>((event, emit) async {
      emit(LoginLoading());
      try {
        await repository.sendForgotPasswordEmail(event.email);
        emit(ForgotPasswordEmailSentSuccess());
      } catch (e) {
        emit(LoginFailure(e.toString()));
      }
    });
 


 on<ResetPasswordSubmittedEvent>((event, emit) async {
      emit(LoginLoading());
      try {
        await repository.resetPassword(
          email: event.email,
          newPassword: event.newPassword,
        );
        emit(ResetPasswordSuccess());
      } catch (e) {
        emit(LoginFailure(e.toString()));
      }
    });

  }

  
}




class VerifyOtpEvent extends LoginEvent {
  final String email;
  final String otpCode;
  VerifyOtpEvent({required this.email, required this.otpCode});
}







