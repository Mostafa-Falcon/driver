import 'package:flutter/material.dart';

/// نظام ألوان التطبيق المركزي
/// Primary: أخضر — يمثل التوصيل والنجاح
/// اللون الأساسي مستوحى من driver-old مع تنظيم أفضل
class AppColors {
  AppColors._();

  // ── Surfaces ──────────────────────────────────────────────
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF010309);
  static const Color backgroundLight = Color(0xFFF5F7F9);
  static const Color backgroundDark = Color(0xFF0C111C);

  // ── Primary (Green) ───────────────────────────────────────
  static const Color primary50 = Color(0xFFEAFBF3);
  static const Color primary100 = Color(0xFFAAEFCF);
  static const Color primary200 = Color(0xFF6AE2AB);
  static const Color primary300 = Color(0xFF2AD587);
  static const Color primary = Color(0xFF1E955E); // Main Brand Color
  static const Color primary500 = Color(0xFF115536);
  static const Color primary600 = Color(0xFF04150E);

  // ── Grey Scale ────────────────────────────────────────────
  static const Color grey50 = Color(0xFFF9FAFB);
  static const Color grey100 = Color(0xFFF3F4F6);
  static const Color grey200 = Color(0xFFE5E7EB);
  static const Color grey300 = Color(0xFFD1D5DB);
  static const Color grey400 = Color(0xFF9CA3AF);
  static const Color grey500 = Color(0xFF6B7280);
  static const Color grey600 = Color(0xFF4B5563);
  static const Color grey700 = Color(0xFF374151);
  static const Color grey800 = Color(0xFF1F2937);
  static const Color grey900 = Color(0xFF0C111C);

  // ── Dark Grey Scale ───────────────────────────────────────
  static const Color greyDark50 = Color(0xFF0C111C);
  static const Color greyDark100 = Color(0xFF1F2937);
  static const Color greyDark200 = Color(0xFF374151);
  static const Color greyDark300 = Color(0xFF4B5563);
  static const Color greyDark400 = Color(0xFF6B7280);
  static const Color greyDark500 = Color(0xFF9CA3AF);
  static const Color greyDark600 = Color(0xFFD1D5DB);
  static const Color greyDark900 = Color(0xFFF9FAFB);

  // ── Semantic Colors ───────────────────────────────────────
  static const Color success = Color(0xFF26B246);
  static const Color success50 = Color(0xFFE5FFEB);
  static const Color success400 = Color(0xFF26B246);

  static const Color danger = Color(0xFFFF3840);
  static const Color danger50 = Color(0xFFFFE5E6);
  static const Color danger300 = Color(0xFFFF3840);

  static const Color warning = Color(0xFFFFCB39);
  static const Color warning50 = Color(0xFFFFF8E5);
  static const Color warning300 = Color(0xFFFFCB39);

  static const Color info = Color(0xFF38D0FF);
  static const Color info50 = Color(0xFFE5F9FF);
  static const Color info300 = Color(0xFF38D0FF);

  // ── Gradients ─────────────────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF1E955E), Color(0xFF2AD587)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const List<Color> homeGradient = [
    Color(0xFFF5F7FF),
    Color(0xFFFFF5F5),
    Color(0xFFF1FEF7),
  ];

  // ── Status Color Helpers ──────────────────────────────────
  static Color statusColor(String? status) {
    return switch (status) {
      'Order Placed' => warning300,
      'Driver Accepted' || 'Order Completed' => success400,
      'Order Cancelled' || 'Order Rejected' => danger300,
      'In Transit' || 'Order Shipped' => info300,
      _ => grey400,
    };
  }

  static Color statusTextColor(String? status) {
    return switch (status) {
      'Order Placed' ||
      'Driver Accepted' ||
      'Order Completed' ||
      'Order Cancelled' ||
      'Order Rejected' =>
        grey50,
      _ => grey900,
    };
  }
}
