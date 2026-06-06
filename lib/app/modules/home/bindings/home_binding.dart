import 'package:driver/app/modules/home/controllers/home_controller.dart';
import 'package:driver/app/services/auth_service.dart';
import 'package:driver/app/services/settings_service.dart';
import 'package:get/get.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    // التأكد من وجود الخدمات العامة
    if (!Get.isRegistered<AuthService>()) {
      Get.put(AuthService(), permanent: true);
    }
    if (!Get.isRegistered<SettingsService>()) {
      Get.put(SettingsService(), permanent: true);
    }

    Get.lazyPut<HomeController>(() => HomeController());
  }
}
