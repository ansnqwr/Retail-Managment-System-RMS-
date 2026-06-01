abstract class SignupEvent {}

class FetchCitiesEvent extends SignupEvent {}

class FetchTownsEvent extends SignupEvent {
  final int cityId;
  FetchTownsEvent({required this.cityId});
}

class SubmitSignupEvent extends SignupEvent {
  final Map<String, dynamic> signupData;
  SubmitSignupEvent(this.signupData);
}
