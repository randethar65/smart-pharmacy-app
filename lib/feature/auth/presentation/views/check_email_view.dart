import 'package:flutter/material.dart';
import 'package:smart_pharmacy/core/util/app_colors.dart';
import 'package:smart_pharmacy/core/util/mail_launcher.dart';
import 'package:smart_pharmacy/core/widgets/button_app.dart';
import 'package:smart_pharmacy/feature/auth/presentation/views/login_view.dart';

class CheckEmailView extends StatelessWidget {
  const CheckEmailView({super.key});
  static const String routeName = 'CheckEmailView';

  Future<void> _openMail(BuildContext context) async {
    final opened = await openMailApp();
    if (!opened && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No email app found on this device')),
      );
    }
  }

  void _backToLogin(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      LoginView.routeName,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
           
            children: [
              const SizedBox(height: 20),
              Center(
                child: Image.asset(
                  'assets/images/Illustration Area_margin.png',
                 height: 216,
                  width: 192,
                ),
              ),
              const Text(
                'Check your email',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'We sent a confirmation link to your email. '
                'Please check your inbox to continue.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  height: 1.5,
                  fontWeight: FontWeight.w400,
                  color: AppColors.ink,
                ),
              ),
              const SizedBox(height: 40),
              PrimaryButton(
                label: 'Open email app',
                uriSvg: 'assets/svgs/email.svg',
                onPressed: () => _openMail(context),
              ),
              const SizedBox(height: 16),
              PrimaryButton(
                label: 'Back to login',
                backgroundColor: AppColors.surface,
                foregroundColor: AppColors.primary,
                onPressed: () => _backToLogin(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
