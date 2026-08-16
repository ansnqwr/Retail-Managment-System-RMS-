import 'package:equatable/equatable.dart';

class ShippingAddress extends Equatable {
  final int? id;
  final String? name;
  final String? phone;
  final String? address;
  final String? city;
  final String? country;

  const ShippingAddress({
    this.id,
    this.name,
    this.phone,
    this.address,
    this.city,
    this.country,
  });

  factory ShippingAddress.fromJson(Map<String, dynamic> json) {
    return ShippingAddress(
      id: json['id'] as int?,
      name: json['name'] as String?,
      phone: json['phone'] as String?,
      address: json['address'] as String?,
      city: json['city'] as String?,
      country: json['country'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'phone': phone,
    'address': address,
    'city': city,
    'country': country,
  };

  @override
  List<Object?> get props => [id, name, phone, address, city, country];
}
