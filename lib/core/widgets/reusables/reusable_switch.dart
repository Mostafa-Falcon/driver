import 'package:driver/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReusableSwitch extends StatelessWidget {
  const ReusableSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.activeColor,
    this.inactiveColor,
    this.activeThumbColor,
    this.inactiveThumbColor,
    this.width,
    this.height,
  });

  final bool value;
  final ValueChanged<bool> onChanged;
  final Color? activeColor;
  final Color? inactiveColor;
  final Color? activeThumbColor;
  final Color? inactiveThumbColor;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final double switchWidth = width ?? 54.w;
    final double switchHeight = height ?? 30.h;
    final double paddingValue = 4.r;
    final double thumbSize =
        (switchHeight - (paddingValue * 2)).clamp(0.0, double.infinity);

    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 240),
        width: switchWidth,
        height: switchHeight,
        padding: EdgeInsets.all(paddingValue),
        decoration: BoxDecoration(
          color: value
              ? (activeColor ?? AppColors.primary)
              : (inactiveColor ?? AppColors.grey300),
          borderRadius: BorderRadius.circular(999.r),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 240),
          curve: Curves.easeOut,
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: thumbSize,
            height: thumbSize,
            decoration: BoxDecoration(
              color: value
                  ? (activeThumbColor ?? Colors.white)
                  : (inactiveThumbColor ?? Colors.white54),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
