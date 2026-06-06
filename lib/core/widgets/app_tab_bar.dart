import 'package:driver/core/theme/app_colors.dart';
import 'package:driver/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTabBar extends StatelessWidget {
  const AppTabBar({
    super.key,
    required this.tabs,
    required this.currentIndex,
    required this.onChanged,
  });

  final List<String> tabs;
  final int currentIndex;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.grey100),
      ),
      child: Row(
        children: List.generate(tabs.length, (index) {
          final isActive = index == currentIndex;

          return Expanded(
            child: Padding(
              padding: EdgeInsets.all(4.r),
              child: TextButton(
                onPressed: () => onChanged(index),
                style: TextButton.styleFrom(
                  backgroundColor:
                      isActive ? AppColors.primary : Colors.transparent,
                  foregroundColor: isActive ? Colors.white : AppColors.grey500,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(9.r),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                ),
                child: Text(
                  tabs[index],
                  style: isActive
                      ? AppTextStyles.bodySemiBold(color: Colors.white)
                      : AppTextStyles.bodyMedium(color: AppColors.grey500),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
