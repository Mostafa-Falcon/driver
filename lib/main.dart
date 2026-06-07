import 'package:driver/app/routes/app_pages.dart';
import 'package:driver/app/services/auth_service.dart';
import 'package:driver/app/services/localization_service.dart';
import 'package:driver/app/services/notification_alarm_service.dart';
import 'package:driver/app/services/settings_service.dart';
import 'package:driver/app/services/theme_service.dart';
import 'package:driver/core/constants/app_strings.dart';
import 'package:driver/core/theme/app_theme.dart';
import 'package:driver/firebase_options.dart';
import 'package:easy_localization/easy_localization.dart' as easy;
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await easy.EasyLocalization.ensureInitialized();
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseAppCheck.instance.activate(
    providerAndroid: kDebugMode
        ? const AndroidDebugProvider()
        : const AndroidPlayIntegrityProvider(),
    providerApple: kDebugMode
        ? const AppleDebugProvider()
        : const AppleAppAttestProvider(),
  );

  final prefs = await SharedPreferences.getInstance();
  final isDarkTheme = prefs.getBool('isDarkMode') ?? false;
  final savedLocale = prefs.getString('locale')?.split('_').first;
  final startLocale = savedLocale == null
      ? LocalizationService.fallbackLocale
      : LocalizationService.languageFromCode(savedLocale).locale;

  await _registerServices(isDarkTheme);
  _configureEasyLoading();

  runApp(
    easy.EasyLocalization(
      supportedLocales: LocalizationService.supportedLocales,
      path: LocalizationService.translationsPath,
      fallbackLocale: LocalizationService.fallbackLocale,
      startLocale: startLocale,
      useOnlyLangCode: true,
      useFallbackTranslations: true,
      useFallbackTranslationsForEmptyResources: true,
      child: const DriverApp(),
    ),
  );
}

Future<void> _registerServices(bool isDarkTheme) async {
  await Get.putAsync<SettingsService>(
    () async {
      final service = SettingsService();
      await service.onInit();
      return service;
    },
    permanent: true,
  );

  Get.put<AuthService>(AuthService(), permanent: true);
  Get.put<ThemeService>(ThemeService(isDarkTheme), permanent: true);
  Get.put<NotificationAlarmService>(
    NotificationAlarmService(),
    permanent: true,
  );
}

void _configureEasyLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.custom
    ..backgroundColor = Colors.black87
    ..indicatorColor = const Color(0xFF1E955E)
    ..textColor = Colors.white
    ..maskColor = Colors.black.withValues(alpha: 0.4)
    ..userInteractions = false
    ..dismissOnTap = false;
}

class DriverApp extends StatelessWidget {
  const DriverApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, _) {
        return GetMaterialApp(
          title: AppStrings.appTitle,
          debugShowCheckedModeBanner: false,
          localizationsDelegates: LocalizationService.delegates(context),
          supportedLocales:
              LocalizationService.contextSupportedLocales(context),
          locale: LocalizationService.currentLocale(context),
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          themeMode: ThemeService.to.isDark ? ThemeMode.dark : ThemeMode.light,
          initialRoute: AppPages.initial,
          getPages: AppPages.routes,
          defaultTransition: Transition.fadeIn,
          builder: EasyLoading.init(
            builder: (context, child) => Directionality(
              textDirection:
                  LocalizationService.currentLocale(context).languageCode ==
                          'ar'
                      ? TextDirection.rtl
                      : TextDirection.ltr,
              child: child ?? const SizedBox.shrink(),
            ),
          ),
        );
      },
    );
  }
}
