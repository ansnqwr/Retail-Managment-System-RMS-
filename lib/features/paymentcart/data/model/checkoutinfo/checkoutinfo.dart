import 'package:equatable/equatable.dart';

import 'fulfillment_method.dart';
import 'item.dart';
import 'shipping_address.dart';
import 'user.dart';

class Checkoutinfo extends Equatable {
  final ShippingAddress? shippingAddress;
  final User? user;
  final List<Item>? items;
  final List<FulfillmentMethod>? fulfillmentMethods;

  const Checkoutinfo({
    this.shippingAddress,
    this.user,
    this.items,
    this.fulfillmentMethods,
  });

  factory Checkoutinfo.fromJson(Map<String, dynamic> json) => Checkoutinfo(
    shippingAddress: json['shipping_address'] == null
        ? null
        : ShippingAddress.fromJson(
            json['shipping_address'] as Map<String, dynamic>,
          ),
    user: json['user'] == null
        ? null
        : User.fromJson(json['user'] as Map<String, dynamic>),
    items: (json['items'] as List<dynamic>?)
        ?.map((e) => Item.fromJson(e as Map<String, dynamic>))
        .toList(),
    fulfillmentMethods: (json['fulfillment_methods'] as List<dynamic>?)
        ?.map((e) => FulfillmentMethod.fromJson(e as Map<String, dynamic>))
        .toList(),
  );

  Map<String, dynamic> toJson() => {
    'shipping_address': shippingAddress?.toJson(),
    'user': user?.toJson(),
    'items': items?.map((e) => e.toJson()).toList(),
    'fulfillment_methods': fulfillmentMethods?.map((e) => e.toJson()).toList(),
  };

  @override
  List<Object?> get props {
    return [shippingAddress, user, items, fulfillmentMethods];
  }
}
