import 'package:driver/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class SplashBackground extends StatelessWidget {
  const SplashBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: AppColors.primaryGradient,
      ),
      child: SizedBox.expand(child: child),
    );
  }
}
