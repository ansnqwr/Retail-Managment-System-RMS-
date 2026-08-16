import 'package:equatable/equatable.dart';

class Selectshippindaddress extends Equatable {
  final String? message;

  const Selectshippindaddress({this.message});

  factory Selectshippindaddress.fromJson(Map<String, dynamic> json) {
    return Selectshippindaddress(message: json['message'] as String?);
  }

  Map<String, dynamic> toJson() => {'message': message};

  @override
  List<Object?> get props => [message];
}
