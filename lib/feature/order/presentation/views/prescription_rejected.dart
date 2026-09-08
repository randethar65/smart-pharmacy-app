import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smart_pharmacy/core/util/app_colors.dart';

class PrescriptionRejected extends StatelessWidget {
  const PrescriptionRejected({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 56),
        Image.asset(
          "assets/images/Prescription Rejected.png",
          height: 96,
          width: 96,
        ),
        const SizedBox(height: 24),
        const Text(
          "Prescription Rejected",
          style: TextStyle(
            fontFamily: "PlusJakartaSans",
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          "Your order was cancelled and the"
          "items have been released.",
          style: TextStyle(
            fontFamily: "Inter",
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: AppColors.ink,
          ),
        ),
        const SizedBox(height: 34),
        Container(
          padding: const EdgeInsets.all(20),
          width: double.infinity,
          decoration: const BoxDecoration(
            color: AppColors.lightPink,
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  SvgPicture.asset(
                    "assets/svgs/PHARMACIST'S NOTE.svg",
                    height: 20,
                    width: 18,
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    "PHARMACIST'S NOTE",
                    style: TextStyle(
                      fontFamily: "Inter",
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: AppColors.accentText,
                    ),
                  ),
                ],
              ),
             
           
            ],
          ),
        ),
      ],
    );
  }
}
