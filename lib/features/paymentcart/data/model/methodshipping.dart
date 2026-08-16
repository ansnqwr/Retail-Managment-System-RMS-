import 'package:equatable/equatable.dart';

class Methodshipping extends Equatable {
  final String? message;

  const Methodshipping({this.message});

  factory Methodshipping.fromJson(Map<String, dynamic> json) {
    return Methodshipping(message: json['message'] as String?);
  }

  Map<String, dynamic> toJson() => {'message': message};

  @override
  List<Object?> get props => [message];
}
