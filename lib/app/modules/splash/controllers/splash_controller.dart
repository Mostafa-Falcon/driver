import 'dart:async';

import 'package:driver/app/routes/app_pages.dart';
import 'package:driver/app/services/auth_service.dart';
import 'package:driver/core/constants/app_constants.dart';
import 'package:driver/core/utils/app_logger.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashController extends GetxController {
  static const Duration minimumSplashDuration = Duration(seconds: 3);

  @override
  void onInit() {
    super.onInit();
    unawaited(_navigate());
  }

  Future<void> _navigate() async {
    try {
      final authService = AuthService.to;

      await Future.wait([
        Future.delayed(minimumSplashDuration),
        authService.waitForInitialAuthState(),
      ]);

      final prefs = await SharedPreferences.getInstance();
      final onboardingCompleted =
          prefs.getBool(AppConstants.prefOnboardingCompleted) ?? false;
      if (!onboardingCompleted) {
        AppLogger.info('SplashController: Onboarding pending');
        await Get.offAllNamed(AppRoutes.onboarding);
        return;
      }

      if (authService.isAuthenticated) {
        AppLogger.info('SplashController: User authenticated -> Home');
        await Get.offAllNamed(AppRoutes.home);
      } else {
        AppLogger.info('SplashController: Not authenticated -> Login');
        await Get.offAllNamed(AppRoutes.login);
      }
    } catch (e) {
      AppLogger.error('SplashController navigation error', error: e);
      await Get.offAllNamed(AppRoutes.login);
    }
  }
}
