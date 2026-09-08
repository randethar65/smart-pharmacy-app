import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_pharmacy/core/util/app_colors.dart';
import 'package:smart_pharmacy/feature/Checkout/presentation/view/widget/header.dart';
import 'package:smart_pharmacy/feature/order/presentation/manger/order_detail.dart/cubit/order_detail_cubit.dart';
import 'package:smart_pharmacy/feature/order/presentation/widgets/order_details/order_action_bar.dart';
import 'package:smart_pharmacy/feature/order/presentation/widgets/order_details/order_delivery_card.dart';
import 'package:smart_pharmacy/feature/order/presentation/widgets/order_details/order_header_card.dart';
import 'package:smart_pharmacy/feature/order/presentation/widgets/order_details/order_items_card.dart';
import 'package:smart_pharmacy/feature/order/presentation/widgets/order_details/order_payment_card.dart';
import 'package:smart_pharmacy/feature/order/presentation/widgets/order_details/order_status_card.dart';

class OrderDetailsView extends StatefulWidget {
  const OrderDetailsView({super.key, required this.idOrder});

  final int idOrder;
  static const routName = "OrderDetailsView";

  @override
  State<OrderDetailsView> createState() => _OrderDetailsViewState();
}

class _OrderDetailsViewState extends State<OrderDetailsView> {
  @override
  void initState() {
    super.initState();
    context.read<OrderDetailCubit>().fetchDetails(id: widget.idOrder);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const Header(title: 'Order Details'),
      body: BlocBuilder<OrderDetailCubit, OrderDetailState>(
        builder: (context, state) {
          if (state is OrderDetailInitial || state is OrderDetailLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is OrderDetailFailure) {
            return Center(
              child: TextButton(
                onPressed: () => context
                    .read<OrderDetailCubit>()
                    .fetchDetails(id: widget.idOrder),
                child: Text('${state.message} — Tap to retry'),
              ),
            );
          }

          final order = (state as OrderDetailSuccess).order;
          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
            child: Column(
              children: [
                OrderHeaderCard(order: order),
                OrderStatusCard(order: order),
                OrderItemsCard(order: order),
                OrderDeliveryCard(order: order),
                OrderPaymentCard(order: order),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: BlocBuilder<OrderDetailCubit, OrderDetailState>(
        builder: (context, state) => state is OrderDetailSuccess
            ? OrderActionBar(order: state.order)
            : const SizedBox.shrink(),
      ),
    );
  }
}
