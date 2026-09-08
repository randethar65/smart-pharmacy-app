import 'package:flutter/material.dart';
import 'package:smart_pharmacy/core/DI/dependency_injection.dart';
import 'package:smart_pharmacy/core/util/app_colors.dart';
import 'package:smart_pharmacy/feature/Checkout/domain/repos/checkout_repos.dart';
import 'package:smart_pharmacy/feature/Checkout/presentation/view/payment_cancelled_view.dart';
import 'package:smart_pharmacy/feature/Checkout/presentation/view/payment_success_view.dart';
import 'package:smart_pharmacy/feature/Checkout/presentation/view/stripe_checkout_view.dart';

/// Shown when a Visa order needs payment — the user taps "Pay", the Stripe
/// hosted page opens in a WebView, and the result routes to success / cancelled.
class CardPaymentRedirectView extends StatefulWidget {
  const CardPaymentRedirectView({
    super.key,
    required this.amount,
    required this.checkoutUrl,
  });

  static const routeName = "CardPaymentRedirectView";

  final double amount;
  final String checkoutUrl;

  @override
  State<CardPaymentRedirectView> createState() =>
      _CardPaymentRedirectViewState();
}

class _CardPaymentRedirectViewState extends State<CardPaymentRedirectView> {
  bool _verifying = false;

  Future<void> _startPayment() async {
    
    final result = await Navigator.push<StripeCheckoutResult>(
      context,
      MaterialPageRoute(
        builder: (_) => StripeCheckoutView(checkoutUrl: widget.checkoutUrl),
      ),
    );
    if (!mounted || result == null) return;

    if (result.cancelled) {
      Navigator.pushReplacementNamed(context, PaymentCancelledView.routeName);
      return;
    }

    // Stripe redirected to "success" — verify it with our backend.
    setState(() => _verifying = true);
    final confirmed =
        await getIt<CheckoutRepos>().confirmPayment(result.sessionId ?? '');
    if (!mounted) return;
    setState(() => _verifying = false);

    confirmed.fold(
      (failure) {
        _snack(failure.message);
        Navigator.pushReplacementNamed(context, PaymentCancelledView.routeName);
      },
      (res) {
        if (res.success) {
          Navigator.pushReplacementNamed(context, PaymentSuccessView.routeName);
        } else {
          _snack(res.errorMessage ?? 'Payment was not completed.');
          Navigator.pushReplacementNamed(
            context,
            PaymentCancelledView.routeName,
          );
        }
      },
    );
  }

  void _snack(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 32),
                Image.asset(
                  'assets/images/Illustration Area.png',
                  height: 128,
                  width: 128,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Secure Checkout',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "You'll be redirected to a secure Stripe checkout page to "
                  'complete payment.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 16,
                    height: 1.5,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 48),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _verifying ? null : _startPayment,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.deepTeal,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(26),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Pay \$${widget.amount.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward, size: 18),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.textSecondary,
                  ),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.verified_user_outlined,
                      size: 14,
                      color: AppColors.textSecondary.withValues(alpha: 0.7),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '256-bit Encryption',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textSecondary.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (_verifying)
            Container(
              color: Colors.black.withValues(alpha: 0.15),
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}
