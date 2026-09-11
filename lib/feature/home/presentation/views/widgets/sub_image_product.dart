import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:smart_pharmacy/core/util/app_colors.dart';

/// Swipeable product image gallery with page-indicator dots.
class SubimageProduct extends StatefulWidget {
  const SubimageProduct({super.key, required this.images, this.heroTag});

  final List<String> images;

  /// Applied only to the first image (the one shown on the catalog card) so
  /// there's exactly one Hero with this tag in the tree at a time.
  final String? heroTag;

  @override
  State<SubimageProduct> createState() => _SubimageProductState();
}

class _SubimageProductState extends State<SubimageProduct> {
  int _current = 0;

  static const double _height = 280;

  Widget _frame({required Widget child}) => Container(
        width: double.infinity,
        height: _height,
        color: Colors.white  ,
        padding: const EdgeInsets.all(20),
        alignment: Alignment.center,
        child: child,
      );

  Widget _image(String url, {required bool isFirst}) {
    final image = Image.network(
      url,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) => const Icon(
        Icons.medication_outlined,
        size: 48,
        color: AppColors.textSecondary,
      ),
    );
    if (!isFirst || widget.heroTag == null) return image;
    return Hero(tag: widget.heroTag!, child: image);
  }

  Widget _placeholder() => _frame(
        child: const Icon(
          Icons.medication_outlined,
          size: 48,
          color: AppColors.textSecondary,
        ),
      );

  @override
  Widget build(BuildContext context) {
    if (widget.images.isEmpty) return _placeholder();

    return Column(
      children: [
        CarouselSlider(
          items: [
            for (var i = 0; i < widget.images.length; i++)
              _frame(
                // `contain` keeps the whole box/bottle visible instead of
                // cropping it; the tinted frame hides the letterbox gaps.
                child: _image(widget.images[i], isFirst: i == 0),
              ),
          ],
          options: CarouselOptions(
            height: _height,
            viewportFraction: 1,
            enableInfiniteScroll: false,
            onPageChanged: (index, _) => setState(() => _current = index),
          ),
        ),
        if (widget.images.length > 1) ...[
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var i = 0; i < widget.images.length; i++)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: i == _current ? 18 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: i == _current ? AppColors.primary : AppColors.border,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
            ],
          ),
        ],
      ],
    );
  }
}
