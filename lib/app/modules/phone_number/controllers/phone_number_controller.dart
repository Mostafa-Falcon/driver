import 'package:driver/app/routes/app_pages.dart';
import 'package:driver/app/services/settings_service.dart';
import 'package:driver/core/utils/toast_utils.dart';
import 'package:driver/core/utils/validators.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PhoneNumberController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final formKey = GlobalKey<FormState>();
  final countryCodeController = TextEditingController();
  final phoneController = TextEditingController();
  final RxBool isSending = false.obs;

  @override
  void onInit() {
    super.onInit();
    countryCodeController.text = SettingsService.to.defaultCountryCode;
  }

  String? validateCountryCode(String? value) {
    if (value == null || value.trim().isEmpty) return 'كود الدولة مطلوب';
    if (!value.trim().startsWith('+')) return 'اكتب كود الدولة بهذا الشكل +966';
    return null;
  }

  String? validatePhone(String? value) => Validators.phone(value);

  Future<void> sendCode() async {
    if (!formKey.currentState!.validate() || isSending.value) return;

    isSending.value = true;
    final countryCode = countryCodeController.text.trim();
    final phoneNumber = phoneController.text.trim();
    final fullPhoneNumber = '$countryCode$phoneNumber';

    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: fullPhoneNumber,
        timeout: const Duration(seconds: 30),
        verificationCompleted: (_) {},
        verificationFailed: (error) {
          isSending.value = false;
          ToastUtils.showError(_phoneErrorMessage(error));
        },
        codeSent: (verificationId, resendToken) {
          isSending.value = false;
          Get.toNamed(
            AppRoutes.otp,
            arguments: {
              'countryCode': countryCode,
              'phoneNumber': phoneNumber,
              'verificationId': verificationId,
              'resendToken': resendToken,
            },
          );
        },
        codeAutoRetrievalTimeout: (_) {
          isSending.value = false;
        },
      );
    } catch (_) {
      isSending.value = false;
      ToastUtils.showError('تعذر إرسال رمز التحقق. حاول مرة أخرى.');
    }
  }

  String _phoneErrorMessage(FirebaseAuthException error) {
    return switch (error.code) {
      'invalid-phone-number' => 'رقم الهاتف غير صالح.',
      'too-many-requests' => 'تم إرسال طلبات كثيرة. حاول لاحقًا.',
      'network-request-failed' => 'تحقق من اتصال الإنترنت وحاول مرة أخرى.',
      _ => 'فشل إرسال رمز التحقق. حاول مرة أخرى.',
    };
  }

  @override
  void onClose() {
    countryCodeController.dispose();
    phoneController.dispose();
    super.onClose();
  }
}
