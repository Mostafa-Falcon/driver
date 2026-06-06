import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// زر رئيسي قابل لإعادة الاستخدام
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height = 52,
    this.icon,
    this.borderRadius = 12,
  });
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double height;
  final Widget? icon;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final resolvedWidth = width == null || width!.isInfinite
        ? width ?? double.infinity
        : width!.w;

    final style = ButtonStyle(
      minimumSize: WidgetStateProperty.all(
        Size(resolvedWidth, height.h),
      ),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius.r),
          side: isOutlined
              ? BorderSide(
                  color: backgroundColor ?? AppColors.primary,
                  width: 1.5,
                )
              : BorderSide.none,
        ),
      ),
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) return AppColors.grey300;
        if (isOutlined) return Colors.transparent;
        return backgroundColor ?? AppColors.primary;
      }),
      elevation: WidgetStateProperty.all(0),
      overlayColor: WidgetStateProperty.all(Colors.white12),
    );

    final content = isLoading
        ? SizedBox(
            height: 22.r,
            width: 22.r,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: isOutlined ? AppColors.primary : AppColors.grey50,
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[icon!, SizedBox(width: 8.w)],
              Text(
                label,
                style: AppTextStyles.button(
                  color: isOutlined
                      ? (textColor ?? AppColors.primary)
                      : (textColor ?? AppColors.grey50),
                ),
              ),
            ],
          );

    if (isOutlined) {
      return OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: style,
        child: content,
      );
    }

    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: style,
      child: content,
    );
  }
}
