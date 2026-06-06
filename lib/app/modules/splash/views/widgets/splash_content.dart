import 'package:driver/core/constants/app_assets.dart';
import 'package:driver/core/constants/app_strings.dart';
import 'package:driver/core/theme/app_text_styles.dart';
import 'package:driver/core/widgets/app_brand_mark.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashContent extends StatelessWidget {
  const SplashContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // ── App Logo with Expanding Ripple Rings and Looping Breathe ────────
          Stack(
            alignment: Alignment.center,
            children: [
              // Ripple Ring 1 (Fades out and scales up)
              Container(
                width: 112.r,
                height: 112.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.12),
                    width: 1.5,
                  ),
                ),
              )
                  .animate()
                  .scale(
                    begin: const Offset(0.9, 0.9),
                    end: const Offset(1.35, 1.35),
                    duration: 1600.ms,
                    curve: Curves.easeOutCubic,
                  )
                  .fadeOut(duration: 1600.ms),

              // Ripple Ring 2 (Slightly delayed, expands further)
              Container(
                width: 112.r,
                height: 112.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.08),
                    width: 1.5,
                  ),
                ),
              )
                  .animate(delay: 250.ms)
                  .scale(
                    begin: const Offset(0.9, 0.9),
                    end: const Offset(1.5, 1.5),
                    duration: 1800.ms,
                    curve: Curves.easeOutCubic,
                  )
                  .fadeOut(duration: 1800.ms),

              // Central Brand Logo
              const AppBrandMark(
                size: 112,
                assetPath: AppAssets.appLogo,
              )
                  .animate()
                  .fadeIn(duration: 500.ms)
                  .scale(
                    begin: const Offset(0.0, 0.0),
                    end: const Offset(1.0, 1.0),
                    duration: 800.ms,
                    curve: Curves.easeOutBack,
                  )
                  .then()
                  .animate(
                      onPlay: (controller) => controller.repeat(reverse: true),
                  )
                  .scale(
                    begin: const Offset(1.0, 1.0),
                    end: const Offset(1.06, 1.06),
                    duration: 2.seconds,
                    curve: Curves.easeInOut,
                  )
                  .shake(
                    hz: 0.25,
                    rotation: 0.03,
                    duration: 4.seconds,
                    curve: Curves.easeInOut,
                  ),
            ],
          ),
          SizedBox(height: 28.h),

          // ── App Title with Slide-Up entrance ────────────────────────────────
          Text(
            AppStrings.appTitle,
            style: AppTextStyles.h1(color: Colors.white).copyWith(
              fontSize: 26.sp,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
            ),
            textAlign: TextAlign.center,
          )
              .animate(delay: 250.ms)
              .fadeIn(duration: 600.ms)
              .slideY(begin: 0.2, end: 0, curve: Curves.easeOutBack),
          SizedBox(height: 10.h),

          // ── Delivery Subtitle with Slide-Up ──────────────────────────────────
          Text(
            AppStrings.deliverySystem,
            style:
                AppTextStyles.body(color: Colors.white.withValues(alpha: 0.7)),
            textAlign: TextAlign.center,
          )
              .animate(delay: 450.ms)
              .fadeIn(duration: 600.ms)
              .slideY(begin: 0.2, end: 0, curve: Curves.easeOutBack),
          SizedBox(height: 64.h),

          // ── Premium Linear Custom Glowing Progress Bar ────────────────────────
          Container(
            width: 140.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withValues(alpha: 0.6),
                            blurRadius: 8,
                            spreadRadius: 1.5,
                          ),
                        ],
                      ),
                    ).animate().custom(
                          duration: 2500.ms,
                          curve: Curves.easeInOutCubic,
                          builder: (context, value, child) {
                            return FractionallySizedBox(
                              widthFactor: value,
                              child: child,
                            );
                          },
                        ),
                  ),
                ),
              ],
            ),
          ).animate(delay: 500.ms).fadeIn(duration: 400.ms),
        ],
      ),
    );
  }
}
