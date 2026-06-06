import 'package:driver/core/theme/app_colors.dart';
import 'package:driver/core/widgets/reusables/reusable_text.dart';
import 'package:driver/core/widgets/reusables/reusable_switch.dart';
import 'package:driver/core/widgets/reusables/reusable_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HeaderWidgets extends StatelessWidget {
  const HeaderWidgets({
    super.key,
    required this.userIcon,
    required this.username,
    required this.userActivetion,
    this.onTapNotification,
    this.onTapIsOnline,
    this.isOnline = false,
    this.notificationCount = 0,
  });

  final Widget userIcon;
  final String username;
  final String userActivetion;
  final Function()? onTapNotification;
  final Function()? onTapIsOnline;
  final bool isOnline;
  final int notificationCount;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isActivated = userActivetion == 'حساب مفعل';

    final avatarBg = isDark ? AppColors.greyDark200 : AppColors.grey200;
    final activationColor = isActivated ? AppColors.success : AppColors.warning;
    final onlineBadgeBg = isOnline
        ? AppColors.success.withValues(alpha: isDark ? 0.15 : 0.12)
        : (isDark ? AppColors.greyDark100 : AppColors.grey100);
    final onlineBadgeBorder = isOnline
        ? AppColors.success.withValues(alpha: 0.25)
        : (isDark ? AppColors.greyDark200 : AppColors.grey200);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 46.w,
                height: 46.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: avatarBg,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: userIcon,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const ReusableText.caption(
                      text: 'مرحباً بك 👋',
                      color: AppColors.grey500,
                    ),
                    SizedBox(height: 2.h),
                    ReusableText.bodySemiBold(
                      text: username,
                      fontSize: 15.sp,
                    ),
                    SizedBox(height: 2.h),
                    Row(
                      children: [
                        Container(
                          width: 6.r,
                          height: 6.r,
                          decoration: BoxDecoration(
                            color: activationColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        ReusableText.caption(
                          text: userActivetion,
                          color: activationColor,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 240),
                width: isOnline ? 100.w : 120.w,
                height: 38.h,
                decoration: BoxDecoration(
                  color: onlineBadgeBg,
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: onlineBadgeBorder,
                    width: 1.2,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ReusableText(
                      text: isOnline ? 'متصل' : 'غير متصل',
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.bold,
                        color: isOnline
                            ? AppColors.success
                            : (isDark ? AppColors.greyDark600 : AppColors.grey600),
                      ),
                    ),
                    SizedBox(width: 6.w),
                    ReusableSwitch(
                      value: isOnline,
                      onChanged: onTapIsOnline != null
                          ? (_) => onTapIsOnline!()
                          : (_) {},
                      width: 42.w,
                      height: 22.h,
                      activeColor: AppColors.success,
                      inactiveColor: AppColors.grey400,
                      activeThumbColor: Colors.white,
                      inactiveThumbColor: isDark
                          ? AppColors.greyDark900
                          : Colors.white,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 6.w),
              ReusableNotification(
                onTap: onTapNotification ?? () {},
                count: notificationCount,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
