import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_pharmacy/feature/home/presentation/manger/ProductDetail/product_details_cubit.dart';
import 'package:smart_pharmacy/feature/home/presentation/views/product_details.dart';

/// Route entry for product details: the router provides its
/// [ProductDetailsCubit] and kicks off the fetch; this widget turns the
/// cubit's states into UI and hands the loaded product to
/// [ProductDetailsView].
class ProductDetailsConsumer extends StatelessWidget {
  const ProductDetailsConsumer({super.key});
  static const routeName = '/product-details-consumer';

  AppBar _bareAppBar(BuildContext context) => AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
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
          return ProductDetailsView(product: state.result);
        }

        if (state is ProductDetailsFailure) {
          return Scaffold(
            appBar: _bareAppBar(context),
            body: Center(
              child: TextButton(
                onPressed: () {
                  final id =
                      ModalRoute.of(context)!.settings.arguments as int;
                  context
                      .read<ProductDetailsCubit>()
                      .fetchProductDetails(id: id);
                },
                child: Text('${state.errorMessage} — Tap to retry'),
              ),
            ),
          );
        }

        // ProductDetailsInitial / ProductDetailsLoading
        return Scaffold(
          appBar: _bareAppBar(context),
          body: const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
