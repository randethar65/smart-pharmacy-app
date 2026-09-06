part of 'checkout_cubit.dart';

@immutable
sealed class CheckoutState {}

final class CheckoutInitial extends CheckoutState {}

final class CheckoutLoading extends CheckoutState {}

/// Cash order finished, or Visa payment confirmed by the backend.
final class CheckoutSuccess extends CheckoutState {
  final int orderId;
  CheckoutSuccess(this.orderId);
}

/// Visa — open [checkoutUrl] (Stripe hosted page) to collect payment.
final class CheckoutRedirectToPayment extends CheckoutState {
  final int orderId;
  final String checkoutUrl;
  CheckoutRedirectToPayment({required this.orderId, required this.checkoutUrl});
}

/// The order contains an Rx item — a prescription must be uploaded before it
/// can be paid.
final class CheckoutNeedsPrescription extends CheckoutState {
  final int orderId;
  CheckoutNeedsPrescription(this.orderId);
}

final class CheckoutFailure extends CheckoutState {
  final String message;
  CheckoutFailure(this.message);
}
