import 'package:equatable/equatable.dart';

import '../model/CartItemModel.dart';

class CartState extends Equatable {
  final List<CartItemModel> items;
  final bool isLoading;
  final String? error;

  final int lastAddedTick;

  const CartState({
    this.items = const [],
    this.isLoading = false,
    this.error,
    this.lastAddedTick = 0,
  });

  int get totalItemsCount => items.fold(0, (sum, item) => sum + item.quantity);

  double get totalPrice => items.fold(0.0, (sum, item) => sum + item.subtotal);

  CartState copyWith({
    List<CartItemModel>? items,
    bool? isLoading,
    String? error,
    int? lastAddedTick,
  }) {
    return CartState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      lastAddedTick: lastAddedTick ?? this.lastAddedTick,
    );
  }

  @override
  List<Object?> get props => [items, isLoading, error, lastAddedTick];
}
