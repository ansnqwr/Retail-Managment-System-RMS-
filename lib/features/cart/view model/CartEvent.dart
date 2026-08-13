import 'package:delni_rms/features/cart/model/CartItemModel.dart';
import 'package:equatable/equatable.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

class CartStarted extends CartEvent {
  const CartStarted();
}

class CartItemAdded extends CartEvent {
  final CartItemModel item;
  const CartItemAdded(this.item);

  @override
  List<Object?> get props => [item];
}

class CartItemQuantityChanged extends CartEvent {
  final CartItemModel item;
  final int newQuantity;
  const CartItemQuantityChanged(this.item, this.newQuantity);

  @override
  List<Object?> get props => [item, newQuantity];
}

class CartItemRemoved extends CartEvent {
  final CartItemModel item;
  const CartItemRemoved(this.item);

  @override
  List<Object?> get props => [item];
}

class CartCleared extends CartEvent {
  const CartCleared();
}
