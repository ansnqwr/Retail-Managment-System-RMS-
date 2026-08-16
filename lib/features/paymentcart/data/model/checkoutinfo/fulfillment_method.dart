import 'package:equatable/equatable.dart';

class FulfillmentMethod extends Equatable {
  final int? id;
  final String? name;
  final int? price;
  final bool? selected;

  const FulfillmentMethod({this.id, this.name, this.price, this.selected});

  factory FulfillmentMethod.fromJson(Map<String, dynamic> json) {
    return FulfillmentMethod(
      id: json['id'] as int?,
      name: json['name'] as String?,
      price: json['price'] as int?,
      selected: json['selected'] as bool?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'price': price,
    'selected': selected,
  };

  @override
  List<Object?> get props => [id, name, price, selected];
}
