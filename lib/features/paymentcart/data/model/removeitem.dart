import 'package:equatable/equatable.dart';

class Removeitem extends Equatable {
  final String? message;

  const Removeitem({this.message});

  factory Removeitem.fromJson(Map<String, dynamic> json) =>
      Removeitem(message: json['message'] as String?);

  Map<String, dynamic> toJson() => {'message': message};

  @override
  List<Object?> get props => [message];
}
