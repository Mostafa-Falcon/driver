import 'package:driver/app/data/repositories/auth_repository.dart';
import 'package:driver/core/utils/toast_utils.dart';
import 'package:driver/core/utils/validators.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordController extends GetxController {
  final AuthRepository _authRepository = AuthRepository();

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final RxBool isSubmitting = false.obs;

  String? validateEmail(String? value) => Validators.email(value);

  Future<void> sendResetLink() async {
    if (!formKey.currentState!.validate() || isSubmitting.value) return;

    isSubmitting.value = true;
    try {
      await _authRepository.sendPasswordResetEmail(
        emailController.text.trim().toLowerCase(),
      );
      ToastUtils.showSuccess('تم إرسال رابط إعادة تعيين كلمة المرور.');
      Get.back();
    } on FirebaseAuthException catch (e) {
      ToastUtils.showError(_errorMessage(e));
    } catch (_) {
      ToastUtils.showError('تعذر إرسال الرابط. حاول مرة أخرى.');
    } finally {
      isSubmitting.value = false;
    }
  }

  String _errorMessage(FirebaseAuthException e) {
    return switch (e.code) {
      'invalid-email' => 'البريد الإلكتروني غير صالح.',
      'user-not-found' => 'لا يوجد حساب بهذا البريد الإلكتروني.',
      'network-request-failed' => 'تحقق من اتصال الإنترنت وحاول مرة أخرى.',
      _ => 'تعذر إرسال الرابط. حاول مرة أخرى.',
    };
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}
