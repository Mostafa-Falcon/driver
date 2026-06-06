import 'package:driver/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

/// أداة عرض التنبيهات والرسائل والـ Loader بشكل احترافي وجمالي متميز
class ToastUtils {
  ToastUtils._();

  /// عرض رسالة نجاح مخصصة (Toast) بشكل بطاقة عائمة جذابة
  static void showSuccess(String message) {
    final isDark = Get.isDarkMode;
    _showCustomSnackbar(
      message: message,
      icon: Icons.check_circle_outline_rounded,
      backgroundColor:
          isDark ? const Color(0xFF064E3B) : const Color(0xFFECFDF5),
      borderColor: isDark ? const Color(0xFF047857) : const Color(0xFFA7F3D0),
      textColor: isDark ? const Color(0xFFA7F3D0) : const Color(0xFF065F46),
      iconColor: isDark ? const Color(0xFF34D399) : const Color(0xFF10B981),
    );
  }

  /// عرض رسالة خطأ مخصصة بشكل بطاقة عائمة واضحة ومنسقة
  static void showError(String message) {
    final isDark = Get.isDarkMode;
    _showCustomSnackbar(
      message: message,
      icon: Icons.error_outline_rounded,
      backgroundColor:
          isDark ? const Color(0xFF7F1D1D) : const Color(0xFFFEF2F2),
      borderColor: isDark ? const Color(0xFFB91C1C) : const Color(0xFFFEE2E2),
      textColor: isDark ? const Color(0xFFFCA5A5) : const Color(0xFF991B1B),
      iconColor: isDark ? const Color(0xFFF87171) : const Color(0xFFEF4444),
    );
  }

  /// عرض تنبيه عادي أو معلومة عائمة
  static void showToast(String message) {
    final isDark = Get.isDarkMode;
    _showCustomSnackbar(
      message: message,
      icon: Icons.info_outline_rounded,
      backgroundColor:
          isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
      borderColor: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
      textColor: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF334155),
      iconColor: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
    );
  }

  /// عرض واجهة تحميل (Loader) لحجب الشاشة مؤقتاً أثناء إرسال البيانات أو تنفيذ طلبات حرجة
  static void showLoader([String? message]) {
    EasyLoading.show(status: message ?? 'جاري التحميل...');
  }

  /// إخفاء واجهة التحميل
  static void hideLoader() {
    EasyLoading.dismiss();
  }

  /// دالة داخلية لبناء وعرض الـ Snackbar المخصص بخصائص جمالية فائقة
  static void _showCustomSnackbar({
    required String message,
    required IconData icon,
    required Color backgroundColor,
    required Color borderColor,
    required Color textColor,
    required Color iconColor,
  }) {
    // إغلاق أي تنبيه مفتوح حالياً لتجنب تراكم الرسائل
    Get.closeCurrentSnackbar();

    Get.rawSnackbar(
      messageText: Text(
        message,
        style: AppTextStyles.bodyMedium(color: textColor),
        textDirection: TextDirection.rtl,
      ),
      icon: Container(
        padding: EdgeInsets.all(6.r),
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: 0.12),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: iconColor,
          size: 20.r,
        ),
      ),
      backgroundColor:
          backgroundColor.withValues(alpha: 0.95), // تأثير شفافية زجاجية بسيط
      borderRadius: 16.r,
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 14.h),
      snackPosition:
          SnackPosition.TOP, // عرض الرسالة من الأعلى لمزيد من الأناقة
      duration: const Duration(seconds: 4),
      boxShadows: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.08),
          blurRadius: 16,
          offset: const Offset(0, 8),
        ),
        BoxShadow(
          color: iconColor.withValues(alpha: 0.03),
          blurRadius: 6,
          offset: const Offset(0, 2),
        ),
      ],
      borderColor: borderColor,
      borderWidth: 1.2.w,
      dismissDirection: DismissDirection.horizontal,
      isDismissible: true,
      forwardAnimationCurve: Curves.easeOutBack, // حركة دخول حيوية وسلسة
      reverseAnimationCurve: Curves.easeInCubic,
    );
  }
}
