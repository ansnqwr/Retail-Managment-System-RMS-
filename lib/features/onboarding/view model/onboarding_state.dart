class OnboardingState {
  final int currentPage;
  final String language;

  OnboardingState({this.currentPage = 0, this.language = 'English'});

  // دالة تُسهل علينا تحديث جزء معين من الحالة مع الاحتفاظ بالباقي
  OnboardingState copyWith({int? currentPage, String? language}) {
    return OnboardingState(
      currentPage: currentPage ?? this.currentPage,
      language: language ?? this.language,
    );
  }
}
