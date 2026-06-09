import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../data/models/Repository/signin_repository.dart';

// --- Events ---
abstract class LoginEvent {}

class TriggerGoogleSignInEvent extends LoginEvent {}

class SubmitPasswordLoginEvent extends LoginEvent {
  final String email;
  final String password;
  SubmitPasswordLoginEvent({required this.email, required this.password});
}

class ForgotPasswordRequestedEvent extends LoginEvent {
  final String email;
  ForgotPasswordRequestedEvent({required this.email});
}

class ResetPasswordSubmittedEvent extends LoginEvent {
  final String email;
  final String newPassword;
  ResetPasswordSubmittedEvent({required this.email, required this.newPassword});
}

class VerifyOtpEvent extends LoginEvent {
  final String email;
  final String otpCode;
  final bool isForgotPassword;
  VerifyOtpEvent({
    required this.email,
    required this.otpCode,
    this.isForgotPassword = false,
  });
}

// --- States ---
abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {}

class LoginFailure extends LoginState {
  final String error;
  LoginFailure(this.error);
}

class GoogleOtpSentSuccess extends LoginState {
  final String email;
  GoogleOtpSentSuccess(this.email);
}

class ForgotPasswordEmailSentSuccess extends LoginState {}

class OtpVerifiedSuccess extends LoginState {
  final String email;
  final String otp;
  OtpVerifiedSuccess({required this.email, required this.otp});
}

class ResetPasswordSuccess extends LoginState {}

// --- BLoC Logic ---
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final SigninRepository repository;
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  LoginBloc(this.repository) : super(LoginInitial()) {
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
          emit(LoginFailure("تم إلغاء تسجيل الدخول"));
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
        // التمييز في الحالة الصادرة
        if (event.isForgotPassword) {
          emit(OtpVerifiedSuccess(email: event.email, otp: event.otpCode));
        } else {
          emit(LoginSuccess());
        }
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
