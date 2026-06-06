import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

/// ثيم التطبيق — فاتح وداكن
class AppTheme {
  AppTheme._();

  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: 'Almarai',
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.primary300,
        surface: AppColors.surface,
        error: AppColors.danger,
      ),
      scaffoldBackgroundColor: AppColors.backgroundLight,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.grey900,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppTextStyles.h3(),
        iconTheme: const IconThemeData(color: AppColors.grey900),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 2,
        shadowColor: AppColors.grey200,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.grey50,
          textStyle: AppTextStyles.button(),
          minimumSize: Size(double.infinity, 52.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: AppTextStyles.button(color: AppColors.primary),
          minimumSize: Size(double.infinity, 52.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          side: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.grey50,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: AppColors.grey200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: AppColors.grey200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: AppColors.danger),
        ),
        hintStyle: AppTextStyles.body(color: AppColors.grey400),
        labelStyle: AppTextStyles.bodyMedium(color: AppColors.grey600),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.grey200,
        thickness: 1,
      ),
      textTheme: TextTheme(
        bodyLarge: AppTextStyles.bodyLarge(),
        bodyMedium: AppTextStyles.body(),
        bodySmall: AppTextStyles.caption(),
        titleLarge: AppTextStyles.h2(),
        titleMedium: AppTextStyles.h3(),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.grey400,
        elevation: 8,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  static ThemeData dark() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: 'Almarai',
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary300,
        secondary: AppColors.primary,
        surface: AppColors.surfaceDark,
        error: AppColors.danger,
      ),
      scaffoldBackgroundColor: AppColors.backgroundDark,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.surfaceDark,
        foregroundColor: AppColors.greyDark900,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppTextStyles.h3(isDark: true),
        iconTheme: const IconThemeData(color: AppColors.greyDark900),
      ),
      cardTheme: CardThemeData(
        color: AppColors.greyDark100,
        elevation: 2,
        shadowColor: Colors.black26,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary300,
          foregroundColor: AppColors.grey900,
          textStyle: AppTextStyles.button(color: AppColors.grey900),
          minimumSize: Size(double.infinity, 52.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          elevation: 0,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.greyDark100,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: AppColors.greyDark200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: AppColors.greyDark200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: AppColors.primary300, width: 1.5),
        ),
        hintStyle:
            AppTextStyles.body(color: AppColors.greyDark400, isDark: true),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.greyDark200,
        thickness: 1,
      ),
      textTheme: TextTheme(
        bodyLarge: AppTextStyles.bodyLarge(isDark: true),
        bodyMedium: AppTextStyles.body(isDark: true),
        bodySmall: AppTextStyles.caption(isDark: true),
        titleLarge: AppTextStyles.h2(isDark: true),
        titleMedium: AppTextStyles.h3(isDark: true),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.surfaceDark,
        selectedItemColor: AppColors.primary300,
        unselectedItemColor: AppColors.greyDark400,
        elevation: 8,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
