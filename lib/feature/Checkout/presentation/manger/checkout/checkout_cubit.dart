import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_pharmacy/feature/Checkout/data/models/checkout_request.dart';
import 'package:smart_pharmacy/feature/Checkout/domain/repos/checkout_repos.dart';

part 'checkout_state.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  CheckoutCubit({required this.checkoutRepos}) : super(CheckoutInitial());

  final CheckoutRepos checkoutRepos;

  /// One key for the whole lifetime of this cubit (one checkout screen).
  /// Reused on retry so a double-submit can't create two orders.
  final String _idempotencyKey =
      '${DateTime.now().microsecondsSinceEpoch}-${Random().nextInt(1 << 32)}';

  Future<void> checkout({
    required String paymentMethod, // 'Cash' | 'Visa'
    String? city,
    String? street,
    String? phoneNumber,
  }) async {
    emit(CheckoutLoading());

    // Step 1 — create the order.
    final created = await checkoutRepos.checkout(
      CheckoutRequest(
        paymentMethod: paymentMethod,
        idempotencyKey: _idempotencyKey,
        city: city,
        street: street,
        phoneNumber: phoneNumber,
      ),
    );

    await created.fold(
      (failure) async => emit(CheckoutFailure(failure.message)),
      (order) async {
        if (!order.success || order.orderId == null) {
          emit(CheckoutFailure(order.errorMessage ?? 'Checkout failed'));
          return;
        }

        // Rx order — stop here, the user uploads a prescription next.
        //مش رح يدفع رح يرفع الروشيتا ويستنى موافقتها 
        if (order.requiresPrescription) {
          emit(CheckoutNeedsPrescription(order.orderId!));
          return;
        }

        // Step 2 — pay. Cash finalises server-side; Visa returns a Stripe URL.
        final paid = await checkoutRepos.payOrder(order.orderId!);
        paid.fold(
          (failure) => emit(CheckoutFailure(failure.message)),
          (result) {
            if (!result.success) {
              emit(CheckoutFailure(result.errorMessage ?? 'Payment failed'));
            } else if (result.checkoutUrl != null &&
                result.checkoutUrl!.isNotEmpty) {
              emit(CheckoutRedirectToPayment(
                orderId: order.orderId!,
                checkoutUrl: result.checkoutUrl!,
              ));
            } else {
              //ما يده يدفع visa
              emit(CheckoutSuccess(order.orderId!));
            }
          },
        );
      },
    );
  }
}
