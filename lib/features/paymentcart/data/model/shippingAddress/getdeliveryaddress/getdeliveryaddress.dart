import 'package:equatable/equatable.dart';

import 'address.dart';

class Getdeliveryaddress extends Equatable {
  final int? defaultAddressId;
  final List<Address>? addresses;

  const Getdeliveryaddress({this.defaultAddressId, this.addresses});

  factory Getdeliveryaddress.fromJson(Map<String, dynamic> json) {
    return Getdeliveryaddress(
      defaultAddressId: json['default_address_id'] as int?,
      addresses: (json['addresses'] as List<dynamic>?)
          ?.map((e) => Address.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'default_address_id': defaultAddressId,
    'addresses': addresses?.map((e) => e.toJson()).toList(),
  };

  @override
  List<Object?> get props => [defaultAddressId, addresses];
}
