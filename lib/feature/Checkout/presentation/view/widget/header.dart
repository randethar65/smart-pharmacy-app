import 'package:flutter/material.dart';
import 'package:smart_pharmacy/core/util/app_colors.dart';

class Header extends StatelessWidget implements PreferredSizeWidget {
  const Header({super.key, required this.title});
final String title;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back,
          color: AppColors.deepTeal,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        title,
        style:const TextStyle(
          fontFamily: 'PlusJakartaSans',
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.deepTeal,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}