import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Shimmering placeholder shaped like [ProfileView]'s loaded content —
/// avatar, name, email, address card and menu rows — shown while
/// [ProfileCubit] is loading.
class ProfileSkeleton extends StatelessWidget {
  const ProfileSkeleton({super.key});

  Widget _bar({required double width, required double height}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _menuRow() => Row(
        children: [
          CircleAvatar(radius: 20, backgroundColor: Colors.grey.shade300),
          const SizedBox(width: 14),
          Expanded(child: _bar(width: double.infinity, height: 14)),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      period: const Duration(milliseconds: 1200),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        physics: const NeverScrollableScrollPhysics(),
        children: [
          const SizedBox(height: 8),
          Center(
            child:
                CircleAvatar(radius: 60, backgroundColor: Colors.grey.shade300),
          ),
          const SizedBox(height: 16),
          Center(child: _bar(width: 120, height: 16)),
          const SizedBox(height: 8),
          Center(child: _bar(width: 160, height: 12)),
          const SizedBox(height: 24),
          Container(
            height: 150,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          const SizedBox(height: 20),
          for (var i = 0; i < 5; i++) ...[
            _menuRow(),
            const SizedBox(height: 18),
          ],
        ],
      ),
    );
  }
}
