import 'package:flutter/material.dart';
import 'package:smart_pharmacy/core/util/app_colors.dart';
import 'package:smart_pharmacy/feature/home/presentation/views/widgets/nav_bar_item.dart';

/// Bottom tab bar: Home / Cart / Orders / Profile.
///
/// Stateless and fully controlled by the parent — [currentIndex] says which
/// tab is highlighted, [onTap] reports taps. The parent (whoever also swaps
/// the body content, e.g. with an [IndexedStack]) owns the selection state;
/// this widget only renders it.
class NavWidget extends StatelessWidget {
  const NavWidget({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  static const _tabs = [
    (icon: 'assets/svgs/home.svg', label: 'Home'),
    (icon: 'assets/svgs/cart.svg', label: 'Cart'),
    (icon: 'assets/svgs/orders.svg', label: 'Orders'),
    (icon: 'assets/svgs/Profile.svg', label: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              for (var i = 0; i < _tabs.length; i++)
                NavBarItem(
                  svgUri: _tabs[i].icon,
                  label: _tabs[i].label,
                  isSelected: i == currentIndex,
                  onTap: () => onTap(i),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
