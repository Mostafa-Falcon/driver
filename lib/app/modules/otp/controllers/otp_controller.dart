import 'package:driver/app/routes/app_pages.dart';
import 'package:driver/app/services/auth_service.dart';
import 'package:driver/core/utils/toast_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OtpController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final AuthService _authService = AuthService.to;

  final codeController = TextEditingController();
  final RxString countryCode = ''.obs;
  final RxString phoneNumber = ''.obs;
  final RxString verificationId = ''.obs;
  final RxnInt resendToken = RxnInt();
  final RxBool isVerifying = false.obs;
  final RxBool isResending = false.obs;

  String get maskedPhone => '${countryCode.value} ${phoneNumber.value}';

  @override
  void onInit() {
    super.onInit();
    _readArguments();
  }

  void _readArguments() {
    final args = Get.arguments;
    if (args is! Map) return;

    countryCode.value = (args['countryCode'] as String?) ?? '';
    phoneNumber.value = (args['phoneNumber'] as String?) ?? '';
    verificationId.value = (args['verificationId'] as String?) ?? '';
    resendToken.value = args['resendToken'] as int?;
  }

  Future<void> verifyCode() async {
    final code = codeController.text.trim();
    if (code.length != 6 || isVerifying.value) {
      ToastUtils.showError('اكتب رمز تحقق صحيح من 6 أرقام.');
      return;
    }

    isVerifying.value = true;
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId.value,
        smsCode: code,
      );
      await _auth.signInWithCredential(credential);
      await _finishPhoneLogin();
    } on FirebaseAuthException catch (e) {
      ToastUtils.showError(_verificationErrorMessage(e));
    } catch (_) {
      ToastUtils.showError('تعذر التحقق من الرمز. حاول مرة أخرى.');
    } finally {
      isVerifying.value = false;
    }
  }

  Future<void> resendCode() async {
    if (isResending.value) return;

    isResending.value = true;
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: '${countryCode.value}${phoneNumber.value}',
        timeout: const Duration(seconds: 30),
        forceResendingToken: resendToken.value,
        verificationCompleted: (_) {},
        verificationFailed: (error) {
          ToastUtils.showError(_resendErrorMessage(error));
          isResending.value = false;
        },
        codeSent: (newVerificationId, newResendToken) {
          verificationId.value = newVerificationId;
          resendToken.value = newResendToken;
          ToastUtils.showSuccess('تم إرسال رمز جديد.');
          isResending.value = false;
        },
        codeAutoRetrievalTimeout: (_) {
          isResending.value = false;
        },
      );
    } catch (_) {
      isResending.value = false;
      ToastUtils.showError('تعذر إعادة إرسال الرمز. حاول مرة أخرى.');
    }
  }

  Future<void> _finishPhoneLogin() async {
    final user = await _authService.refreshCurrentUser();

    if (user == null) {
      await Get.offAllNamed(
        AppRoutes.signup,
        arguments: {
          'type': 'mobileNumber',
          'countryCode': countryCode.value,
          'phoneNumber': phoneNumber.value,
        },
      );
      return;
    }

    if ((user.role ?? '').toLowerCase() != 'driver') {
      await _authService.signOut();
      ToastUtils.showError('هذا الحساب غير مخصص للسائقين.');
      return;
    }

    ToastUtils.showSuccess('تم تسجيل الدخول بنجاح');
    await Get.offAllNamed(AppRoutes.home);
  }

  String _verificationErrorMessage(FirebaseAuthException error) {
    return switch (error.code) {
      'invalid-verification-code' => 'رمز التحقق غير صحيح.',
      'session-expired' => 'انتهت صلاحية الرمز. اطلب رمزًا جديدًا.',
      'network-request-failed' => 'تحقق من اتصال الإنترنت وحاول مرة أخرى.',
      _ => 'تعذر التحقق من الرمز. حاول مرة أخرى.',
    };
  }

  String _resendErrorMessage(FirebaseAuthException error) {
    return switch (error.code) {
      'too-many-requests' => 'تم إرسال طلبات كثيرة. حاول لاحقًا.',
      'invalid-phone-number' => 'رقم الهاتف غير صالح.',
      _ => 'تعذر إعادة إرسال الرمز. حاول مرة أخرى.',
    };
  }

  @override
  void onClose() {
    codeController.dispose();
    super.onClose();
  }
}
