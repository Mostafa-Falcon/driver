import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// خدمة الثيم (فاتح/داكن) المتصلة بقاعدة البيانات المحلية
class ThemeService extends GetxService {
  ThemeService(bool initialDark) {
    _isDark.value = initialDark;
  }

  static ThemeService get to => Get.find();

  final RxBool _isDark = false.obs;
  bool get isDark => _isDark.value;

  static const String _key = 'isDarkMode';

  Future<void> toggleTheme() async {
    _isDark.value = !_isDark.value;
    Get.changeThemeMode(_isDark.value ? ThemeMode.dark : ThemeMode.light);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, _isDark.value);
  }

  Future<void> setDark() async {
    _isDark.value = true;
    Get.changeThemeMode(ThemeMode.dark);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, true);
  }

  Future<void> setLight() async {
    _isDark.value = false;
    Get.changeThemeMode(ThemeMode.light);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, false);
  }
}
