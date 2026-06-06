/// أسماء Collections في Firestore — مركزية لسهولة التعديل
class CollectionNames {
  CollectionNames._();

  // ── Core Collections ──────────────────────────────────────
  static const String users = 'users';
  static const String vendorOrders = 'vendor_orders';
  static const String orderEvents = 'order_events';
  static const String wallet = 'wallet';
  static const String notifications = 'notifications';
  static const String supportTickets = 'support_tickets';
  static const String walletRechargeRequests = 'wallet_recharge_requests';
  static const String settings = 'settings';
  static const String driverPayouts = 'driver_payouts';
  static const String withdrawMethod = 'withdraw_method';

  // ── Subcollections ────────────────────────────────────────
  /// Subcollection داخل كل طلب لتسجيل الأحداث
  static const String orderEventsSubcollection = 'order_events';

  // ── Onboarding ────────────────────────────────────────────
  static const String onBoarding = 'on_boarding';

  // ── Documents ────────────────────────────────────────────
  static const String documents = 'documents';
  static const String documentsVerify = 'documents_verify';

  // ── Chat ─────────────────────────────────────────────────
  static const String chatDriver = 'chat_driver';
}
