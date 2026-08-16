import 'package:equatable/equatable.dart';

class Reoder extends Equatable {
  final String? message;

  const Reoder({this.message});

  factory Reoder.fromJson(Map<String, dynamic> json) =>
      Reoder(message: json['message'] as String?);

  Map<String, dynamic> toJson() => {'message': message};

  @override
  List<Object?> get props => [message];
}
