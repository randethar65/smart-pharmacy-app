part of 'cart_cubit.dart';

@immutable
sealed class CartState {}

final class CartInitial extends CartState {}

final class CartLoading extends CartState {}

final class CartSuccess extends CartState {
  final CartModel cart;
  CartSuccess(this.cart);
}

final class CartFailure extends CartState {
  final String errMessage;
  CartFailure(this.errMessage);
}

/// An optimistic mutation was rejected by the server. Carries the rolled-back
/// [cart] so the screen keeps rendering, plus a [message] for a snackbar.
final class CartActionFailure extends CartState {
  final CartModel cart;
  final String message;
  CartActionFailure({required this.cart, required this.message});
}
