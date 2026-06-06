import 'package:driver/core/theme/app_colors.dart';
import 'package:driver/core/widgets/reusables/reusable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReusableNotification extends StatelessWidget {
  const ReusableNotification({
    super.key,
    required this.onTap,
    this.count = 0,
    this.iconColor,
    this.badgeColor,
    this.badgeTextColor,
    this.size,
  });

  final VoidCallback onTap;
  final int count;
  final Color? iconColor;
  final Color? badgeColor;
  final Color? badgeTextColor;
  final double? size;

  @override
  Widget build(BuildContext context) {
    final double buttonSize = size ?? 20.r;

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: AppColors.grey50,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.grey200, width: 1),
            ),
            child: Icon(
              Icons.notifications_none_outlined,
              color: iconColor ?? AppColors.grey700,
              size: buttonSize,
            ),
          ),
          if (count > 0)
            Positioned(
              top: -2.r,
              right: -2.r,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: badgeColor ?? AppColors.danger,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 1.5),
                ),
                constraints: BoxConstraints(
                  minWidth: 16.r,
                  minHeight: 16.r,
                ),
                alignment: Alignment.center,
                child: ReusableText(
                  text: count > 99 ? '99+' : count.toString(),
                  variant: TextVariant.caption,
                  color: badgeTextColor ?? Colors.white,
                  fontSize: 9.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
