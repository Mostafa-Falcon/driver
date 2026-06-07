import 'package:driver/core/theme/app_colors.dart';
import 'package:driver/core/widgets/reusables/reusable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileSectionCard extends StatelessWidget {
  const ProfileSectionCard({
    super.key,
    required this.title,
    required this.children,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? AppColors.greyDark100 : const Color(0xFFF1F3F2);
    final borderColor = isDark
        ? AppColors.greyDark200.withValues(alpha: 0.75)
        : Colors.white.withValues(alpha: 0.9);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsetsDirectional.only(
            start: 4.w,
            end: 4.w,
            bottom: 8.h,
          ),
          child: ReusableText.bodySemiBold(
            text: title,
            color: isDark ? AppColors.greyDark600 : AppColors.grey700,
            fontSize: 13.sp,
          ),
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: borderColor),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.08 : 0.025),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16.r),
            child: Column(children: children),
          ),
        ),
      ],
    );
  }
}
