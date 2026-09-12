import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:smart_pharmacy/core/Helper/shared_pref_keys.dart';
import 'package:smart_pharmacy/core/Helper/sheard_pref_healper.dart';
import 'package:smart_pharmacy/core/util/app_colors.dart';
import 'package:smart_pharmacy/feature/auth/presentation/views/login_view.dart';
import 'package:smart_pharmacy/feature/home/presentation/views/home_view.dart';
import 'package:smart_pharmacy/feature/splash/presentation/views/widgets/capsule_icon.dart';

/// First screen on launch — checks the saved auth token while a short brand
/// animation plays, then replaces itself with Home or Login.
class SplashView extends StatefulWidget {
  const SplashView({super.key});
  static const routeName = 'SplashView';

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView>
    with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..forward();
  late final _fade = CurvedAnimation(
    parent: _controller,
    curve: const Interval(0, 0.5, curve: Curves.easeOut),
  );
  // One full tumble (2π lands back at the SVG's own tilt) as the capsule
  // enters, like a pill flipping into place.
  late final _spin = Tween<double>(begin: 0, end: 2 * math.pi).animate(
    CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
  );

  @override
  void initState() {
    super.initState();
    _goNext();
  }

  Future<void> _goNext() async {
    final token = await SharedPrefHelper.getSecuredString(
      SharedPrefKeys.userToken,
    );
    // Keep the brand moment on screen for a beat even if the token check
    // resolves instantly.
    await Future.delayed(const Duration(milliseconds: 1400));
    if (!mounted) return;
    Navigator.pushReplacementNamed(
      context,
      token.isNotEmpty ? HomeView.routeName : LoginView.routeName,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.deepTeal,
      body: Center(
        child: FadeTransition(
          opacity: _fade,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedBuilder(
                animation: _spin,
                child: const CapsuleIcon(),
                builder: (context, child) =>
                    Transform.rotate(angle: _spin.value, child: child),
              ),
              const SizedBox(height: 24),
              const Text(
                'SmartPharmacy',
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Your pharmacy, delivered.',
                style: TextStyle(
                  fontFamily: 'Inter',
                  color: Colors.white.withValues(alpha: 0.85),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
