import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_pharmacy/core/util/app_colors.dart';
import 'package:smart_pharmacy/feature/cart/data/models/add_to_cart_request.dart';
import 'package:smart_pharmacy/feature/cart/presentation/manger/cubit/cart_cubit.dart';
import 'package:smart_pharmacy/feature/home/data/models/product_model.dart';

/// A single product card in the catalog grid.
///
/// Purely presentational — pass the fields straight from your product
/// model once `ProductCubit` exists; [onTap] opens product details,
/// [onAddTap] is the small "+" add-to-cart button.
class ProductItem extends StatelessWidget {
  const ProductItem({
    super.key,
    required this.product,
    this.onTap,
  
  });

 final ProductModel product;

  final VoidCallback? onTap;


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
        onTap: onTap,
      child: Container(
        // No fixed height/width — ProductsGrid is a masonry layout, so each
        // card sizes itself to its own content.
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Hero(
                        tag: 'product-image-${product.id}',
                        child: Image.network(
                          product.image ?? "",
                          height: 120,
                          width: 120,
                          // fit: BoxFit.cover,
                          loadingBuilder: (context, child, progress) {
                            if (progress == null) return child;
                            return const ColoredBox(color: AppColors.field);
                          },
                          errorBuilder: (context, error, stack) => const ColoredBox(
                            color: AppColors.field,
                            child: Icon(
                              Icons.medication_outlined,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (product.needsPrescription)
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.accent,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'Rx',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                product.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                product.description ?? "No description available",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.ink,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                  GestureDetector(
                  
                    behavior: HitTestBehavior.opaque,
                    onTap: (){
                         context.read<CartCubit>().addToCart(
                          AddToCartRequest(productId: product.id, quantity: 1),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Added to cart')),
                        );
                    },
                    child: Container(
                      height: 32,
                      width: 32,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.add,
                        size: 24,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
