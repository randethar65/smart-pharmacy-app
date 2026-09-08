import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_pharmacy/core/util/app_colors.dart';
import 'package:smart_pharmacy/core/widgets/filter_pills_row.dart';
import 'package:smart_pharmacy/feature/Checkout/presentation/view/widget/header.dart';
import 'package:smart_pharmacy/feature/order/presentation/manger/cubit/order_cubit.dart';
import 'package:smart_pharmacy/feature/order/presentation/widgets/order_item.dart';

class OrderView extends StatefulWidget {
  const OrderView({super.key});

  static const routName = "OrderView";

  @override
  State<OrderView> createState() => _OrderViewState();
}

class _OrderViewState extends State<OrderView> {
  static const _labels = [
    'All', 'Paid', 'Pending', 'Awaiting Rx', 'Shipped', 'Cancelled',
  ];
  // Parallel to _labels; null = "All".
  static const _statuses = <String?>[
    null, 'Paid', 'Pending', 'AwaitingPrescription', 'Shipped', 'Cancelled',
  ];

  int _filter = 0;

  @override
  void initState() {
    super.initState();
    context.read<OrderCubit>().fetchUserOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const Header(title: 'My Orders'),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 8),
          FilterPillsRow(
            labels: _labels,
            initialIndex: _filter,
            onSelected: (i) => setState(() => _filter = i),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: BlocBuilder<OrderCubit, OrderState>(
              builder: (context, state) {
                if (state is OrderInitial || state is OrderLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is OrderFailure) {
                  return Center(
                    child: TextButton(
                      onPressed: () =>
                          context.read<OrderCubit>().fetchUserOrders(),
                      child: Text('${state.message} — Tap to retry'),
                    ),
                  );
                }

                final all = (state as OrderSuccess).orders;
                final status = _statuses[_filter];
                final orders = status == null
                    ? all
                    : all.where((o) => o.orderStatus == status).toList();

                if (orders.isEmpty) {
                  return const Center(
                    child: Text(
                      'No orders here yet',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () =>
                      context.read<OrderCubit>().fetchUserOrders(),
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                    itemCount: orders.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (_, i) => OrderItem(
                      order: orders[i],
                      onTap: () {
                        // TODO: Navigator.pushNamed(context,
                        //   OrderDetailsView.routeName, arguments: orders[i].id);
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
