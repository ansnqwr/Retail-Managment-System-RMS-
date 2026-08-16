import 'package:equatable/equatable.dart';

class Adddeleiveryaddress extends Equatable {
  final String? message;
  final int? addressId;

  const Adddeleiveryaddress({this.message, this.addressId});

  factory Adddeleiveryaddress.fromJson(Map<String, dynamic> json) {
    return Adddeleiveryaddress(
      message: json['message'] as String?,
      addressId: json['address_id'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
    'message': message,
    'address_id': addressId,
  };

  @override
  List<Object?> get props => [message, addressId];
}
