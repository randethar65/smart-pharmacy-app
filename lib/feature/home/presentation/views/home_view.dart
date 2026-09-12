import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smart_pharmacy/core/DI/dependency_injection.dart';
import 'package:smart_pharmacy/core/service/dio_factory.dart';
import 'package:smart_pharmacy/core/util/app_colors.dart';
import 'package:smart_pharmacy/feature/Notification/presentation/manger/cubit/notification_cubit.dart';
import 'package:smart_pharmacy/feature/Notification/presentation/views/notification_view.dart';
import 'package:smart_pharmacy/feature/auth/domain/repos/auth_repos.dart';
import 'package:smart_pharmacy/feature/auth/presentation/views/login_view.dart';
import 'package:smart_pharmacy/feature/cart/presentation/views/cart_view.dart';

import 'package:smart_pharmacy/feature/home/presentation/manger/Product/product_cubit.dart';
import 'package:smart_pharmacy/feature/home/presentation/views/widgets/category_filter_section.dart';
import 'package:smart_pharmacy/feature/home/presentation/views/widgets/nav_widget.dart';
import 'package:smart_pharmacy/feature/home/presentation/views/widgets/products_grid.dart';
import 'package:smart_pharmacy/feature/home/presentation/views/widgets/products_grid_skeleton.dart';
import 'package:smart_pharmacy/feature/home/presentation/views/widgets/search_text_form_filed.dart';
import 'package:smart_pharmacy/feature/order/presentation/views/order_view.dart';
import 'package:smart_pharmacy/feature/profile/presentation/views/profile_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});
  static const String routeName = 'HomeView';

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _currentTab = 0;

  void _onTabTap(int index) {
    // Cart opens as its own screen; Home stays the active tab. Orders/Profile
    // are not built yet.
    if (index == 1) {
      Navigator.pushNamed(context, CartView.routeName);
      return;
    }
    if (index == 2) {
      Navigator.pushNamed(context, OrderView.routName);
      return;
    }
    if (index == 3) {
      Navigator.pushNamed(context, ProfileView.routeName);
      return;
    }
    setState(() => _currentTab = index);
  }

  Future<void> _logout(BuildContext context) async {
    // Best-effort server-side revoke — don't block leaving on the network call.
    unawaited(getIt<AuthRepo>().logout());
    await DioFactory.clearLocalSession();
    if (context.mounted) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        LoginView.routeName,
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'SmartPharmacy',
          style: TextStyle(
            fontFamily: 'PlusJakartaSans',
            color: AppColors.deepTeal,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: Center(
          // بدون Center، AppBar.leading بيفرض عرض 56px على الـ Badge، فنقطة
          // الإشعار (Positioned) بتتموضع نسبة لهالـ 56px مش نسبة للأيقونة
          // الفعلية (16px) — فبتطلع بعيدة عنها.
          child: ValueListenableBuilder<int>(
            valueListenable: context.read<NotificationCubit>().unreadCount,
            builder: (context, count, _) {
              return GestureDetector(
                onTap: () =>
                    Navigator.pushNamed(context, NotificationView.routName),
                // isLabelVisible يتحكم بالنقطة بس — الجرس (child) يضل ظاهر
                // دايمًا، بعكس تغليف الـ Badge كلها بـ Visibility.
                child: Badge(
                  isLabelVisible: count > 0,
                  smallSize: 8,
                  largeSize: 10,
                  
                  backgroundColor: AppColors.badgeColor,
                  child: SvgPicture.asset(
                    'assets/svgs/notef.svg',
                    width: 16,
                    height: 20,
                  ),
                ),
              );
            },
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: AppColors.deepTeal),
            tooltip: 'Log out',
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: SearchTextFormField(),
              ),
              const CategoryFilterSection(),
              BlocConsumer<ProductCubit, ProductState>(
                listener: (context, state) {
                  if (state is ProductFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.errorMessage)),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is ProductLoading || state is ProductInitial) {
                    return const ProductsGridSkeleton();
                  }

                  if (state is ProductFailure) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: Center(
                        child: TextButton(
                          onPressed: () =>
                              context.read<ProductCubit>().fetchProducts(),
                          child: const Text('Couldn\'t load products — Tap to retry'),
                        ),
                      ),
                    );
                  }

                  final products = (state as ProductSuccess).result.products;

                  if (products.isEmpty) {
                    return const SizedBox(
                      height: 300,
                      child: Center(
                        child: Text(
                          'No products in this category',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    );
                  }

                  return ProductsGrid(items: products);
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: NavWidget(
        currentIndex: _currentTab,
        onTap: _onTabTap,
      ),
    );
  }
}
