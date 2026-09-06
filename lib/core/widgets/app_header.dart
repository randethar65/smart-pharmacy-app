import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smart_pharmacy/core/util/app_colors.dart';

/// Branded top bar: logo + wordmark on the left, a trailing action
/// (notifications) on the right. Drop it at the top of a screen's body
/// (it is not a [Scaffold.appBar]).
class AppHeader extends StatelessWidget {
  const AppHeader({
    super.key,
    this.title = 'Smart Pharmacy',
    this.onNotificationsTap,
  });

  final String title;
  final VoidCallback? onNotificationsTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      width: double.infinity,
      color: AppColors.background,
      padding: const EdgeInsets.symmetric(

        horizontal: 20, vertical: 8),
      child: Row(
        children: [
          SvgPicture.asset('assets/svgs/Background.svg', height: 40, width: 40),
          const SizedBox(width: 8),
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          const Spacer(),
          GestureDetector(
            onTap: onNotificationsTap,
            behavior: HitTestBehavior.opaque,
            child: SvgPicture.asset('assets/svgs/Icon.svg', height: 20, width: 16),
          ),
        ],
      ),
    );
  }
}
