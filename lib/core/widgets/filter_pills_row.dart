// lib/core/widgets/filter_pills_row.dart
import 'package:flutter/material.dart';
import 'package:smart_pharmacy/core/widgets/filter_pills_item.dart';

class FilterPillsRow extends StatefulWidget {
  const FilterPillsRow({
    super.key,
    required this.labels,
    this.initialIndex = 0,
    this.onSelected,
  });

  final List<String> labels;
  final int initialIndex;
  final ValueChanged<int>? onSelected;

  @override
  State<FilterPillsRow> createState() => _FilterPillsRowState();
}

class _FilterPillsRowState extends State<FilterPillsRow> {
  late int _selected = widget.initialIndex;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: widget.labels.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) => FilterPillsItem(
          label: widget.labels[index],
          isSelected: index == _selected,
          onTap: () {
            setState(() => _selected = index);
            widget.onSelected?.call(index);
          },
        ),
      ),
    );
  }
}