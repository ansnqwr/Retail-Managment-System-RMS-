abstract class SignupEvent {}

// حدث جلب المحافظات عند فتح الشاشة
class FetchCitiesEvent extends SignupEvent {}

// حدث جلب البلدات بناءً على id المحافظة المختار
class FetchTownsEvent extends SignupEvent {
  final int cityId;
  FetchTownsEvent({required this.cityId});
}

// حدث إرسال طلب إنشاء الحساب النهائي للباك آند
class SubmitSignupEvent extends SignupEvent {
  final Map<String, dynamic> signupData;
  SubmitSignupEvent(this.signupData);
}
