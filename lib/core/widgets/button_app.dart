import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smart_pharmacy/core/util/app_colors.dart';

/// Full-width primary action button (solid fill, pill shape, white label).
///
/// - [loading] shows a spinner and blocks taps.
/// - [uriSvg] renders a leading SVG asset before the label, sized with
///   [iconWidth] / [iconHeight] and spaced from the label by [iconGap].
///   The icon is tinted with [foregroundColor] so it matches the text.
/// - [backgroundColor] / [foregroundColor] override the default teal / white,
///   e.g. for a secondary or destructive variant.
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.loading = false,
    this.uriSvg,
    this.iconWidth = 16,
    this.iconHeight = 16,
    this.iconGap = 8,
    this.backgroundColor,
    this.foregroundColor,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  final String? uriSvg;
  final double iconWidth;
  final double iconHeight;
  final double iconGap;
  final Color? backgroundColor;
  final Color? foregroundColor;

  @override
  Widget build(BuildContext context) {
    final bg = backgroundColor ?? AppColors.primary;
    final fg = foregroundColor ?? Colors.white;

    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: loading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: bg,
          foregroundColor: fg,
          disabledBackgroundColor: bg.withValues(alpha: 0.5),
          disabledForegroundColor: fg,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(26),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        child: loading
            ? SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.4,
                  valueColor: AlwaysStoppedAnimation(fg),
                ),
              )
            : uriSvg == null
                ? Text(label)
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        uriSvg!,
                        width: iconWidth,
                        height: iconHeight,
                        colorFilter: ColorFilter.mode(fg, BlendMode.srcIn),
                      ),
                      SizedBox(width: iconGap),
                      Text(label),
                    ],
                  ),
      ),
    );
  }
}
