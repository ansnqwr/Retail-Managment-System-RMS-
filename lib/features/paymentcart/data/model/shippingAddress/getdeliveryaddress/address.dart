import 'package:equatable/equatable.dart';

class Address extends Equatable {
  final int? id;
  final String? name;
  final String? phone;
  final String? address;
  final String? city;
  final String? country;
  final bool? isDefault;

  const Address({
    this.id,
    this.name,
    this.phone,
    this.address,
    this.city,
    this.country,
    this.isDefault,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
    id: json['id'] as int?,
    name: json['name'] as String?,
    phone: json['phone'] as String?,
    address: json['address'] as String?,
    city: json['city'] as String?,
    country: json['country'] as String?,
    isDefault: json['is_default'] as bool?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'phone': phone,
    'address': address,
    'city': city,
    'country': country,
    'is_default': isDefault,
  };

  @override
  List<Object?> get props {
    return [id, name, phone, address, city, country, isDefault];
  }
}
