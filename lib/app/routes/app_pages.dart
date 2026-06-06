import 'package:driver/app/modules/forgot_password/bindings/forgot_password_binding.dart';
import 'package:driver/app/modules/forgot_password/views/forgot_password_view.dart';
import 'package:driver/app/modules/home/bindings/home_binding.dart';
import 'package:driver/app/modules/home/views/home_view.dart';
import 'package:driver/app/modules/login/bindings/login_binding.dart';
import 'package:driver/app/modules/login/views/login_view.dart';
import 'package:driver/app/modules/notifications/bindings/notifications_binding.dart';
import 'package:driver/app/modules/notifications/views/notifications_view.dart';
import 'package:driver/app/modules/onboarding/bindings/onboarding_binding.dart';
import 'package:driver/app/modules/onboarding/views/onboarding_view.dart';
import 'package:driver/app/modules/order_details/bindings/order_details_binding.dart';
import 'package:driver/app/modules/order_details/views/order_details_view.dart';
import 'package:driver/app/modules/otp/bindings/otp_binding.dart';
import 'package:driver/app/modules/otp/views/otp_view.dart';
import 'package:driver/app/modules/phone_number/bindings/phone_number_binding.dart';
import 'package:driver/app/modules/phone_number/views/phone_number_view.dart';
import 'package:driver/app/modules/profile/bindings/profile_binding.dart';
import 'package:driver/app/modules/profile/views/profile_view.dart';
import 'package:driver/app/modules/signup/bindings/signup_binding.dart';
import 'package:driver/app/modules/signup/views/signup_view.dart';
import 'package:driver/app/modules/splash/bindings/splash_binding.dart';
import 'package:driver/app/modules/splash/views/splash_view.dart';
import 'package:driver/app/modules/support/bindings/support_binding.dart';
import 'package:driver/app/modules/support/views/support_view.dart';
import 'package:driver/app/modules/wallet/bindings/wallet_binding.dart';
import 'package:driver/app/modules/wallet/views/wallet_view.dart';
import 'package:get/get.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = AppRoutes.splash;

  static final routes = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: AppRoutes.onboarding,
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: AppRoutes.forgotPassword,
      page: () => const ForgotPasswordView(),
      binding: ForgotPasswordBinding(),
    ),
    GetPage(
      name: AppRoutes.phoneNumber,
      page: () => const PhoneNumberView(),
      binding: PhoneNumberBinding(),
    ),
    GetPage(
      name: AppRoutes.otp,
      page: () => const OtpView(),
      binding: OtpBinding(),
    ),
    GetPage(
      name: AppRoutes.signup,
      page: () => const SignupView(),
      binding: SignupBinding(),
    ),
    GetPage(
      name: AppRoutes.orderDetails,
      page: () => const OrderDetailsView(),
      binding: OrderDetailsBinding(),
    ),
    GetPage(
      name: AppRoutes.wallet,
      page: () => const WalletView(),
      binding: WalletBinding(),
    ),
    GetPage(
      name: AppRoutes.support,
      page: () => const SupportView(),
      binding: SupportBinding(),
    ),
    GetPage(
      name: AppRoutes.notifications,
      page: () => const NotificationsView(),
      binding: NotificationsBinding(),
    ),
    GetPage(
      name: AppRoutes.editProfile,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
  ];
}
