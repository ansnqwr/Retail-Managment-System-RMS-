import 'package:equatable/equatable.dart';

class Provider extends Equatable {
  final int? id;
  final String? name;
  final int? price;
  final String? estimatedDays;

  const Provider({this.id, this.name, this.price, this.estimatedDays});

  factory Provider.fromJson(Map<String, dynamic> json) => Provider(
    id: json['id'] as int?,
    name: json['name'] as String?,
    price: json['price'] as int?,
    estimatedDays: json['estimated_days'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'price': price,
    'estimated_days': estimatedDays,
  };

  @override
  List<Object?> get props => [id, name, price, estimatedDays];
}
