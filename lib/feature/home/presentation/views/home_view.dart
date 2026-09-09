import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smart_pharmacy/core/DI/dependency_injection.dart';
import 'package:smart_pharmacy/core/service/dio_factory.dart';
import 'package:smart_pharmacy/core/util/app_colors.dart';
import 'package:smart_pharmacy/feature/auth/domain/repos/auth_repos.dart';
import 'package:smart_pharmacy/feature/auth/presentation/views/login_view.dart';
import 'package:smart_pharmacy/feature/cart/presentation/views/cart_view.dart';
import 'package:smart_pharmacy/feature/home/data/models/category_model.dart';
import 'package:smart_pharmacy/feature/home/presentation/manger/category/category_cubit.dart';
import 'package:smart_pharmacy/feature/home/presentation/manger/Product/product_cubit.dart';
import 'package:smart_pharmacy/feature/home/presentation/views/widgets/categories_row.dart';
import 'package:smart_pharmacy/feature/home/presentation/views/widgets/nav_widget.dart';
import 'package:smart_pharmacy/feature/home/presentation/views/widgets/products_grid.dart';
import 'package:smart_pharmacy/feature/home/presentation/views/widgets/products_grid_skeleton.dart';
import 'package:smart_pharmacy/feature/home/presentation/views/widgets/search_text_form_filed.dart';
import 'package:smart_pharmacy/feature/order/presentation/views/order_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});
  static const String routeName = 'HomeView';

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  /// Prepended locally — the backend has no "All" category of its own.
  static final _allCategory = CategoryModel(id: -1, name: 'All');

  int _currentTab = 0;

  void _onTabTap(int index) {
    // Cart opens as its own screen; Home stays the active tab. Orders/Profile
    // are not built yet.
    if (index == 1) {
      Navigator.pushNamed(context, CartView.routeName);
      return;
    }
    if(index == 2){
 Navigator.pushNamed(context, OrderView.routName);
      return;
    }
    setState(() => _currentTab = index);
    if (index != 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Coming soon')),
      );
    }
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
        leading: SvgPicture.asset(
          'assets/svgs/Button.svg',
          width: 34,
          height: 44,
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
              BlocBuilder<CategoryCubit, CategoryState>(
                builder: (context, state) {
                  if (state is CategoryFailure) {
                    return SizedBox(
                      height: 40,
                      child: Center(
                        child: TextButton(
                          onPressed: () =>
                              context.read<CategoryCubit>().fetchCategories(),
                          child: Text('${state.errorMessage} — Tap to retry'),
                        ),
                      ),
                    );
                  }

                  final categories = state is CategorySucess
                      ? [_allCategory, ...state.categories]
                      : [_allCategory];

                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      CategoriesRow(
                        categories: categories,
                        onSelected: (category) {
                          context.read<ProductCubit>().fetchProducts(
                                categoryId:
                                    category.id == -1 ? null : category.id,
                              );
                        },
                      ),
                      if (state is CategoryLoading || state is CategoryInitial)
                        const Positioned(
                          right: 20,
                          child: SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                    ],
                  );
                },
              ),
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
