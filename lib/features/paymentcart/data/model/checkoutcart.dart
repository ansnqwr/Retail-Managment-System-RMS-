import 'package:equatable/equatable.dart';

class Checkoutcart extends Equatable {
  final String? message;
  final int? orderId;
  final int? subtotal;
  final int? shippingFee;
  final int? discount;
  final int? total;
  final String? currency;

  const Checkoutcart({
    this.message,
    this.orderId,
    this.subtotal,
    this.shippingFee,
    this.discount,
    this.total,
    this.currency,
  });

  factory Checkoutcart.fromJson(Map<String, dynamic> json) => Checkoutcart(
    message: json['message'] as String?,
    orderId: json['order_id'] as int?,
    subtotal: json['subtotal'] as int?,
    shippingFee: json['shipping_fee'] as int?,
    discount: json['discount'] as int?,
    total: json['total'] as int?,
    currency: json['currency'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'message': message,
    'order_id': orderId,
    'subtotal': subtotal,
    'shipping_fee': shippingFee,
    'discount': discount,
    'total': total,
    'currency': currency,
  };

  @override
  List<Object?> get props {
    return [message, orderId, subtotal, shippingFee, discount, total, currency];
  }
}
