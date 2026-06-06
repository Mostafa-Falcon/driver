import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver/core/utils/app_logger.dart';
import 'package:driver/core/constants/app_strings.dart';
import 'package:get/get.dart';

/// خدمة إعدادات التطبيق العامة من Firestore
/// تُحمَّل مرة واحدة عند بدء التطبيق
class SettingsService extends GetxService {
  static SettingsService get to => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ── Settings ──────────────────────────────────────────────
  String commissionType = 'Percentage';
  double commissionValue = 10.0;
  String distanceUnit = 'km';
  double minimumWithdrawal = 0.0;
  String defaultCountryCode = '+966';
  String currencySymbol = AppStrings.currencySuffix;
  bool currencySymbolAtRight = false;
  int currencyDecimalDigits = 2;
  String appVersion = '';

  // ── Lifecycle ─────────────────────────────────────────────
  @override
  Future<void> onInit() async {
    super.onInit();
    await loadSettings();
  }

  Future<void> loadSettings() async {
    try {
      final doc =
          await _db.collection('settings').doc('general_settings').get();

      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;
        commissionType =
            (data['adminCommissionType'] as String?) ?? commissionType;
        commissionValue = double.tryParse(
              '${data['adminCommission'] ?? commissionValue}',
            ) ??
            commissionValue;
        distanceUnit = (data['distance_type'] as String?) ?? distanceUnit;
        minimumWithdrawal =
            double.tryParse('${data['minimum_withdrawal'] ?? 0}') ?? 0.0;
        defaultCountryCode =
            (data['default_country_code'] as String?) ?? defaultCountryCode;

        final currencyData = data['currency'] as Map<dynamic, dynamic>?;
        currencySymbol = (currencyData?['symbol'] as String?) ?? currencySymbol;
        currencySymbolAtRight =
            (currencyData?['symbolAtRight'] as bool?) ?? currencySymbolAtRight;
        currencyDecimalDigits =
            (currencyData?['decimal_digits'] as int?) ?? currencyDecimalDigits;

        appVersion = (data['app_version'] as String?) ?? '';
        AppLogger.info('Settings loaded successfully');
      }
    } catch (e) {
      AppLogger.error('loadSettings failed, using defaults', error: e);
    }
  }

  // ── Helpers ───────────────────────────────────────────────

  /// تنسيق المبلغ مع رمز العملة
  String formatAmount(double amount) {
    final formatted = amount.toStringAsFixed(currencyDecimalDigits);
    return currencySymbolAtRight
        ? '$formatted $currencySymbol'
        : '$currencySymbol $formatted';
  }

  /// حساب العمولة
  double calculateCommission(double orderTotal) {
    if (commissionType.toLowerCase() == 'percentage') {
      return orderTotal * commissionValue / 100;
    }
    return commissionValue;
  }
}
