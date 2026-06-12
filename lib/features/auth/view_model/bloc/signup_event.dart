abstract class SignupEvent {}

class FetchGovernoratesEvent extends SignupEvent {}

class FetchCitiesEvent extends SignupEvent {
  final int governorateId;
  FetchCitiesEvent({required this.governorateId});
}

class SubmitSignupEvent extends SignupEvent {
  final Map<String, dynamic> signupData;
  SubmitSignupEvent(this.signupData);
}
