abstract class OnboardingEvent {}

class PageChangedEvent extends OnboardingEvent {
  final int pageIndex;
  PageChangedEvent(this.pageIndex);
}

class LanguageSelectedEvent extends OnboardingEvent {
  final String selectedLanguage;
  LanguageSelectedEvent(this.selectedLanguage);
}
