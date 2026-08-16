import 'package:equatable/equatable.dart';

import 'provider.dart';

class Getshippingaddress extends Equatable {
  final List<Provider>? providers;

  const Getshippingaddress({this.providers});

  factory Getshippingaddress.fromJson(Map<String, dynamic> json) {
    return Getshippingaddress(
      providers: (json['providers'] as List<dynamic>?)
          ?.map((e) => Provider.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'providers': providers?.map((e) => e.toJson()).toList(),
  };

  @override
  List<Object?> get props => [providers];
}
