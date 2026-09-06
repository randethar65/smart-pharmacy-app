import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_pharmacy/core/util/app_colors.dart';
import 'package:smart_pharmacy/feature/cart/presentation/manger/cubit/cart_cubit.dart';
import 'package:smart_pharmacy/feature/cart/presentation/views/widgets/cart_body.dart';
import 'package:smart_pharmacy/feature/cart/presentation/views/widgets/empty_cart.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});
  static const routeName = '/cart';

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  @override
  void initState() {
    super.initState();
    context.read<CartCubit>().fetchCart();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Cart')),
      body: BlocConsumer<CartCubit, CartState>(
        listener: (context, state) {
          if (state is CartActionFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is CartInitial || state is CartLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is CartFailure) {
            return Center(
              child: TextButton(
                onPressed: () => context.read<CartCubit>().fetchCart(),
                child: Text('${state.errMessage} — Tap to retry'),
              ),
            );
          }

          // CartSuccess or CartActionFailure (rolled back) — both carry a cart.
          final cart = state is CartSuccess
              ? state.cart
              : (state as CartActionFailure).cart;

          return cart.isEmpty
              ? const EmptyCart()
              : CartBody(cart: cart, anyRx: cart.anyRx);
        },
      ),
    );
  }
}
