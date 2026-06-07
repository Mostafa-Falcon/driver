import 'package:driver/core/theme/app_colors.dart';
import 'package:driver/core/widgets/reusables/reusable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileMenuItem extends StatelessWidget {
  const ProfileMenuItem({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
    this.iconBgColor,
    this.iconColor,
    this.trailing,
    this.showDivider = true,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final Color? iconBgColor;
  final Color? iconColor;
  final Widget? trailing;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final defaultIconColor = iconColor ?? AppColors.primary;
    final defaultBgColor = iconBgColor ??
        (isDark ? AppColors.greyDark200 : Colors.white.withValues(alpha: 0.9));
    final titleColor = isDark ? AppColors.greyDark900 : AppColors.grey800;
    final subtitleColor = isDark ? AppColors.greyDark500 : AppColors.grey500;

    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14.r),
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(12.w, 12.h, 12.w, 12.h),
            child: Row(
              children: [
                Container(
                  width: 34.r,
                  height: 34.r,
                  decoration: BoxDecoration(
                    color: defaultBgColor,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(
                    icon,
                    color: defaultIconColor,
                    size: 18.r,
                  ),
                ),
                SizedBox(width: 14.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ReusableText.bodySemiBold(
                        text: title,
                        color: titleColor,
                        fontSize: 14.sp,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (subtitle != null) ...[
                        SizedBox(height: 3.h),
                        ReusableText.caption(
                          text: subtitle!,
                          color: subtitleColor,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
                trailing ??
                    Icon(
                      Icons.chevron_left_rounded,
                      color: isDark ? AppColors.greyDark500 : AppColors.grey500,
                      size: 20.r,
                    ),
              ],
            ),
          ),
        ),
        if (showDivider)
          Padding(
            padding: EdgeInsetsDirectional.only(start: 60.w),
            child: Divider(
              height: 1,
              thickness: 0.9,
              color: isDark
                  ? AppColors.greyDark200.withValues(alpha: 0.7)
                  : Colors.white.withValues(alpha: 0.95),
            ),
          ),
      ],
    );
  }
}
