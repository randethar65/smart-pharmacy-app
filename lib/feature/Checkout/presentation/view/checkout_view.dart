import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_pharmacy/core/util/app_colors.dart';
import 'package:smart_pharmacy/core/widgets/button_app.dart';
import 'package:smart_pharmacy/feature/Checkout/presentation/manger/cubit/checkout_cubit.dart';
import 'package:smart_pharmacy/feature/Checkout/presentation/view/widget/delivery_details_card.dart';
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
    void snack(String msg) => ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));

    switch (state) {
      case CheckoutFailure(:final message):
        snack(message);
      case CheckoutSuccess():
        snack('Order placed successfully');
        //  Navigator.pushReplacementNamed(context, OrderSuccessView.routeName);
      case CheckoutRedirectToPayment(:final checkoutUrl):
        snack('Opening payment…');
        //  open checkoutUrl in a WebView screen, then confirm the order.
        debugPrint('Stripe URL: $checkoutUrl');
      case CheckoutNeedsPrescription():
        snack('Upload a prescription to continue');
        //  Navigator.pushNamed(context, UploadPrescriptionView.routeName);
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
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.deepTeal),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Secure Checkout',
          style: TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.deepTeal,
          ),
        ),
      ),
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
