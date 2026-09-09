part of 'order_detail_cubit.dart';

@immutable
sealed class OrderDetailState {}

final class OrderDetailInitial extends OrderDetailState {}

final class OrderDetailLoading extends OrderDetailState {}

final class OrderDetailSuccess extends OrderDetailState {
  final OrderResponse order;
  OrderDetailSuccess(this.order);
}

/// Visa "Pay" — open the Stripe hosted page at [checkoutUrl].
final class OrderDetailPayRedirect extends OrderDetailState {
  final double amount;
  final String checkoutUrl;
  OrderDetailPayRedirect({required this.amount, required this.checkoutUrl});
}

final class OrderDetailFailure extends OrderDetailState {
  final String message;
  OrderDetailFailure(this.message);
}



