import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pinput/pinput.dart';
import 'package:smart_pharmacy/core/util/app_colors.dart';
import 'package:smart_pharmacy/core/widgets/button_app.dart';
import 'package:smart_pharmacy/core/widgets/text_form_field_app.dart';
import 'package:smart_pharmacy/feature/auth/presentation/manger/forget_password/forget_password_cubit.dart';
import 'package:smart_pharmacy/feature/auth/presentation/views/login_view.dart';
import 'package:smart_pharmacy/feature/auth/presentation/views/widget/code_field.dart';
import 'package:smart_pharmacy/feature/auth/presentation/views/widget/error_banner.dart';
import 'package:smart_pharmacy/feature/auth/presentation/views/widget/password_checklist.dart';
import 'package:smart_pharmacy/feature/auth/presentation/views/widget/resend_row.dart';

class ResetPasswordView extends StatefulWidget {
  const ResetPasswordView({super.key});
  static const String routeName = 'ResetPasswordView';

  @override
  State<ResetPasswordView> createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends State<ResetPasswordView> {
  static const int _resendSeconds = 30;

  final _formKey = GlobalKey<FormState>();
  final _codeCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  /// Email passed in from [ForgetPasswordView] via route arguments.
  String _email = '';
  String _password = '';
  String? _errorText;

  Timer? _timer;
  int _secondsLeft = _resendSeconds;

  bool get _has8 => _password.length >= 8;
  bool get _hasUpper => _password.contains(RegExp(r'[A-Z]'));
  bool get _hasLower => _password.contains(RegExp(r'[a-z]'));
  bool get _hasDigit => _password.contains(RegExp(r'[0-9]'));
  // Backend accepts any non-alphanumeric character (Identity's default policy).
  bool get _hasSpecial => _password.contains(RegExp(r'[^A-Za-z0-9]'));
  bool get _passwordOk =>
      _has8 && _hasUpper && _hasLower && _hasDigit && _hasSpecial;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

//استقبال الـ arguments من الـ ForgetPasswordView عشان نقدر نستخدمه في الـ reset password
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is String) _email = args;
  }

  @override
  void dispose() {
    _timer?.cancel();
    _codeCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _secondsLeft = _resendSeconds);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_secondsLeft <= 1) {
        t.cancel();
        setState(() => _secondsLeft = 0);
      } else {
        setState(() => _secondsLeft--);
      }
    });
  }

  void _resend() {
    if (_secondsLeft > 0 || _email.isEmpty) return;
    _codeCtrl.clear();
    setState(() => _errorText = null);
    context.read<ForgetPasswordCubit>().requestCode(email: _email);
    _startTimer();
  }

  void _onUpdate() {
    if (_codeCtrl.text.length != 6) {
      setState(() => _errorText = 'Enter the 6-digit code.');
      return;
    }
    if (!(_formKey.currentState?.validate() ?? false)) return;

    context.read<ForgetPasswordCubit>().resetPassword(
          email: _email,
          code: _codeCtrl.text.trim(),
          newPassword: _passwordCtrl.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: SvgPicture.asset('assets/svgs/back.svg', width: 20, height: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: BlocConsumer<ForgetPasswordCubit, ForgetPasswordState>(
          listener: (context, state) {
            if (state is ResetPasswordSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
              Navigator.pushNamedAndRemoveUntil(
                context,
                LoginView.routeName,
                (route) => false,
              );
            }
            if (state is ResetPasswordFailure) {
              setState(() => _errorText = state.errorMessage);
            }
            if (state is ForgetPasswordSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('A new code has been sent.')),
              );
            }
            if (state is ForgetPasswordFailure) {
              setState(() => _errorText = state.errorMessage);
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Enter the code',
                    style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                      height: 36 / 28,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "We've sent a 6-digit verification code to your email. "
                    'Enter it below to reset your password.',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      height: 1.5,
                      fontWeight: FontWeight.w400,
                      color: AppColors.ink,
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (_errorText != null) ...[
                    ErrorBanner(
                      text: _errorText!,
                      onClose: () => setState(() => _errorText = null),
                    ),
                    const SizedBox(height: 20),
                  ],
                  const Text(
                    'Verification Code',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  CodeField(
                    controller: _codeCtrl,
                    hasError: _errorText != null,
                    onChanged: () {
                      if (_errorText != null) {
                        setState(() => _errorText = null);
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  ResendRow(secondsLeft: _secondsLeft, onResend: _resend),
                  const SizedBox(height: 24),
                  Form(
                    key: _formKey,
                    child: AppTextFormField(
                      label: 'New password',
                      hint: 'SecureP@ss',
                      controller: _passwordCtrl,
                      obscureText: true,
                      textInputAction: TextInputAction.done,
                      onChanged: (v) => setState(() => _password = v),
                      validator: (v) => _passwordOk
                          ? null
                          : 'Password does not meet the requirements',
                    ),
                  ),
                  const SizedBox(height: 16),
                  PasswordChecklist(
                    rules: [
                      ('8+ characters', _has8),
                      ('One uppercase letter', _hasUpper),
                      ('One lowercase letter', _hasLower),
                      ('One number', _hasDigit),
                      ('One special character', _hasSpecial),
                    ],
                  ),
                  const SizedBox(height: 28),
                  PrimaryButton(
                    label: 'Update password',
                    uriSvg: 'assets/svgs/Container.svg',
                    iconWidth: 16,
                    iconHeight: 16,
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.primaryTint,
                    loading: state is ResetPasswordLoading,
                    onPressed: _onUpdate,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

