import 'package:equatable/equatable.dart';

class Updatequantity extends Equatable {
  final String? message;

  const Updatequantity({this.message});

  factory Updatequantity.fromJson(Map<String, dynamic> json) {
    return Updatequantity(message: json['message'] as String?);
  }

  Map<String, dynamic> toJson() => {'message': message};

  @override
  List<Object?> get props => [message];
}
