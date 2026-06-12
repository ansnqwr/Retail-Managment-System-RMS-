import '/features/auth/view/SignupScreen.dart';

abstract class SignupState {}

class SignupInitial extends SignupState {}

class SignupLoading extends SignupState {}

class SignupSuccess extends SignupState {}

class SignupFailure extends SignupState {
  final String errorMessage;
  SignupFailure(this.errorMessage);
}

class GovernoratesLoadingState extends SignupState {}

class GovernoratesLoadedState extends SignupState {
  final List<LocationItem> governorates;
  GovernoratesLoadedState(this.governorates);
}

class GovernoratesErrorState extends SignupState {
  final String message;
  GovernoratesErrorState(this.message);
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
