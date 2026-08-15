import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../data/models/Repository/signin_repository.dart';

// Events
abstract class LoginEvent {}

class TriggerGoogleSignInEvent extends LoginEvent {}

class SubmitGoogleSignInDataEvent extends LoginEvent {
  final String email;
  final String googleId;
  final String firstName;
  final String lastName;
  final String phone;
  final String governorate;
  final String city;

  SubmitGoogleSignInDataEvent({
    required this.email,
    required this.googleId,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.governorate,
    required this.city,
  });
}

class ResendGoogleOtpEvent extends LoginEvent {
  final String email;
  final String googleId;
  ResendGoogleOtpEvent({required this.email, required this.googleId});
}

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

// States
abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {}

class LoginFailure extends LoginState {
  final String error;
  LoginFailure(this.error);
}

class GoogleAccountPicked extends LoginState {
  final String email;
  final String googleId;
  GoogleAccountPicked({required this.email, required this.googleId});
}

class GoogleOtpSentSuccess extends LoginState {
  final String email;
  final String googleId;
  GoogleOtpSentSuccess({required this.email, required this.googleId});
}

class ForgotPasswordEmailSentSuccess extends LoginState {}

class OtpVerifiedSuccess extends LoginState {
  final String email;
  final String otp;
  OtpVerifiedSuccess({required this.email, required this.otp});
}

class ResetPasswordSuccess extends LoginState {}

// BLoC
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
          emit(LoginFailure("log in has been canceled"));
          return;
        }
        emit(
          GoogleAccountPicked(email: googleUser.email, googleId: googleUser.id),
        );
      } catch (e) {
        emit(LoginFailure(e.toString()));
      }
    });

    on<SubmitGoogleSignInDataEvent>((event, emit) async {
      emit(LoginLoading());
      try {
        await repository.registerGoogleUser(
          email: event.email,
          googleId: event.googleId,
          firstName: event.firstName,
          lastName: event.lastName,
          phone: event.phone,
          governorate: event.governorate,
          city: event.city,
        );
        emit(
          GoogleOtpSentSuccess(email: event.email, googleId: event.googleId),
        );
      } catch (e) {
        emit(LoginFailure(e.toString()));
      }
    });

    on<ResendGoogleOtpEvent>((event, emit) async {
      emit(LoginLoading());
      try {
        await repository.requestGoogleOtp(event.email, event.googleId);
        emit(
          GoogleOtpSentSuccess(email: event.email, googleId: event.googleId),
        );
      } catch (e) {
        emit(LoginFailure(e.toString()));
      }
    });

    on<VerifyOtpEvent>((event, emit) async {
      emit(LoginLoading());
      try {
        if (event.isForgotPassword) {
          await repository.verifyForgotPassword(event.email, event.otpCode);
          emit(OtpVerifiedSuccess(email: event.email, otp: event.otpCode));
        } else {
          await repository.verifyOtp(event.email, event.otpCode);
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
