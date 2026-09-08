import 'package:flutter/material.dart';
import 'package:smart_pharmacy/core/util/date_format.dart';
import 'package:smart_pharmacy/feature/order/data/Models/order_response.dart';
import 'package:smart_pharmacy/feature/order/presentation/widgets/order_details/detail_card.dart';
import 'package:smart_pharmacy/feature/order/presentation/widgets/order_status_timeline.dart';

/// "Order Status" card — the vertical timeline, built from the order's status.
class OrderStatusCard extends StatelessWidget {
  const OrderStatusCard({super.key, required this.order});

  final OrderResponse order;

  @override
  Widget build(BuildContext context) {
    return DetailCard(
      title: 'Order Status',
      child: OrderStatusTimeline(steps: _buildSteps(order)),
    );
  }
}

List<OrderStep> _buildSteps(OrderResponse o) {
  final s = o.orderStatus;
  const shippedish = ['Shipped', 'Delivered'];
  final isPaid = s == 'Paid' || shippedish.contains(s);
  final isShipped = shippedish.contains(s);
  final isDelivered = s == 'Delivered';
  final hasRx = o.prescriptionsCount > 0 || s == 'AwaitingPrescription';

  final placed = OrderStep(
    title: 'Order Placed',
    subtitle: formatDateTime(o.orderDate),
    icon: Icons.check,
    state: OrderStepState.done,
  );

  if (s == 'Cancelled') {
    return [
      placed,
      const OrderStep(
        title: 'Order Cancelled',
        subtitle: 'This order was cancelled',
        icon: Icons.cancel_outlined,
        state: OrderStepState.current,
      ),
    ];
  }

  // For an Rx order the flow is prescription-first: the customer can't pay
  // until every prescription is approved, so that step comes before payment.
  final rxStep = OrderStep(
    title: s == 'AwaitingPrescription'
        ? (o.prescriptionsCount == 0
            ? 'Awaiting Prescription'
            : 'Prescription Under Review')
        : 'Prescription Approved',
    subtitle: s == 'AwaitingPrescription' && o.prescriptionsCount == 0
        ? 'Action required'
        : null,
    icon: Icons.description_outlined,
    state: s == 'AwaitingPrescription'
        ? OrderStepState.current
        : OrderStepState.done,
  );

  final paymentStep = OrderStep(
    title: isPaid ? 'Payment Confirmed' : 'Awaiting Payment',
    subtitle: !isPaid && s == 'Pending' ? 'Action required' : null,
    icon: isPaid ? Icons.check : Icons.schedule,
    state: isPaid
        ? OrderStepState.done
        : s == 'Pending'
            ? OrderStepState.current
            : OrderStepState.pending,
  );

  return [
    placed,
    if (hasRx) rxStep,
    paymentStep,
    OrderStep(
      title: 'Shipped',
      icon: Icons.local_shipping_outlined,
      state: isShipped ? OrderStepState.done : OrderStepState.pending,
    ),
    OrderStep(
      title: 'Delivered',
      icon: Icons.home_outlined,
      state: isDelivered ? OrderStepState.done : OrderStepState.pending,
    ),
  ];
}
