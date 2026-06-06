import 'package:driver/core/constants/app_assets.dart';
import 'package:driver/core/constants/app_strings.dart';
import 'package:driver/core/theme/app_text_styles.dart';
import 'package:driver/core/widgets/app_brand_mark.dart';
import 'package:driver/core/widgets/state_widgets.dart';
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
          const AppBrandMark(
            size: 112,
            assetPath: AppAssets.appLogo,
          )
              .animate()
              .fadeIn(duration: 450.ms)
              .scale(
                begin: const Offset(0.88, 0.88),
                end: const Offset(1, 1),
                duration: 520.ms,
                curve: Curves.easeOutCubic,
              )
              .then()
              .shimmer(
                duration: 900.ms,
                color: Colors.white.withValues(alpha: 0.35),
              ),
          SizedBox(height: 24.h),
          Text(
            AppStrings.appTitle,
            style: AppTextStyles.h1(color: Colors.white),
            textAlign: TextAlign.center,
          )
              .animate(delay: 120.ms)
              .fadeIn(duration: 420.ms)
              .slideY(begin: 0.16, end: 0, curve: Curves.easeOutCubic),
          SizedBox(height: 8.h),
          Text(
            AppStrings.deliverySystem,
            style: AppTextStyles.body(color: Colors.white70),
            textAlign: TextAlign.center,
          )
              .animate(delay: 220.ms)
              .fadeIn(duration: 420.ms)
              .slideY(begin: 0.16, end: 0, curve: Curves.easeOutCubic),
          SizedBox(height: 56.h),
          const AppLoadingIndicator(
            color: Colors.white,
            size: 28,
            strokeWidth: 2.5,
          ).animate(delay: 320.ms).fadeIn(duration: 360.ms),
        ],
      ),
    );
  }
}
