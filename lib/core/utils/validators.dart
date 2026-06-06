class Validators {
  Validators._();

  static String? required(String? value, [String fieldName = 'الحقل']) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName مطلوب';
    }
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.isEmpty) return 'البريد الإلكتروني مطلوب';

    final regExp = RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
    );
    if (!regExp.hasMatch(value)) return 'البريد الإلكتروني غير صالح';
    return null;
  }

  static String? phone(String? value) {
    if (value == null || value.isEmpty) return 'رقم الهاتف مطلوب';
    if (value.length < 9) return 'رقم الهاتف غير صالح';
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) return 'كلمة المرور مطلوبة';
    if (value.length < 6) {
      return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
    }
    return null;
  }

  static String? minLength(
    String? value,
    int min, [
    String fieldName = 'الحقل',
  ]) {
    if (value == null || value.length < min) {
      return '$fieldName يجب أن يحتوي على $min أحرف على الأقل';
    }
    return null;
  }

  static bool isValidUrl(String? url) {
    if (url == null || url.isEmpty) return false;
    return Uri.tryParse(url)?.hasAbsolutePath ?? false;
  }
}
