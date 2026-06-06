import 'package:driver/app/modules/onboarding/controllers/onboarding_controller.dart';
import 'package:driver/core/theme/app_colors.dart';
import 'package:driver/core/theme/app_text_styles.dart';
import 'package:driver/core/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Align(
                alignment: AlignmentDirectional.centerEnd,
                child: TextButton(
                  onPressed: controller.finish,
                  child: Text(
                    'تخطي',
                    style: AppTextStyles.bodyMedium(color: AppColors.grey500),
                  ),
                ),
              ),
            ),

            // Pages
            Expanded(
              child: PageView.builder(
                controller: controller.pageController,
                onPageChanged: controller.onPageChanged,
                itemCount: controller.pages.length,
                itemBuilder: (_, index) {
                  final page = controller.pages[index];
                  return _OnboardingPage(page: page, index: index)
                      .animate()
                      .fadeIn(duration: 300.ms)
                      .slideY(begin: 0.04, end: 0, curve: Curves.easeOut);
                },
              ),
            ),

            // Dots + Button
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 24.h),
              child: Column(
                children: [
                  // Dots indicator
                  Obx(
                    () => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        controller.pages.length,
                        (index) {
                          final isActive =
                              index == controller.currentPage.value;
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 220),
                            curve: Curves.easeOut,
                            width: isActive ? 28.w : 8.r,
                            height: 8.r,
                            margin: EdgeInsets.symmetric(horizontal: 4.w),
                            decoration: BoxDecoration(
                              color: isActive
                                  ? AppColors.primary
                                  : AppColors.grey300,
                              borderRadius: BorderRadius.circular(999.r),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),

                  // Action button
                  Obx(
                    () => AppButton(
                      label: controller.isLastPage ? 'ابدأ الآن 🚀' : 'التالي',
                      onPressed: controller.next,
                      icon: controller.isLastPage
                          ? null
                          : const Icon(
                              Icons.arrow_back_rounded,
                              color: Colors.white,
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Onboarding Page ───────────────────────────────────────────────────────────

class _OnboardingPage extends StatelessWidget {
  const _OnboardingPage({
    required this.page,
    required this.index,
  });

  final OnboardingPageData page;
  final int index;

  // ألوان الخلفية لكل صفحة
  static const _gradients = [
    LinearGradient(
      colors: [Color(0xFFEAFBF3), Color(0xFFF5F7FF)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ),
    LinearGradient(
      colors: [Color(0xFFF0F9FF), Color(0xFFEAFBF3)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ),
    LinearGradient(
      colors: [Color(0xFFFFF8E5), Color(0xFFEAFBF3)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ),
  ];

  LinearGradient get _gradient => _gradients[index % _gradients.length];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image container with gradient background
          Container(
            width: double.infinity,
            height: 260.h,
            decoration: BoxDecoration(
              gradient: _gradient,
              borderRadius: BorderRadius.circular(24.r),
            ),
            child: Center(
              child: Image.asset(
                page.image,
                height: 200.h,
                fit: BoxFit.contain,
              ).animate(delay: 80.ms).fadeIn(duration: 350.ms).scale(
                    begin: const Offset(0.92, 0.92),
                    end: const Offset(1, 1),
                    duration: 400.ms,
                    curve: Curves.easeOutCubic,
                  ),
            ),
          ),
          SizedBox(height: 32.h),

          // Title
          Text(
            page.title,
            style: AppTextStyles.h1(),
            textAlign: TextAlign.center,
          )
              .animate(delay: 100.ms)
              .fadeIn(duration: 300.ms)
              .slideY(begin: 0.08, end: 0, curve: Curves.easeOut),

          SizedBox(height: 12.h),

          // Description
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Text(
              page.description,
              style: AppTextStyles.body(color: AppColors.grey500),
              textAlign: TextAlign.center,
            ),
          )
              .animate(delay: 160.ms)
              .fadeIn(duration: 300.ms)
              .slideY(begin: 0.08, end: 0, curve: Curves.easeOut),
        ],
      ),
    );
  }
}
