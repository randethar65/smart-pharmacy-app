import 'package:dartz/dartz.dart';
import 'package:smart_pharmacy/core/error/failures.dart';
import 'package:smart_pharmacy/feature/Checkout/data/models/checkout_request.dart';
import 'package:smart_pharmacy/feature/Checkout/data/models/checkout_response.dart';

abstract class CheckoutRepos {
  /// Step 1 — create the order. No payment happens here.
  Future<Either<Failure, CheckoutResponse>> checkout(
    CheckoutRequest checkoutRequest,
  );

  /// Step 2 — Cash: finalises the order. Visa: returns a Stripe `checkoutUrl`.
  Future<Either<Failure, CheckoutResponse>> payOrder(int orderId);
}
