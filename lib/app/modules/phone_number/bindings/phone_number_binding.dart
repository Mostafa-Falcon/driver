import 'package:driver/app/modules/phone_number/controllers/phone_number_controller.dart';
import 'package:get/get.dart';

class PhoneNumberBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PhoneNumberController>(() => PhoneNumberController());
  }
}
