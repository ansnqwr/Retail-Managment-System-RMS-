import 'package:equatable/equatable.dart';

class Updateinfouser extends Equatable {
  final String? message;
  final int? addressId;

  const Updateinfouser({this.message, this.addressId});

  factory Updateinfouser.fromJson(Map<String, dynamic> json) {
    return Updateinfouser(
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
