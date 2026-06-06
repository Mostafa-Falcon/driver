import 'package:driver/core/constants/app_strings.dart';
import 'package:driver/core/theme/app_colors.dart';
import 'package:driver/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StatusChip extends StatelessWidget {
  const StatusChip({
    super.key,
    required this.status,
  });

  final String? status;

  @override
  Widget build(BuildContext context) {
    final color = AppColors.statusColor(status);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(999.r),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
        child: Text(
          AppStrings.orderStatus(status),
          style: AppTextStyles.captionMedium(color: color),
        ),
      ),
    );
  }
}
