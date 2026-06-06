part of 'app_pages.dart';

abstract class AppRoutes {
  AppRoutes._();

  static const String splash = '/splash';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String phoneNumber = '/phone-number';
  static const String otp = '/otp';
  static const String forgotPassword = '/forgot-password';

  static const String home = '/home';
  static const String orderDetails = '/order-details';
  static const String pickupOrder = '/pickup-order';
  static const String deliverOrder = '/deliver-order';

  static const String wallet = '/wallet';
  static const String support = '/support';
  static const String notifications = '/notifications';
  static const String editProfile = '/edit-profile';
  static const String inbox = '/inbox';
  static const String chat = '/chat';
}
