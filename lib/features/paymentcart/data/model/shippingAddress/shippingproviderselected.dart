import 'package:equatable/equatable.dart';

class Shippingproviderselected extends Equatable {
  final String? message;

  const Shippingproviderselected({this.message});

  factory Shippingproviderselected.fromJson(Map<String, dynamic> json) {
    return Shippingproviderselected(message: json['message'] as String?);
  }

  Map<String, dynamic> toJson() => {'message': message};

  @override
  List<Object?> get props => [message];
}
