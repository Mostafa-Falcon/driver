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
    final defaultIconColor = iconColor ?? AppColors.primary;
    final defaultBgColor =
        iconBgColor ?? AppColors.primary.withValues(alpha: 0.08);

    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12.r),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 12.h),
            child: Row(
              children: [
                // Right: Icon inside colored circle
                Container(
                  width: 38.r,
                  height: 38.r,
                  decoration: BoxDecoration(
                    color: defaultBgColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: defaultIconColor,
                    size: 18.r,
                  ),
                ),
                SizedBox(width: 14.w),
                // Center: Title + optional subtitle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ReusableText.bodySemiBold(
                        text: title,
                        fontSize: 14.sp,
                      ),
                      if (subtitle != null) ...[
                        SizedBox(height: 3.h),
                        ReusableText.caption(
                          text: subtitle!,
                          color: AppColors.grey500,
                        ),
                      ],
                    ],
                  ),
                ),
                // Left: Trailing widget (chevron, text, switch)
                trailing ??
                    Icon(
                      Icons.chevron_left_rounded,
                      color: AppColors.grey400,
                      size: 20.r,
                    ),
              ],
            ),
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            thickness: 0.8,
            color: Theme.of(context).dividerTheme.color,
            indent: 52.w, // aligned with text start
          ),
      ],
    );
  }
}
