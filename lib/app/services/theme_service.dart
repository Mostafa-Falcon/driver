import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// خدمة الثيم (فاتح/داكن)
class ThemeService extends GetxService {
  static ThemeService get to => Get.find();

  final RxBool _isDark = false.obs;
  bool get isDark => _isDark.value;

  void toggleTheme() {
    _isDark.value = !_isDark.value;
    Get.changeThemeMode(isDark ? ThemeMode.dark : ThemeMode.light);
  }

  void setDark() {
    _isDark.value = true;
    Get.changeThemeMode(ThemeMode.dark);
  }

  void setLight() {
    _isDark.value = false;
    Get.changeThemeMode(ThemeMode.light);
  }
}
