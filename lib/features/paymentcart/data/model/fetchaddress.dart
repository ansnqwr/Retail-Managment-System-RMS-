import 'package:equatable/equatable.dart';

class Fetchaddress extends Equatable {
  final dynamic defaultAddressId;
  final List<dynamic>? addresses;

  const Fetchaddress({this.defaultAddressId, this.addresses});

  factory Fetchaddress.fromJson(Map<String, dynamic> json) => Fetchaddress(
    defaultAddressId: json['default_address_id'] as dynamic,
    addresses: json['addresses'] as List<dynamic>?,
  );

  Map<String, dynamic> toJson() => {
    'default_address_id': defaultAddressId,
    'addresses': addresses,
  };

  @override
  List<Object?> get props => [defaultAddressId, addresses];
}
