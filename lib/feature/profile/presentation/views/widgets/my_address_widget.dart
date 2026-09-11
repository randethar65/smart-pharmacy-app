import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smart_pharmacy/core/util/app_colors.dart';
import 'package:smart_pharmacy/feature/profile/data/models/my_profile_response.dart';
import 'package:smart_pharmacy/feature/profile/presentation/manger/cubit/profile_cubit.dart';
import 'package:smart_pharmacy/feature/profile/presentation/views/edit_profile_view.dart';

class MyAddressWidget extends StatelessWidget {
  const MyAddressWidget({super.key, required this.profile});
  final MyProfileResponse profile;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(16)),
        color: AppColors.infoBackground,
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 16,
              top: 16,
              right: 16,
              bottom: 12,
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  child: SvgPicture.asset(
                    "assets/svgs/locat.svg",
                    height: 15,
                    width: 12,
                  ),
                  backgroundColor: const Color.fromARGB(255, 188, 231, 228),
                ),
                const SizedBox(width: 8),
                const Text(
                  "My Address",
                  style: TextStyle(
                    fontFamily: 'Inter',
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      // نفس الـ cubit الموجود بالـ ProfileView — مش نسخة جديدة،
                      // عشان لما نرجع (pop) الشاشة تكون أصلاً محدّثة من غير ما نعمل GET تاني.
                      builder: (_) => BlocProvider.value(
                        value: context.read<ProfileCubit>(),
                        child: EditProfileView(profile: profile),
                      ),
                    ),
                  ),
                  child: SvgPicture.asset("assets/svgs/edit.svg", height: 15, width: 15)),
              ],
            ),
          ),
          
             Padding(
               padding: const EdgeInsets.only(left: 60),
               child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [ const Text(
                  "City",
                  style: TextStyle(
                    fontFamily: 'Inter',
                    color: AppColors.ink,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  profile.city ?? "",
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  "Street",
                  style: TextStyle(
                    fontFamily: 'Inter',
                    color: AppColors.ink,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  profile.street ?? "",
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  "Phone",
                  style: TextStyle(
                    fontFamily: 'Inter',
                    color: AppColors.ink,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  profile.phoneNumber ?? "",
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 16),],),
             )
            ],
          ));
        
  }
}
