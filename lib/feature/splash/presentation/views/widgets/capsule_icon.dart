import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

/// The two-tone capsule mark — no backdrop, floats directly on the splash's
/// solid deepTeal background. The rotation baked into the SVG gives it its
/// tilt; [SplashView] additionally spins this once on entry.
class CapsuleIcon extends StatelessWidget {
  const CapsuleIcon({super.key, this.size = 128});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/svgs/pharmacy_capsule_logo.svg',
      width: size,
      height: size,
    );
  }
}
