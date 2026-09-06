import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_pharmacy/feature/Checkout/presentation/view/checkout_view.dart';
import 'package:smart_pharmacy/feature/cart/data/models/cart_model.dart';
import 'package:smart_pharmacy/feature/cart/presentation/manger/cubit/cart_cubit.dart';
import 'package:smart_pharmacy/feature/cart/presentation/views/widgets/cart_item_card.dart';
import 'package:smart_pharmacy/feature/cart/presentation/views/widgets/checkout_bar.dart';
import 'package:smart_pharmacy/feature/cart/presentation/views/widgets/order_summary.dart';
import 'package:smart_pharmacy/feature/cart/presentation/views/widgets/prescription_banner.dart';
import 'package:smart_pharmacy/core/util/app_colors.dart';

/// Non-empty cart layout: scrollable list of items + summary, with a sticky
/// checkout bar pinned to the bottom.
class CartBody extends StatelessWidget {
  const CartBody({super.key, required this.cart, required this.anyRx});
  final bool anyRx;
  final CartModel cart;

  @override
  Widget build(BuildContext context) {
    final count = cart.items.length;

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
            children: [
              if (anyRx) ...[
                const PrescriptionBanner(),
                const SizedBox(height: 16),
              ],
              Text(
                'Cart ($count ${count == 1 ? 'item' : 'items'})',
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 12),
              for (final item in cart.items) ...[
                CartItemCard(
                  item: item,
                  onDelete: () => context.read<CartCubit>().removeFromCart(
                    id: item.productId,
                  ),
                  // PATCH now sets the absolute new quantity.
                  onDecrement: item.quantity > 1
                      ? () => context.read<CartCubit>().updateQuantityCart(
                            id: item.productId,
                            qty: item.quantity - 1,
                          )
                      : null,
                  onIncrement: () =>
                      context.read<CartCubit>().updateQuantityCart(
                        id: item.productId,
                        qty: item.quantity + 1,
                      ),
                ),
                const SizedBox(height: 12),
              ],
              const SizedBox(height: 8),
              OrderSummary(total: cart.total),
            ],
          ),
        ),
        CheckoutBar(total: cart.total,
        onCheckout: (){
             Navigator.pushNamed(context,CheckoutView.routName);
        },
        ),
      ],
    );
  }
}
