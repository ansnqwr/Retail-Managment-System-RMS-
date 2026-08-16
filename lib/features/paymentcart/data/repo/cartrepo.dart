import 'package:dartz/dartz.dart';
import 'package:delni_rms/core1/api/api_consumer.dart';
import 'package:delni_rms/core1/api/end_points.dart';
import 'package:delni_rms/core1/errors/exception.dart';
import 'package:delni_rms/features/paymentcart/data/model/cartitem/cartitem.dart';

class CartRepo {
  final ApiConsumer api;

  CartRepo({required this.api});

  // 1. جلب بيانات السلة
  Future<Either<String, Cartitem>> getCart() async {
    try {
      print("🚀 [CartRepo] Sending request to get cart...");
      final response = await api.get(
        EndPoints.cart,
        requiresToken: true,
        requiresLocale: true,
      );
      print("✅ [CartRepo] Raw Response received: $response");

      final cartModel = Cartitem.fromJson(response);
      print(
        "🎯 [CartRepo] CartItem Model parsed successfully: cartItems count = ${cartModel.cartItems?.length}",
      );

      return Right(cartModel);
    } on ServerException catch (e) {
      print("❌ [CartRepo] ServerException: ${e.errModel.message}");
      return Left(e.errModel.message ?? "Unknown server error");
    } catch (e) {
      print("❌ [CartRepo] General Exception: $e");
      return Left(e.toString());
    }
  }

  // 2. حذف منتج من السلة
  Future<Either<String, String>> removeFromCart({required int cartId}) async {
    try {
      final response = await api.delete(
        '${EndPoints.cart}/$cartId',
        requiresToken: true,
      );
      return Right(response['message'] ?? "Product removed successfully.");
    } on ServerException catch (e) {
      return Left(e.errModel.message ?? "Unknown server error");
    } catch (e) {
      return Left(e.toString());
    }
  }

  // 3. تعديل كمية المنتج (زيادة أو نقصان)
  Future<Either<String, String>> updateQuantity({
    required int cartId,
    required int quantity,
  }) async {
    try {
      final response = await api.patch(
        '${EndPoints.cart}/$cartId',
        data: {'quantity': quantity},
        requiresToken: true,
      );
      return Right(response['message'] ?? "Quantity updated successfully.");
    } on ServerException catch (e) {
      return Left(e.errModel.message ?? "Unknown server error");
    } catch (e) {
      return Left(e.toString());
    }
  }

  // 4. تعديل عنوان الشحن
  Future<Either<String, String>> updateShippingAddress({
    required int addressId,
  }) async {
    try {
      final response = await api.put(
        '${EndPoints.cart}/shipping-address',
        data: {'address_id': addressId},
        requiresToken: true,
      );
      return Right(
        response['message'] ?? "Shipping address updated successfully.",
      );
    } on ServerException catch (e) {
      return Left(e.errModel.message ?? "Unknown server error");
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, String>> reorderProduct({
    required int productId,
    required String selectedColor,
    required String selectedSize,
    required int quantity,
  }) async {
    try {
      final response = await api.post(
        '${EndPoints.cart}/reorder',
        data: {
          'product_id': productId,
          'selected_color': selectedColor,
          'selected_size': selectedSize,
          'quantity': quantity,
        },
        requiresToken: true,
      );
      return Right(
        response['message'] ?? "Product added to cart successfully.",
      );
    } on ServerException catch (e) {
      return Left(e.errModel.message ?? "Unknown server error");
    } catch (e) {
      return Left(e.toString());
    }
  }

  // 6. تنفيذ عملية Checkout
  Future<Either<String, Map<String, dynamic>>> checkout() async {
    try {
      final response = await api.post(
        '${EndPoints.cart}/checkout',
        requiresToken: true,
      );
      return Right(response);
    } on ServerException catch (e) {
      return Left(e.errModel.message ?? "Unknown server error");
    } catch (e) {
      return Left(e.toString());
    }
  }

  // 7. جلب عناوين المستخدم
  Future<Either<String, dynamic>> getAddresses() async {
    try {
      final response = await api.get(EndPoints.addresses, requiresToken: true);
      return Right(response);
    } on ServerException catch (e) {
      return Left(e.errModel.message ?? "Unknown server error");
    } catch (e) {
      return Left(e.toString());
    }
  }
}
