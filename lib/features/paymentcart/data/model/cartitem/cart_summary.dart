import 'package:equatable/equatable.dart';

class CartSummary extends Equatable {
  final int? subtotal;
  final int? shippingFee;
  final int? discount;
  final int? total;
  final String? currency;

  const CartSummary({
    this.subtotal,
    this.shippingFee,
    this.discount,
    this.total,
    this.currency,
  });

  factory CartSummary.fromJson(Map<String, dynamic> json) => CartSummary(
    subtotal: json['subtotal'] as int?,
    shippingFee: json['shipping_fee'] as int?,
    discount: json['discount'] as int?,
    total: json['total'] as int?,
    currency: json['currency'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'subtotal': subtotal,
    'shipping_fee': shippingFee,
    'discount': discount,
    'total': total,
    'currency': currency,
  };

  @override
  List<Object?> get props {
    return [subtotal, shippingFee, discount, total, currency];
  }
}
