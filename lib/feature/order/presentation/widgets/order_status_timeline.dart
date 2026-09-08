import 'package:flutter/material.dart';
import 'package:smart_pharmacy/core/util/app_colors.dart';

enum OrderStepState { done, current, pending }

class OrderStep {
  const OrderStep({
    required this.title,
    required this.icon,
    required this.state,
    this.subtitle,
  });

  final String title;
  final String? subtitle;
  final IconData icon;
  final OrderStepState state;
}

/// Vertical progress timeline for a single order (Order Placed → Delivered),
/// with a red "current" node for a step that needs the user's action.
class OrderStatusTimeline extends StatelessWidget {
  const OrderStatusTimeline({super.key, required this.steps});

  final List<OrderStep> steps;

  static const _current = Color(0xFFA8372B);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < steps.length; i++)
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Rail(
                  step: steps[i],
                  isFirst: i == 0,
                  isLast: i == steps.length - 1,
                ),
                const SizedBox(width: 14),
                Expanded(child: _Label(step: steps[i], isLast: i == steps.length - 1)),
              ],
            ),
          ),
      ],
    );
  }
}

class _Rail extends StatelessWidget {
  const _Rail({required this.step, required this.isFirst, required this.isLast});

  final OrderStep step;
  final bool isFirst;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final done = step.state == OrderStepState.done;
    final current = step.state == OrderStepState.current;

    final Color nodeBg = done
        ? AppColors.deepTeal
        : current
            ? OrderStatusTimeline._current
            : AppColors.blue;
    final Color iconColor =
        done || current ? Colors.white : AppColors.textSecondary;
    final Color lineColor = done ? AppColors.deepTeal : AppColors.border;

    return SizedBox(
      width: 36,
      child: Column(
        children: [
          //الخط الاول يلي من فوق الايقونه
          Container(
            width: 2,
            height: 8,
            color: isFirst ? Colors.transparent : lineColor,
          ),

          Container(
            padding: current ? const EdgeInsets.all(3) : EdgeInsets.zero,
            decoration: current
                ? BoxDecoration(
                    shape: BoxShape.circle,
                    color: OrderStatusTimeline._current.withValues(alpha: 0.18),
                  )
                : null,
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(shape: BoxShape.circle, color: nodeBg),
              child: Icon(step.icon, size: 20, color: iconColor),
            ),
          ),
          Expanded(
            child: Container(
              width: 2,
              color: isLast ? Colors.transparent : lineColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _Label extends StatelessWidget {
  const _Label({required this.step, required this.isLast});

  final OrderStep step;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final current = step.state == OrderStepState.current;
    final pending = step.state == OrderStepState.pending;

    final titleColor = current
        ? OrderStatusTimeline._current
        : pending
            ? AppColors.textSecondary
            : AppColors.textPrimary;

    return Padding(
      padding: EdgeInsets.only(top: 6, bottom: isLast ? 0 : 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            step.title,
            style: TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: titleColor,
            ),
          ),
          if (step.subtitle != null && step.subtitle!.isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(
              step.subtitle!,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
