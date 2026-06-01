import 'package:untitled/features/auth/presentation/SignupScreen.dart'; 

abstract class SignupState {}

class SignupInitial extends SignupState {}

class SignupLoading extends SignupState {}

class SignupSuccess extends SignupState {}

class SignupFailure extends SignupState {
  final String errorMessage;
  SignupFailure(this.errorMessage);
}

class CitiesLoadingState extends SignupState {}

class CitiesLoadedState extends SignupState {
  final List<LocationItem> cities;
  CitiesLoadedState(this.cities);
}

class CitiesErrorState extends SignupState {
  final String message;
  CitiesErrorState(this.message);
}

class TownsLoadingState extends SignupState {}

class TownsLoadedState extends SignupState {
  final List<LocationItem> towns;
  TownsLoadedState(this.towns);
}

class TownsErrorState extends SignupState {
  final String message;
  TownsErrorState(this.message);
}
