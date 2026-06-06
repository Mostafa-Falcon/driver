import 'package:driver/core/theme/app_colors.dart';
import 'package:driver/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmptyStateWidget extends StatelessWidget {
  const EmptyStateWidget({
    super.key,
    required this.message,
    this.subMessage,
    this.icon,
    this.iconWidget,
    this.action,
  });

  final String message;
  final String? subMessage;
  final IconData? icon;
  final Widget? iconWidget;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            iconWidget ??
                Icon(
                  icon ?? Icons.inbox_outlined,
                  size: 64.r,
                  color: isDark ? AppColors.greyDark300 : AppColors.grey300,
                ),
            SizedBox(height: 16.h),
            Text(
              message,
              style: AppTextStyles.h3(
                  color: isDark ? AppColors.greyDark600 : AppColors.grey500,
                  isDark: isDark,
              ),
              textAlign: TextAlign.center,
            ),
            if (subMessage != null) ...[
              SizedBox(height: 8.h),
              Text(
                subMessage!,
                style: AppTextStyles.body(
                    color: isDark ? AppColors.greyDark400 : AppColors.grey400,
                    isDark: isDark,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (action != null) ...[
              SizedBox(height: 24.h),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}

class AppLoadingIndicator extends StatelessWidget {
  const AppLoadingIndicator({
    super.key,
    this.color = AppColors.primary,
    this.size = 32,
    this.strokeWidth = 3,
  });

  final Color color;
  final double size;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size.r,
      child: CircularProgressIndicator(
        color: color,
        strokeWidth: strokeWidth,
      ),
    );
  }
}

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key, this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const AppLoadingIndicator(),
          if (message != null) ...[
            SizedBox(height: 16.h),
            Text(
              message!,
              style: AppTextStyles.body(color: AppColors.grey500),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}
