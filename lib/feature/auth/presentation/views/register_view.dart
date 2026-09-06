import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smart_pharmacy/core/util/app_colors.dart';
import 'package:smart_pharmacy/core/widgets/button_app.dart';
import 'package:smart_pharmacy/core/widgets/text_form_field_app.dart';
import 'package:smart_pharmacy/feature/auth/presentation/manger/register/register_cubit.dart';
import 'package:smart_pharmacy/feature/auth/presentation/views/check_email_view.dart';
import 'package:smart_pharmacy/feature/auth/presentation/views/login_view.dart';
import 'package:smart_pharmacy/feature/auth/presentation/views/widget/password_checklist.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});
  static const String routeName = 'RegisterView';

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _usernameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  /// Mirrors the password field so the checklist below can react live.
  String _password = '';

  bool get _has8 => _password.length >= 8;
  bool get _hasUpper => _password.contains(RegExp(r'[A-Z]'));
  bool get _hasLower => _password.contains(RegExp(r'[a-z]'));
  bool get _hasDigit => _password.contains(RegExp(r'[0-9]'));
  // Backend accepts any non-alphanumeric character (Identity's default policy).
  bool get _hasSpecial => _password.contains(RegExp(r'[^A-Za-z0-9]'));
  bool get _passwordOk =>
      _has8 && _hasUpper && _hasLower && _hasDigit && _hasSpecial;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _usernameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  /// Palestinian mobile: Jawwal (059…) or Ooredoo (056…) — matches the backend
  /// `ValidationPatterns.PalestinianMobile` rule.
  static final RegExp _mobileRe = RegExp(r'^5[69]\d{7}$');

  /// Strips spaces/punctuation, any country code (+970/+972/00970/00972) and a
  /// leading 0, leaving the 9-digit national number (e.g. `599123456`).
  String _nationalPhone(String raw) {
    var d = raw.replaceAll(RegExp(r'\D'), '');
    if (d.startsWith('00')) d = d.substring(2);
    if (d.startsWith('970') || d.startsWith('972')) d = d.substring(3);
    if (d.startsWith('0')) d = d.substring(1);
    return d;
  }

  /// National number normalised back to +970 E.164 form for the API.
  String get _phoneE164 => '+970${_nationalPhone(_phoneCtrl.text)}';

  void _onRegister() {
    if (!_formKey.currentState!.validate()) return;

    context.read<RegisterCubit>().register(
          fullName: _nameCtrl.text.trim(),
          userName: _usernameCtrl.text.trim(),
          email: _emailCtrl.text.trim(),
          password: _passwordCtrl.text,
          phoneNumber: _phoneE164,
        );
  }

  void _goToLogin() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      Navigator.pushReplacementNamed(context, LoginView.routeName);
    }
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Create your account',
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  height: 36 / 28,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Join us to start managing your health journey.',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  height: 20 / 14,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 24),
              Form(
                key: _formKey,
                child: Column(
                  //مدّي العناصر لأقصى عرض متاح
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AppTextFormField(
                      label: 'Full name',
                      hint: 'John Doe',
                      controller: _nameCtrl,
                      textInputAction: TextInputAction.next,
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'Please enter your full name'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    AppTextFormField(
                      label: 'Username',
                      hint: 'johndoe88',
                      controller: _usernameCtrl,
                      textInputAction: TextInputAction.next,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return 'Please enter a username';
                        }
                        if (v.trim().length < 3) {
                          return 'Username must be at least 3 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    AppTextFormField(
                      label: 'Email address',
                      hint: 'john@example.com',
                      controller: _emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      validator: (v) {
                        if (v == null || v.isEmpty) {
                          return 'Please enter your email';
                        }
                        final re = RegExp(r'^[\w.\-]+@[\w\-]+\.[\w\-.]+$');
                        return re.hasMatch(v)
                            ? null
                            : 'Please enter a valid email address';
                      },
                    ),
                    const SizedBox(height: 16),
                    AppTextFormField(
                      label: 'Phone number',
                      hint: '059XXXXXXX',
                      controller: _phoneCtrl,
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      prefixIcon: const Center(
                        widthFactor: 1,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            //مفتاح الاتصال الدولي لفلسطين 🇵🇸
                            '+970',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 16,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ),
                      validator: (v) {
                        final n = _nationalPhone(v ?? '');
                        if (n.isEmpty) {
                          return 'Please enter your phone number';
                        }
                        if (!_mobileRe.hasMatch(n)) {
                          return 'Enter a valid Jawwal (059) or Ooredoo (056) number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    AppTextFormField(
                      label: 'Password',
                      hint: '••••••••',
                      controller: _passwordCtrl,
                      obscureText: true,
                      textInputAction: TextInputAction.done,
                      onChanged: (v) => setState(() => _password = v),
                      validator: (v) => _passwordOk
                          ? null
                          : 'Password does not meet the requirements',
                    ),
                    const SizedBox(height: 16),
                    PasswordChecklist(
                      rules: [
                        ('At least 8 characters', _has8),
                        ('One uppercase letter', _hasUpper),
                        ('One lowercase letter', _hasLower),
                        ('One number', _hasDigit),
                        ('One special character', _hasSpecial),
                      ],
                    ),
                    const SizedBox(height: 24),
                    BlocConsumer<RegisterCubit, RegisterState>(
                      listener: (context, state) {
                        if (state is RegisterSuccess) {
                          // Account is created but unconfirmed — take them to the
                          // "check your email" screen to confirm before logging in.
                          Navigator.pushReplacementNamed(
                            context,
                            CheckEmailView.routeName,
                          );
                        }
                        if (state is RegisterFailure) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(state.errorMessage)),
                          );
                        }
                      },
                      builder: (context, state) {
                        return PrimaryButton(
                          label: 'Create account',
                          loading: state is RegisterLoading,
                          onPressed: _onRegister,
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Already have an account? ',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  GestureDetector(
                    // Keep the whole label tappable even where it is transparent.
                    behavior: HitTestBehavior.opaque,
                    onTap: _goToLogin,
                    child: const Text(
                      'Log in',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
