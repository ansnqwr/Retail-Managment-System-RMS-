import 'package:flutter_bloc/flutter_bloc.dart';
import '/features/onboarding/view%20model/onboarding_event.dart';
import '/features/onboarding/view%20model/onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  OnboardingBloc() : super(OnboardingState()) {
    // عند تغيير الصفحة
    on<PageChangedEvent>((event, emit) {
      emit(state.copyWith(currentPage: event.pageIndex));
    });

    // عند اختيار اللغة
    on<LanguageSelectedEvent>((event, emit) {
      emit(state.copyWith(language: event.selectedLanguage));
    });
  }
}
