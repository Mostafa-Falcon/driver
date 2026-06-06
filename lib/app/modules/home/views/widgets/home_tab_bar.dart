import 'package:driver/app/modules/home/controllers/home_controller.dart';
import 'package:driver/core/theme/app_colors.dart';
import 'package:driver/core/widgets/reusables/reusable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class HomeTabBar extends StatelessWidget {
  const HomeTabBar({super.key, required this.controller});

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isDark = Theme.of(context).brightness == Brightness.dark;
      final tabs = [
        (label: 'الجديدة', count: controller.newOrders.length),
        (label: 'الحالية', count: controller.activeOrders.length),
        (label: 'السابقة', count: controller.previousOrders.length),
      ];
      final current = controller.currentTab.value;

      return Container(
        height: 46.h,
        padding: EdgeInsets.all(4.r),
        decoration: BoxDecoration(
          color: isDark ? AppColors.greyDark100 : AppColors.grey100,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: List.generate(tabs.length, (index) {
            final tab = tabs[index];
            final isActive = index == current;

            return Expanded(
              child: GestureDetector(
                onTap: () => controller.currentTab.value = index,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeInOut,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isActive ? AppColors.primary : Colors.transparent,
                    borderRadius: BorderRadius.circular(8.r),
                    boxShadow: isActive
                        ? [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.15),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ReusableText.bodySemiBold(
                        text: tab.label,
                        color: isActive
                            ? Colors.white
                            : (isDark
                                ? AppColors.greyDark600
                                : AppColors.grey600),
                        fontSize: 13.sp,
                      ),
                      if (tab.count > 0) ...[
                        SizedBox(width: 6.w),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 220),
                          padding: EdgeInsets.symmetric(
                            horizontal: 6.w,
                            vertical: 1.5.h,
                          ),
                          decoration: BoxDecoration(
                            color: isActive
                                ? Colors.white.withValues(alpha: 0.25)
                                : AppColors.primary.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(99),
                          ),
                          child: ReusableText.caption(
                            text: '${tab.count}',
                            color: isActive ? Colors.white : AppColors.primary,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      );
    });
  }
}
