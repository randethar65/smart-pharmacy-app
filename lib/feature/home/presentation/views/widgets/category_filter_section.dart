import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_pharmacy/feature/home/data/models/category_model.dart';
import 'package:smart_pharmacy/feature/home/presentation/manger/category/category_cubit.dart';
import 'package:smart_pharmacy/feature/home/presentation/manger/Product/product_cubit.dart';
import 'package:smart_pharmacy/feature/home/presentation/views/widgets/categories_row.dart';
import 'package:smart_pharmacy/feature/home/presentation/views/widgets/category_pills_skeleton.dart';

/// Home's category filter row: shows a shimmer skeleton while
/// [CategoryCubit] loads, a retry button on failure, and the real
/// [CategoriesRow] (always prefixed with a local "All" pill) on success.
class CategoryFilterSection extends StatelessWidget {
  const CategoryFilterSection({super.key});

  /// Prepended locally — the backend has no "All" category of its own.
  static final _allCategory = CategoryModel(id: -1, name: 'All');

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryCubit, CategoryState>(
      builder: (context, state) {
        if (state is CategoryFailure) {
          return SizedBox(
            height: 40,
            child: Center(
              child: TextButton(
                onPressed: () => context.read<CategoryCubit>().fetchCategories(),
                child: Text('${state.errorMessage} — Tap to retry'),
              ),
            ),
          );
        }

        if (state is CategoryLoading || state is CategoryInitial) {
          return const CategoryPillsSkeleton();
        }

        final categories = [
          _allCategory,
          ...(state as CategorySucess).categories,
        ];

        return CategoriesRow(
          categories: categories,
          onSelected: (category) {
            context.read<ProductCubit>().fetchProducts(
                  categoryId: category.id == -1 ? null : category.id,
                );
          },
        );
      },
    );
  }
}
