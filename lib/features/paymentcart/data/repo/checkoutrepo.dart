import 'package:dartz/dartz.dart';
import 'package:delni_rms/core1/api/api_consumer.dart';
import 'package:delni_rms/core1/api/end_points.dart';
import 'package:delni_rms/core1/errors/exception.dart';

class CheckoutRepo {
  final ApiConsumer api;

  CheckoutRepo({required this.api});

  // 1. جلب بيانات صفحة Checkout
  Future<Either<String, Map<String, dynamic>>> getCheckoutData() async {
    try {
      print("🚀 [CheckoutRepo] Sending request to get checkout data...");
      final response = await api.get(
        EndPoints.checkout,
        requiresToken: true,
        requiresLocale: true,
      );
      print("✅ [CheckoutRepo] Checkout Data received: $response");

      return Right(response);
    } on ServerException catch (e) {
      print("❌ [CheckoutRepo] ServerException: ${e.errModel.message}");
      return Left(e.errModel.message ?? "Unknown server error");
    } catch (e) {
      print("❌ [CheckoutRepo] General Exception: $e");
      return Left(e.toString());
    }
  }

  // 2. تعديل بيانات المستخدم أو العنوان في صفحة Checkout
  Future<Either<String, String>> saveUserAddress({
    required String accessToken,
    required String country,
    required String firstName,
    required String lastName,
    required String streetAddress,
    required String streetAddress2,
    required String city,
    required String state,
    required String phone,
  }) async {
    try {
      print("🚀 [CheckoutRepo] Saving user address...");

      final response = await api.post(
        EndPoints.addresses,
        data: {
          "access_token": accessToken,
          "country": country,
          "first_name": firstName,
          "last_name": lastName,
          "street_address": streetAddress,
          "street_address2": streetAddress2,
          "city": city,
          "state": state,
          "phone": phone,
        },
        requiresToken: true,
      );

      print("✅ [CheckoutRepo] Address saved successfully: $response");

      return Right(response['message'] ?? "Address saved successfully.");
    } on ServerException catch (e) {
      print("❌ [CheckoutRepo] ServerException: ${e.errModel.message}");
      return Left(e.errModel.message ?? "Unknown server error");
    } catch (e) {
      print("❌ [CheckoutRepo] General Exception: $e");
      return Left(e.toString());
    }
  }

  // 3. تحديث طريقة التوصيل (Fulfillment Method)
  Future<Either<String, String>> updateFulfillmentMethod({
    required String accessToken,
    required int fulfillmentMethodId,
  }) async {
    try {
      print("🚀 [CheckoutRepo] Updating fulfillment method...");

      final response = await api.put(
        EndPoints.fulfillment,
        data: {
          "access_token": accessToken,
          "fulfillment_method_id": fulfillmentMethodId,
        },
        requiresToken: true,
      );

      print(
        "✅ [CheckoutRepo] Fulfillment method updated successfully: $response",
      );

      return Right(
        response['message'] ?? "Fulfillment method updated successfully.",
      );
    } on ServerException catch (e) {
      print("❌ [CheckoutRepo] ServerException: ${e.errModel.message}");
      return Left(e.errModel.message ?? "Unknown server error");
    } catch (e) {
      print("❌ [CheckoutRepo] General Exception: $e");
      return Left(e.toString());
    }
  }
}
