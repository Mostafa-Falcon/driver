import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app_colors.dart';

/// نظام الطباعة (Typography) المركزي
/// الخط الأساسي: Almarai (عربي + إنجليزي)
class AppTextStyles {
  AppTextStyles._();

  static const String _fontFamily = 'Almarai';

  // ── Display ───────────────────────────────────────────────
  static TextStyle display({Color? color, bool isDark = false}) => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 30.sp,
        fontWeight: FontWeight.w700,
        color: color ?? (isDark ? AppColors.greyDark900 : AppColors.grey900),
      );

  // ── Headings ──────────────────────────────────────────────
  static TextStyle h1({Color? color, bool isDark = false}) => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 24.sp,
        fontWeight: FontWeight.w700,
        color: color ?? (isDark ? AppColors.greyDark900 : AppColors.grey900),
      );

  static TextStyle h2({Color? color, bool isDark = false}) => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 20.sp,
        fontWeight: FontWeight.w700,
        color: color ?? (isDark ? AppColors.greyDark900 : AppColors.grey900),
      );

  static TextStyle h3({Color? color, bool isDark = false}) => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
        color: color ?? (isDark ? AppColors.greyDark900 : AppColors.grey900),
      );

  // ── Body ──────────────────────────────────────────────────
  static TextStyle bodyLarge({Color? color, bool isDark = false}) => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 16.sp,
        fontWeight: FontWeight.w500,
        color: color ?? (isDark ? AppColors.greyDark900 : AppColors.grey900),
      );

  static TextStyle body({Color? color, bool isDark = false}) => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        color: color ?? (isDark ? AppColors.greyDark900 : AppColors.grey900),
      );

  static TextStyle bodyMedium({Color? color, bool isDark = false}) => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
        color: color ?? (isDark ? AppColors.greyDark900 : AppColors.grey900),
      );

  static TextStyle bodySemiBold({Color? color, bool isDark = false}) =>
      TextStyle(
        fontFamily: _fontFamily,
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        color: color ?? (isDark ? AppColors.greyDark900 : AppColors.grey900),
      );

  // ── Caption ───────────────────────────────────────────────
  static TextStyle caption({Color? color, bool isDark = false}) => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 12.sp,
        fontWeight: FontWeight.w400,
        color: color ?? (isDark ? AppColors.greyDark500 : AppColors.grey500),
      );

  static TextStyle captionMedium({Color? color, bool isDark = false}) =>
      TextStyle(
        fontFamily: _fontFamily,
        fontSize: 12.sp,
        fontWeight: FontWeight.w500,
        color: color ?? (isDark ? AppColors.greyDark500 : AppColors.grey500),
      );

  // ── Label / Button ────────────────────────────────────────
  static TextStyle button({Color? color}) => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        color: color ?? AppColors.grey50,
      );
}
