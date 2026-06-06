/// ثوابت التطبيق الأساسية — حالات الطلب، المفاتيح، الإعدادات
class AppConstants {
  AppConstants._();

  // ── App Info ──────────────────────────────────────────────
  static const String appName = 'Driver';
  static const String globalAdminUrl = 'https://adminn.ajlansuperapp.com/';

  // ── User Roles ────────────────────────────────────────────
  static const String roleDriver = 'driver';
  static const String roleCustomer = 'customer';
  static const String roleVendor = 'vendor';

  // ── Order Statuses ────────────────────────────────────────
  /// الطلب وُضع من العميل
  static const String statusOrderPlaced = 'Order Placed';

  /// الطلب مُعروض على المندوب
  static const String statusOffered = 'offered';

  /// المندوب قبل الطلب
  static const String statusDriverAccepted = 'Driver Accepted';

  /// تم شحن الطلب
  static const String statusOrderShipped = 'Order Shipped';

  /// الطلب في الطريق
  static const String statusInTransit = 'In Transit';

  /// الطلب مكتمل
  static const String statusOrderCompleted = 'Order Completed';

  /// الطلب ملغي
  static const String statusOrderCancelled = 'Order Cancelled';

  /// تم رفض الطلب
  static const String statusOrderRejected = 'Order Rejected';

  /// الطلب مخفي عن المندوب (لا يؤثر على الحالة العالمية)
  static const String statusHidden = 'hidden';

  // ── Event Types (order_events) ────────────────────────────
  static const String eventOffered = 'offered';
  static const String eventAccepted = 'accepted';
  static const String eventHidden = 'hidden';
  static const String eventPickedUp = 'picked_up';
  static const String eventStatusChanged = 'status_changed';
  static const String eventCompleted = 'completed';
  static const String eventCancelled = 'cancelled';

  // ── Driver Wallet Rules ───────────────────────────────────
  static const double defaultDriverAppCommission = 20.0;

  // ── Wallet Transaction Types ──────────────────────────────
  static const String walletTopup = 'topup';
  static const String walletWithdrawal = 'withdrawal';
  static const String walletCommission = 'commission';
  static const String walletAdjustment = 'adjustment';
  static const String walletRefund = 'refund';

  // ── Notification Types ────────────────────────────────────
  static const String notifNewOrder = 'new_order_placed';
  static const String notifDriverAccepted = 'driver_accepted';
  static const String notifOrderCompleted = 'driver_completed';
  static const String notifPayoutRequest = 'payout_request_status';

  // ── Preferences Keys ─────────────────────────────────────
  static const String prefLanguageCode = 'language_code';
  static const String prefIsFirstLaunch = 'is_first_launch';
  static const String prefOnboardingCompleted = 'onboarding_completed';
  static const String prefThemeMode = 'theme_mode';

  // ── Distance ─────────────────────────────────────────────
  static const String distanceKm = 'km';
  static const String distanceMiles = 'miles';

  // ── Asset Paths ──────────────────────────────────────────
  static const String placeholderUser = 'assets/images/user_placeholder.png';
  static const String logoPath = 'assets/images/logo.png';
}
