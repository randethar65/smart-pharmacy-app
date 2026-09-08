import 'dart:io';

import 'package:flutter/material.dart';
import 'package:smart_pharmacy/core/util/app_colors.dart';

/// One row in the "uploaded documents" list: thumbnail, name, size,
/// and a remove button.
class DocRow extends StatelessWidget {
  const DocRow({super.key, required this.file, required this.onRemove});

  final File file;
  final VoidCallback onRemove;

  String get _name => file.path.split(Platform.pathSeparator).last;

  String get _size {
    final bytes = file.lengthSync();
    final mb = bytes / (1024 * 1024);
    return mb >= 1
        ? '${mb.toStringAsFixed(1)} MB'
        : '${(bytes / 1024).toStringAsFixed(0)} KB';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.file(
              file,
              height: 44,
              width: 44,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 44,
                width: 44,
                color: AppColors.field,
                child: const Icon(
                  Icons.description_outlined,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '$_size • Ready',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onRemove,
            icon: const Icon(Icons.close, size: 18),
            color: AppColors.textSecondary,
            splashRadius: 18,
          ),
        ],
      ),
    );
  }
}
