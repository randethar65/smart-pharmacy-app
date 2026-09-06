import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_pharmacy/core/util/app_colors.dart';
import 'package:smart_pharmacy/core/widgets/button_app.dart';
import 'package:smart_pharmacy/feature/cart/data/models/add_to_cart_request.dart';
import 'package:smart_pharmacy/feature/cart/presentation/manger/cubit/cart_cubit.dart';
import 'package:smart_pharmacy/feature/home/data/models/prodct_detail_model.dart';

/// Sticky footer: total + Add to Cart + (for Rx items) the prescription note.
class BottomBar extends StatelessWidget {
  const BottomBar({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              PrimaryButton(
                label: 'Add to Cart',
                uriSvg: 'assets/svgs/cart.svg',
                iconWidth: 18,
                iconHeight: 18,
                onPressed: _inStock(product)
                    ? () {
                        
                        context.read<CartCubit>().addToCart(
                          AddToCartRequest(productId: product.id, quantity: 1),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Added to cart')),
                        );
                      }
                    : null,
              ),
              if (product.needsPrescription) ...[
                const SizedBox(height: 10),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 14,
                      color: AppColors.textSecondary,
                    ),
                    SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        "You'll upload a prescription after placing the order",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  bool _inStock(Product p) => p.stockQuantity > 0;
}
