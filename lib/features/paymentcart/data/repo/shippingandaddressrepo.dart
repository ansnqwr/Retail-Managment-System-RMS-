import 'package:dartz/dartz.dart';
import 'package:delni_rms/core1/api/api_consumer.dart';
import 'package:delni_rms/core1/api/end_points.dart';
import 'package:delni_rms/core1/errors/exception.dart';

class AddressAndShippingRepo {
  final ApiConsumer api;

  AddressAndShippingRepo({required this.api});

  // 4. جلب جميع العناوين
  Future<Either<String, Map<String, dynamic>>> getAddresses() async {
    try {
      print("🚀 [AddressRepo] Sending request to get addresses...");
      final response = await api.get(
        EndPoints.addresses,
        requiresToken: true,
        requiresLocale: true,
      );
      print("✅ [AddressRepo] Raw Response received: $response");

      return Right(response);
    } on ServerException catch (e) {
      print("❌ [AddressRepo] ServerException: ${e.errModel.message}");
      return Left(e.errModel.message ?? "Unknown server error");
    } catch (e) {
      print("❌ [AddressRepo] General Exception: $e");
      return Left(e.toString());
    }
  }

  // 5. إضافة عنوان جديد
  Future<Either<String, String>> addAddress({
    required String country,
    required String firstName,
    required String lastName,
    required String streetAddress,
    String streetAddress2 = "",
    required String city,
    required String state,
    required String phone,
  }) async {
    try {
      final response = await api.post(
        EndPoints.addresses,
        data: {
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
      return Right(response['message'] ?? "Address added successfully.");
    } on ServerException catch (e) {
      return Left(e.errModel.message ?? "Unknown server error");
    } catch (e) {
      return Left(e.toString());
    }
  }

  // 6. تعديل عنوان
  Future<Either<String, String>> updateAddress({
    required int addressId,
    required String country,
    required String firstName,
    required String lastName,
    required String streetAddress,
    String streetAddress2 = "",
    required String city,
    required String state,
    required String phone,
  }) async {
    try {
      final response = await api.put(
        '${EndPoints.addresses}/$addressId',
        data: {
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
      return Right(response['message'] ?? "Address updated successfully.");
    } on ServerException catch (e) {
      return Left(e.errModel.message ?? "Unknown server error");
    } catch (e) {
      return Left(e.toString());
    }
  }

  // 7. حذف عنوان
  Future<Either<String, String>> deleteAddress({required int addressId}) async {
    try {
      final response = await api.delete(
        '${EndPoints.addresses}/$addressId',
        requiresToken: true,
      );
      return Right(response['message'] ?? "Address deleted successfully.");
    } on ServerException catch (e) {
      return Left(e.errModel.message ?? "Unknown server error");
    } catch (e) {
      return Left(e.toString());
    }
  }

  // 8. اختيار عنوان التوصيل
  Future<Either<String, String>> selectAddress({required int addressId}) async {
    try {
      final response = await api.put(
        '${EndPoints.checkout}/select-address',
        data: {"address_id": addressId},
        requiresToken: true,
      );
      return Right(response['message'] ?? "Shipping address selected.");
    } on ServerException catch (e) {
      return Left(e.errModel.message ?? "Unknown server error");
    } catch (e) {
      return Left(e.toString());
    }
  }

  // 9. جلب شركات الشحن
  Future<Either<String, Map<String, dynamic>>> getShippingProviders() async {
    try {
      final response = await api.get(
        EndPoints.shippingproviders,
        requiresToken: true,
      );
      return Right(response);
    } on ServerException catch (e) {
      return Left(e.errModel.message ?? "Unknown server error");
    } catch (e) {
      return Left(e.toString());
    }
  }

  // 10. اختيار شركة الشحن
  Future<Either<String, String>> selectShippingProvider({
    required int providerId,
  }) async {
    try {
      final response = await api.put(
        EndPoints.checkoutshippingprovider,
        data: {"provider_id": providerId},
        requiresToken: true,
      );
      return Right(response['message'] ?? "Shipping provider selected.");
    } on ServerException catch (e) {
      return Left(e.errModel.message ?? "Unknown server error");
    } catch (e) {
      return Left(e.toString());
    }
  }
}
