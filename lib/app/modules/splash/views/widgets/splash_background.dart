import 'package:driver/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashBackground extends StatelessWidget {
  const SplashBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF04150E), // Deepest dark green
            Color(0xFF0C2B1D), // Rich dark primary green
            Color(0xFF081C13), // Deep forest green
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          // ── Blob 1: Top-Right Mint Glow ──────────────────────────────────────
          Positioned(
            top: -120.h,
            right: -120.w,
            child: Container(
              width: 320.r,
              height: 320.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.primary200.withValues(alpha: 0.18),
                    AppColors.primary200.withValues(alpha: 0.0),
                  ],
                ),
              ),
            )
                .animate(
                  onPlay: (controller) => controller.repeat(reverse: true),
                )
                .scale(
                  begin: const Offset(0.85, 0.85),
                  end: const Offset(1.2, 1.2),
                  duration: 5.seconds,
                  curve: Curves.easeInOut,
                )
                .move(
                  begin: const Offset(-30, -30),
                  end: const Offset(30, 30),
                  duration: 6.seconds,
                  curve: Curves.easeInOut,
                ),
          ),

          // ── Blob 2: Bottom-Left Emerald Glow ─────────────────────────────────
          Positioned(
            bottom: -150.h,
            left: -150.w,
            child: Container(
              width: 360.r,
              height: 360.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.primary.withValues(alpha: 0.22),
                    AppColors.primary.withValues(alpha: 0.0),
                  ],
                ),
              ),
            )
                .animate(
                  onPlay: (controller) => controller.repeat(reverse: true),
                )
                .scale(
                  begin: const Offset(0.9, 0.9),
                  end: const Offset(1.15, 1.15),
                  duration: 6.seconds,
                  curve: Curves.easeInOut,
                )
                .move(
                  begin: const Offset(20, 20),
                  end: const Offset(-20, -20),
                  duration: 7.seconds,
                  curve: Curves.easeInOut,
                ),
          ),

          // ── Blob 3: Center-Right Soft Breathing Glow ──────────────────────────
          Positioned(
            top: 320.h,
            right: -100.w,
            child: Container(
              width: 280.r,
              height: 280.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.primary300.withValues(alpha: 0.12),
                    AppColors.primary300.withValues(alpha: 0.0),
                  ],
                ),
              ),
            )
                .animate(
                  onPlay: (controller) => controller.repeat(reverse: true),
                )
                .scale(
                  begin: const Offset(0.8, 0.8),
                  end: const Offset(1.25, 1.25),
                  duration: 4500.ms,
                  curve: Curves.easeInOut,
                )
                .fadeIn(
                  begin: 0.4,
                  duration: 4.seconds,
                  curve: Curves.easeInOut,
                ),
          ),

          // Foreground child
          Positioned.fill(child: child),
        ],
      ),
    );
  }
}
