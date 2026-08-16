import 'package:equatable/equatable.dart';

class ErrorModel extends Equatable {
  final String? status;
  final String? message;

  ErrorModel({this.status, this.message});

  factory ErrorModel.fromJson(Map<String, dynamic> json) => ErrorModel(
    status: json['status'] as String?,
    message: json['message'] as String?,
  );

  Map<String, dynamic> toJson() => {'status': status, 'message': message};

  @override
  List<Object?> get props => [status, message];
}
