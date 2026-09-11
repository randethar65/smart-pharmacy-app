import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_pharmacy/core/util/app_colors.dart';
import 'package:smart_pharmacy/core/util/session.dart';
import 'package:smart_pharmacy/feature/Checkout/presentation/view/widget/header.dart';
import 'package:smart_pharmacy/feature/order/presentation/views/order_view.dart';
import 'package:smart_pharmacy/feature/profile/presentation/manger/cubit/profile_cubit.dart';
import 'package:smart_pharmacy/feature/profile/presentation/views/widgets/language_toggle.dart';
import 'package:smart_pharmacy/feature/profile/presentation/views/widgets/my_address_widget.dart';
import 'package:smart_pharmacy/feature/profile/presentation/views/widgets/profile_menu_tile.dart';
import 'package:smart_pharmacy/feature/profile/presentation/views/widgets/profile_skeleton.dart';
import 'package:smart_pharmacy/feature/profile/presentation/views/widgets/upload_avatar_widget.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  static const routeName = "ProfileView";

  @override
  Widget build(BuildContext context) {
    onPressed() async {
  final ok = await showDialog<bool>(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('Log out?'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
        TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Log out')),
      ],
    ),
  );
  if (ok == true && context.mounted) await logout(context);
}
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const Header(title: 'Profile'),
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ProfileActionFailure) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          if (state is ProfileInitial || state is ProfileLoading) {
            return const ProfileSkeleton();
          }

          if (state is ProfileFailure) {
            return Center(
              child: TextButton(
                onPressed: () => context.read<ProfileCubit>().getMyProfile(),
                child: Text('${state.message} — Tap to retry'),
              ),
            );
          }

          final profile = state is ProfileSuccess
              ? state.profile
              : (state as ProfileActionFailure).profile;

          if (profile == null) {
            return const Center(child: Text('No profile'));
          }

          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            children: [
              const SizedBox(height: 8),
              Center(child: UploadAvatarWidget(avatarUrl: profile.avatarUrl)),
              const SizedBox(height: 12),
              Text(
                textAlign: TextAlign.center,
                profile.fullName ?? "",
                style: const TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                textAlign: TextAlign.center,
                profile.email,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  color: AppColors.ink,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 24),
              MyAddressWidget(profile: profile),
              const SizedBox(height: 8),
              ProfileMenuTile(
                icon: Icons.receipt_long_outlined,
                label: 'My Orders',
                onTap: () => Navigator.pushNamed(context, OrderView.routName),
              ),
              ProfileMenuTile(
                icon: Icons.notifications_none,
                label: 'Notifications',
                showDot: true,
                onTap: () {
                  // TODO: push NotificationsView
                },
              ),
              const ProfileMenuTile(
                icon: Icons.language,
                label: 'Language',
                trailing: LanguageToggle(),
              ),
              ProfileMenuTile(
                icon: Icons.info_outline,
                label: 'About',
                onTap: () {
                  // TODO: push AboutView
                },
              ),
              const SizedBox(height: 4),
              ProfileMenuTile(
                icon: Icons.logout,
                label: 'Log out',
                color: AppColors.error,
                onTap:onPressed,
              ),
              const SizedBox(height: 20),
              const Center(
                child: Text(
                  'v1.0.4',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
