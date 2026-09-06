import 'package:flutter/material.dart';
import 'package:smart_pharmacy/feature/home/data/models/category_model.dart';
import 'package:smart_pharmacy/feature/home/presentation/views/widgets/category_item.dart';

/// Horizontally scrollable row of category filter pills. Keeps track of
/// which one is selected and reports the selected model via [onSelected]
/// (so callers get the `id` they need to filter products by category).
class CategoriesRow extends StatefulWidget {
  const CategoriesRow({
    super.key,
    required this.categories,
  
    this.onSelected,
  });

  final List<CategoryModel> categories;
  
  final ValueChanged<CategoryModel>? onSelected;

  @override
  State<CategoriesRow> createState() => _CategoriesRowState();
}

class _CategoriesRowState extends State<CategoriesRow> {
  late int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: widget.categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final category = widget.categories[index];
          return CategoryItem(
            label: category.name,
            isSelected: index == _selectedIndex,
            onTap: () {
              setState(() => _selectedIndex = index);
              widget.onSelected?.call(category);
            },
          );
        },
      ),
    );
  }
}
