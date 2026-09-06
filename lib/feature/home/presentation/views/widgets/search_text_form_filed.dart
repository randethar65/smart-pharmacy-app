import 'package:flutter/material.dart';
import 'package:smart_pharmacy/core/util/app_colors.dart';


class SearchTextFormField extends StatelessWidget {
  const SearchTextFormField({super.key, this.controller, this.onChanged});

  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: 'Search medicines & products',
        prefixIcon: const Icon(Icons.search, color: AppColors.ink),
        suffixIcon: const Icon(Icons.mic, color: AppColors.ink),
        filled: true,
        fillColor: AppColors.infoSurface,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}




