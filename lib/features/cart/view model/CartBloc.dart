import 'package:delni_rms/features/cart/view%20model/CartEvent.dart';
import 'package:delni_rms/features/cart/view%20model/CartRepository.dart';
import 'package:delni_rms/features/cart/view%20model/CartState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository cartRepository;

  CartBloc(this.cartRepository) : super(const CartState()) {
    on<CartStarted>(_onStarted);
    on<CartItemAdded>(_onItemAdded);
    on<CartItemQuantityChanged>(_onQuantityChanged);
    on<CartItemRemoved>(_onItemRemoved);
    on<CartCleared>(_onCleared);

    add(CartStarted());
  }

  Future<void> _onStarted(CartStarted event, Emitter<CartState> emit) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final items = await cartRepository.getCart();
      emit(state.copyWith(items: items, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onItemAdded(
    CartItemAdded event,
    Emitter<CartState> emit,
  ) async {
    try {
      final items = await cartRepository.addToCart(event.item);
      emit(
        state.copyWith(items: items, lastAddedTick: state.lastAddedTick + 1),
      );
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> _onQuantityChanged(
    CartItemQuantityChanged event,
    Emitter<CartState> emit,
  ) async {
    try {
      final items = await cartRepository.updateQuantity(
        event.item,
        event.newQuantity,
      );
      emit(state.copyWith(items: items));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> _onItemRemoved(
    CartItemRemoved event,
    Emitter<CartState> emit,
  ) async {
    try {
      final items = await cartRepository.removeFromCart(event.item);
      emit(state.copyWith(items: items));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> _onCleared(CartCleared event, Emitter<CartState> emit) async {
    try {
      await cartRepository.clearCart();
      emit(state.copyWith(items: []));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }
}
