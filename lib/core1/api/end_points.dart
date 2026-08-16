// core1/api/end_points.dart
class EndPoints {
  static String baseUrl = "http://192.168.43.165:8000";
  static String cart = "/cart";
  static String checkout = "/checkout";
  static String addresses = "/addresses";
  static String fulfillment = "/checkout/fulfillment";
  static String shippingproviders = "/shipping/providers";
  static String checkoutshippingprovider = "/checkout/shipping-provider";
}

class ApiKey {
  static String success = "success";
  static String error_message = "error_message";
  static String status_code = "status_code";
  static String email = "email";
  static String otp = "otp";
  static String message = "message";
  static String locale = "locale";
  static String accessToken = "access_token";
  static String refreshToken = "refresh_token";
  static String new_password = "new_password";
  static String confirm_password = "confirm_password";
  static String current_password = "current_password";
  static String new_email = "new_email";
  static String authorization = "Authorization";
  static String new_password_confirmation = "new_password_confirmation";
}
