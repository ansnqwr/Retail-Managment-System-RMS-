import 'package:flutter_bloc/flutter_bloc.dart';
import '/features/auth/data/models/Repository/signup_repository.dart';
import 'signup_event.dart';
import 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final SignupRepository repository;

  SignupBloc(this.repository) : super(SignupInitial()) {
    on<FetchGovernoratesEvent>((event, emit) async {
      emit(GovernoratesLoadingState());
      try {
        final governorates = await repository.getGovernorates();
        emit(GovernoratesLoadedState(governorates));
      } catch (e) {
        emit(GovernoratesErrorState(e.toString()));
      }
    });

    on<FetchCitiesEvent>((event, emit) async {
      emit(CitiesLoadingState());
      try {
        final cities = await repository.getCities(event.governorateId);
        emit(CitiesLoadedState(cities));
      } catch (e) {
        emit(CitiesErrorState(e.toString()));
      }
    });

    on<SubmitSignupEvent>((event, emit) async {
      emit(SignupLoading());
      try {
        await repository.signup(event.signupData);
        emit(SignupSuccess());
      } catch (e) {
        emit(SignupFailure(e.toString()));
      }
    });
  }
}
