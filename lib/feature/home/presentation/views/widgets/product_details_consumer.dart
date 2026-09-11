import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_pharmacy/core/util/app_colors.dart';
import 'package:smart_pharmacy/feature/home/data/models/product_model.dart';
import 'package:smart_pharmacy/feature/home/presentation/manger/ProductDetail/product_details_cubit.dart';
import 'package:smart_pharmacy/feature/home/presentation/views/product_details.dart';

/// Route entry for product details: the router provides its
/// [ProductDetailsCubit] and kicks off the fetch; this widget turns the
/// cubit's states into UI and hands the loaded product to
/// [ProductDetailsView].
///
/// [initial] is the tapped [ProductModel] from the catalog list — used only
/// to render the Hero image immediately while the real fetch is in flight,
/// since a Hero needs a matching widget on this route the moment the push
/// transition starts, not once the network call resolves.
class ProductDetailsConsumer extends StatelessWidget {
  const ProductDetailsConsumer({super.key, required this.initial});
  static const routeName = '/product-details-consumer';

  final ProductModel initial;

  String get _heroTag => 'product-image-${initial.id}';

  AppBar _bareAppBar(BuildContext context) => AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      );

  Widget _heroPlaceholder() => Container(
        width: double.infinity,
        height: 280,
        color: Colors.white,
        padding: const EdgeInsets.all(20),
        alignment: Alignment.center,
        child: Hero(
          tag: _heroTag,
          child: Image.network(
            initial.image ?? '',
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => const Icon(
              Icons.medication_outlined,
              size: 48,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProductDetailsCubit, ProductDetailsState>(
      listener: (context, state) {
        if (state is ProductDetailsFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage)),
          );
        }
      },
      builder: (context, state) {
        if (state is ProductDetailsSuccess) {
          return ProductDetailsView(product: state.result, heroTag: _heroTag);
        }

        if (state is ProductDetailsFailure) {
          return Scaffold(
            appBar: _bareAppBar(context),
            body: Column(
              children: [
                _heroPlaceholder(),
                Expanded(
                  child: Center(
                    child: TextButton(
                      onPressed: () => context
                          .read<ProductDetailsCubit>()
                          .fetchProductDetails(id: initial.id),
                      child: Text('${state.errorMessage} — Tap to retry'),
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        // ProductDetailsInitial / ProductDetailsLoading
        return Scaffold(
          appBar: _bareAppBar(context),
          body: Column(
            children: [
              _heroPlaceholder(),
              const Expanded(
                child: Center(child: CircularProgressIndicator()),
              ),
            ],
          ),
        );
      },
    );
  }
}
