class AppStrings {
  AppStrings._();

  static const appTitle = 'تطبيق السائق';
  static const deliverySystem = 'منظومة التوصيل';

  static const undefined = 'غير محدد';
  static const driver = 'السائق';
  static const currencySuffix = 'ر.س';

  static const statusNew = 'جديد';
  static const statusOffered = 'معروض';
  static const statusAccepted = 'مقبول';
  static const statusPickedUp = 'تم الاستلام';
  static const statusInTransit = 'في الطريق';
  static const statusDelivered = 'تم التسليم';
  static const statusCancelled = 'ملغي';
  static const statusRejected = 'مرفوض';
  static const statusHidden = 'مخفي';

  static String orderStatus(String? status) {
    return switch (status) {
      'Order Placed' => statusNew,
      'offered' => statusOffered,
      'Driver Accepted' => statusAccepted,
      'Order Shipped' => statusPickedUp,
      'In Transit' => statusInTransit,
      'Order Completed' => statusDelivered,
      'Order Cancelled' => statusCancelled,
      'Order Rejected' => statusRejected,
      'hidden' => statusHidden,
      _ => status ?? undefined,
    };
  }
}
