import 'package:equatable/equatable.dart';

class Deletedeleiveryaddress extends Equatable {
  final String? message;

  const Deletedeleiveryaddress({this.message});

  factory Deletedeleiveryaddress.fromJson(Map<String, dynamic> json) {
    return Deletedeleiveryaddress(message: json['message'] as String?);
  }

  Map<String, dynamic> toJson() => {'message': message};

  @override
  List<Object?> get props => [message];
}
