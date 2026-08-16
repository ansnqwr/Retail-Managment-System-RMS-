import 'package:equatable/equatable.dart';

import 'cart_item.dart';
import 'cart_summary.dart';
import 'past_order.dart';
import 'shipping_address.dart';

class Cartitem extends Equatable {
  final int? cartCount;
  final bool? isEmpty;
  final ShippingAddress? shippingAddress;
  final List<CartItem>? cartItems;
  final List<PastOrder>? pastOrders;
  final CartSummary? cartSummary;

  const Cartitem({
    this.cartCount,
    this.isEmpty,
    this.shippingAddress,
    this.cartItems,
    this.pastOrders,
    this.cartSummary,
  });

  factory Cartitem.fromJson(Map<String, dynamic> json) => Cartitem(
    cartCount: json['cart_count'] as int?,
    isEmpty: json['is_empty'] as bool?,
    shippingAddress: json['shipping_address'] == null
        ? null
        : ShippingAddress.fromJson(
            json['shipping_address'] as Map<String, dynamic>,
          ),
    cartItems: (json['cart_items'] as List<dynamic>?)
        ?.map((e) => CartItem.fromJson(e as Map<String, dynamic>))
        .toList(),
    pastOrders: (json['past_orders'] as List<dynamic>?)
        ?.map((e) => PastOrder.fromJson(e as Map<String, dynamic>))
        .toList(),
    cartSummary: json['cart_summary'] == null
        ? null
        : CartSummary.fromJson(json['cart_summary'] as Map<String, dynamic>),
  );

  Map<String, dynamic> toJson() => {
    'cart_count': cartCount,
    'is_empty': isEmpty,
    'shipping_address': shippingAddress?.toJson(),
    'cart_items': cartItems?.map((e) => e.toJson()).toList(),
    'past_orders': pastOrders?.map((e) => e.toJson()).toList(),
    'cart_summary': cartSummary?.toJson(),
  };

  @override
  List<Object?> get props {
    return [
      cartCount,
      isEmpty,
      shippingAddress,
      cartItems,
      pastOrders,
      cartSummary,
    ];
  }
}
