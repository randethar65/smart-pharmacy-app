import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_pharmacy/core/util/app_colors.dart';
import 'package:smart_pharmacy/core/widgets/app_header.dart';
import 'package:smart_pharmacy/core/widgets/button_app.dart';
import 'package:smart_pharmacy/core/widgets/text_form_field_app.dart';
import 'package:smart_pharmacy/feature/auth/presentation/manger/login/login_cubit.dart';
import 'package:smart_pharmacy/feature/auth/presentation/views/forget_password_view.dart';
import 'package:smart_pharmacy/feature/auth/presentation/views/register_view.dart';
import 'package:smart_pharmacy/feature/home/presentation/views/home_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});
  static const String routeName = 'LoginView';

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
    final _formKey = GlobalKey<FormState>();
    final _emailCtrl = TextEditingController();
    final _passwordCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  void _onLogin() {
    if (_formKey.currentState!.validate()) {
      // 1) ننادي ميثود الكيوبت بقيم نصية فقط
      context.read<LoginCubit>().login(
            email: _emailCtrl.text.trim(),
            password: _passwordCtrl.text,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const AppHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
            Text(
              'Welcome back',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontSize: 28,
                            fontWeight: FontWeight.w600,
                            height: 36 / 28,
                            color: AppColors.ink,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              'Log in to continue',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontFamily: 'Inter',
                    fontSize: 16,
                            fontWeight: FontWeight.w400,
                            height: 24 / 16,
                    color: AppColors.ink,
                  ),
            ),
                    const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 16,
                            offset: const Offset(0, 4),
                ),
                        ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AppTextFormField(
                      label: 'Email',
                      hint: 'you@example.com',
                      controller: _emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      validator: (v) {
                                if (v == null || v.isEmpty) {
                          return 'Please enter your email';
                                }
                                final re =
                                    RegExp(r'^[\w.\-]+@[\w\-]+\.[\w\-.]+$');
                                if (!re.hasMatch(v)) {
                          return 'Please enter a valid email address';
                                }
                        return null;
                      },
                    ),
                            const SizedBox(height: 20),
                    AppTextFormField(
                      label: 'Password',
                      hint: '••••••••',
                      controller: _passwordCtrl,
                      obscureText: true,
                      textInputAction: TextInputAction.done,
                      validator: (v) => (v == null || v.length < 8)
                          ? 'At least 8 characters'
                          : null,
                    ),
                            const SizedBox(height: 12),
                            Align(
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    ForgetPasswordView.routeName,
                                  );
                                },
                                child: const Text(
                                  'Forgot password?',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            // 2) نستمع للحالة: listener للـ side-effects، builder للزر
                            BlocConsumer<LoginCubit, LoginState>(
                              listener: (context, state) {
                                if (state is LoginSuccess) {
                                  Navigator.pushNamedAndRemoveUntil(
                                    context,
                                    HomeView.routeName,
                                    (route) => false,
                                  );
                                }
                                if (state is LoginFailure) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(state.errorMessage)),
                                  );
                                }
                              },
                              //builder بنحط جواه الـ UI اللي بدنا يتغير أو يُعاد بناؤه حسب الـ state
                              builder: (context, state) {
                                return PrimaryButton(
                                  label: 'Log in',
                                  loading: state is LoginLoading,
                                  onPressed: _onLogin,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'New here? ',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        GestureDetector(
                          //خلي كامل مساحة الـ widget قابلة لاستقبال الضغط، حتى لو كانت شفافة أو ما فيها محتوى ظاهر.
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            Navigator.pushNamed(context, RegisterView.routeName);
                          },
                          child: const Text(
                            'Create an account',
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
                     const SizedBox(height:24),
                     
                    // Add your login form widgets here
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
