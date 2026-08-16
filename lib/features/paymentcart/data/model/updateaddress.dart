import 'package:equatable/equatable.dart';

class Updateaddress extends Equatable {
  final String? message;

  const Updateaddress({this.message});

  factory Updateaddress.fromJson(Map<String, dynamic> json) =>
      Updateaddress(message: json['message'] as String?);

  Map<String, dynamic> toJson() => {'message': message};

  @override
  List<Object?> get props => [message];
}
