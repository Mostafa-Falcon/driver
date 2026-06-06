import 'package:driver/app/routes/app_pages.dart';
import 'package:driver/app/services/auth_service.dart';
import 'package:driver/core/constants/app_assets.dart';
import 'package:driver/core/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingController extends GetxController {
  final pageController = PageController();
  final RxInt currentPage = 0.obs;

  final pages = const [
    OnboardingPageData(
      image: AppAssets.onboarding1,
      title: 'استقبل الطلبات بسهولة',
      description:
          'تابع الطلبات الجديدة والنشطة من لوحة واحدة واضحة ومهيأة للسائق.',
    ),
    OnboardingPageData(
      image: AppAssets.onboarding2,
      title: 'تحرك بثقة',
      description:
          'راجع عنوان الاستلام والتسليم، وحدث حالة الرحلة بخطوات بسيطة.',
    ),
    OnboardingPageData(
      image: AppAssets.onboarding3,
      title: 'تابع أرباحك',
      description:
          'راقب المحفظة والمعاملات والسحوبات من داخل التطبيق بشكل منظم.',
    ),
  ];

  bool get isLastPage => currentPage.value == pages.length - 1;

  void onPageChanged(int index) {
    currentPage.value = index;
  }

  Future<void> next() async {
    if (isLastPage) {
      await finish();
      return;
    }

    await pageController.nextPage(
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOut,
    );
  }

  Future<void> finish() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.prefOnboardingCompleted, true);

    final route =
        AuthService.to.isAuthenticated ? AppRoutes.home : AppRoutes.login;
    await Get.offAllNamed(route);
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}

class OnboardingPageData {
  const OnboardingPageData({
    required this.image,
    required this.title,
    required this.description,
  });

  final String image;
  final String title;
  final String description;
}
