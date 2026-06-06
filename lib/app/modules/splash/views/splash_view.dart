import 'package:driver/app/modules/splash/controllers/splash_controller.dart';
import 'package:driver/app/modules/splash/views/widgets/splash_background.dart';
import 'package:driver/app/modules/splash/views/widgets/splash_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  static const _systemUiStyle = SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarDividerColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarIconBrightness: Brightness.light,
  );

  @override
  Widget build(BuildContext context) {
    return const AnnotatedRegion<SystemUiOverlayStyle>(
      value: _systemUiStyle,
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        body: SplashBackground(
          child: SplashContent(),
        ),
      ),
    );
  }
}
