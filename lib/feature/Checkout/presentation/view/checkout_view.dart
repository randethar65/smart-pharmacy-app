import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_pharmacy/core/util/app_colors.dart';
import 'package:smart_pharmacy/core/widgets/button_app.dart';
import 'package:smart_pharmacy/feature/Checkout/presentation/manger/checkout/checkout_cubit.dart';
import 'package:smart_pharmacy/feature/Checkout/presentation/view/card_payment_redirect_view.dart';
import 'package:smart_pharmacy/feature/Checkout/presentation/view/order_placed_success.dart';
import 'package:smart_pharmacy/feature/Checkout/presentation/view/rx_required_view.dart';
import 'package:smart_pharmacy/feature/Checkout/presentation/view/widget/delivery_details_card.dart';
import 'package:smart_pharmacy/feature/Checkout/presentation/view/widget/header.dart';
import 'package:smart_pharmacy/feature/Checkout/presentation/view/widget/order_summary_card.dart';
import 'package:smart_pharmacy/feature/Checkout/presentation/view/widget/payment_method_card.dart';
import 'package:smart_pharmacy/feature/cart/presentation/manger/cubit/cart_cubit.dart';

class CheckoutView extends StatefulWidget {
  const CheckoutView({super.key});
  static const String routName = "CheckoutView";

  @override
  State<CheckoutView> createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<CheckoutView> {
  final _form = GlobalKey<FormState>();
  final _city = TextEditingController();
  final _streetAddress = TextEditingController();
  final _phone = TextEditingController();

  PaymentMethod _payment = PaymentMethod.cash;

  @override
  void dispose() {
    _city.dispose();
    _streetAddress.dispose();
    _phone.dispose();
    super.dispose();
  }

  void _onPlaceOrder() {
    if (!_form.currentState!.validate()) return;
    context.read<CheckoutCubit>().checkout(
      paymentMethod: _payment == PaymentMethod.cash ? 'Cash' : 'Visa',
      city: _city.text,
      street: _streetAddress.text,
      phoneNumber: _phone.text,
    );
  }

  void _onCheckoutState(BuildContext context, CheckoutState state) {
    void snack(String msg) =>
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(msg)));

    final cartCubit = context.read<CartCubit>();

    switch (state) {
      case CheckoutFailure(:final message):
        snack(message);

      // Cash paid, or Visa confirmed — the order is done.
      case CheckoutSuccess(:final orderId):
        // Read the total BEFORE refreshing: the server already emptied the cart,
        // but our local copy still holds the items we just ordered.
        final cartState = cartCubit.state;
        final total = cartState is CartSuccess ? cartState.cart.total : 0.0;
        Navigator.pushReplacementNamed(
          context,
          OrderPlacedSuccess.routName,
          arguments: {'orderId': orderId, 'total': total},
        );
        cartCubit.fetchCart(); // sync the now-empty cart

      // Visa — open the Stripe redirect screen. pushNamed (not replacement) so
      // "Cancel" / "Try again" can come back to this still-alive checkout form.
      case CheckoutRedirectToPayment(:final checkoutUrl):
        // Read the total BEFORE refreshing — the server clears the cart on
        // order creation now, not just on payment.
        final cartState = cartCubit.state;
        final total = cartState is CartSuccess ? cartState.cart.total : 0.0;
        Navigator.pushNamed(
          context,
          CardPaymentRedirectView.routeName,
          arguments: {'amount': total, 'checkoutUrl': checkoutUrl},
        );
        cartCubit.fetchCart();

      // Order created but has an Rx item — upload a prescription first.
      case CheckoutNeedsPrescription(:final orderId):
        Navigator.pushReplacementNamed(
          context,
          RxRequiredView.routeName,
          arguments: {'orderId': orderId},
        );
        cartCubit.fetchCart(); // order placed — the server emptied the cart

      case CheckoutInitial():
      case CheckoutLoading():
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartState = context.watch<CartCubit>().state;
    final cart = cartState is CartSuccess ? cartState.cart : null;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const Header(title: 'Secure Checkout'),
      body: BlocConsumer<CheckoutCubit, CheckoutState>(
        listener: _onCheckoutState,
        builder: (context, state) {
          final isLoading = state is CheckoutLoading;

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            child: Column(
              children: [
                DeliveryDetailsCard(
                  form: _form,
                  city: _city,
                  streetAddress: _streetAddress,
                  phone: _phone,
                ),
                const SizedBox(height: 16),
                PaymentMethodCard(
                  selected: _payment,
                  onChanged: (p) => setState(() => _payment = p),
                ),
                const SizedBox(height: 16),
                if (cart != null) ...[
                  OrderSummaryCard(cart: cart),
                  const SizedBox(height: 16),
                ],
                PrimaryButton(
                  label: 'Place order',
                  loading: isLoading,
                  onPressed: _onPlaceOrder,
                ),
                if (_payment == PaymentMethod.cash) ...[
                  const SizedBox(height: 8),
                  const Center(
                    child: Text(
                      'You will pay upon delivery.',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
