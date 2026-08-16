import 'package:equatable/equatable.dart';

class ShippingAddress extends Equatable {
  final int? addressId;
  final String? fullAddress;

  const ShippingAddress({this.addressId, this.fullAddress});

  factory ShippingAddress.fromJson(Map<String, dynamic> json) {
    return ShippingAddress(
      addressId: json['address_id'] as int?,
      fullAddress: json['full_address'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'address_id': addressId,
    'full_address': fullAddress,
  };

  @override
  List<Object?> get props => [addressId, fullAddress];
}
