import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/features/auth/data/models/Repository/signup_repository.dart';
import 'signup_event.dart';
import 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final SignupRepository repository;

  SignupBloc(this.repository) : super(SignupInitial()) {
    on<FetchCitiesEvent>((event, emit) async {
      emit(CitiesLoadingState());
      try {
        final cities = await repository.getCities();
        emit(CitiesLoadedState(cities));
      } catch (e) {
        emit(CitiesErrorState(e.toString()));
      }
    });

    on<FetchTownsEvent>((event, emit) async {
      emit(TownsLoadingState());
      try {
        final towns = await repository.getTowns(event.cityId);
        emit(TownsLoadedState(towns));
      } catch (e) {
        emit(TownsErrorState(e.toString()));
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
