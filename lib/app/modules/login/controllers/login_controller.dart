import 'package:driver/app/data/repositories/auth_repository.dart';
import 'package:driver/app/routes/app_pages.dart';
import 'package:driver/app/services/auth_service.dart';
import 'package:driver/core/utils/toast_utils.dart';
import 'package:driver/core/utils/validators.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final AuthRepository _authRepository = AuthRepository();
  final AuthService _authService = AuthService.to;

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final RxBool obscurePassword = true.obs;
  final RxBool isEmailLoading = false.obs;
  final RxBool isGoogleLoading = false.obs;
  final RxBool isAppleLoading = false.obs;

  bool get isBusy =>
      isEmailLoading.value || isGoogleLoading.value || isAppleLoading.value;

  Future<void> loginWithEmailAndPassword() async {
    if (!formKey.currentState!.validate()) return;

    await _runAuthAction(
      loading: isEmailLoading,
      signupType: 'email',
      action: () => _authRepository.loginWithEmail(
        email: emailController.text.trim().toLowerCase(),
        password: passwordController.text.trim(),
      ),
    );
  }

  Future<void> loginWithGoogle() async {
    await _runAuthAction(
      loading: isGoogleLoading,
      signupType: 'google',
      action: _authRepository.signInWithGoogle,
    );
  }

  Future<void> loginWithApple() async {
    await _runAuthAction(
      loading: isAppleLoading,
      signupType: 'apple',
      action: _authRepository.signInWithApple,
    );
  }

  String? validateEmail(String? value) => Validators.email(value);

  String? validatePassword(String? value) => Validators.password(value);

  Future<void> _runAuthAction({
    required RxBool loading,
    required String signupType,
    required Future<UserCredential> Function() action,
  }) async {
    if (loading.value) return;

    loading.value = true;
    try {
      final credential = await action();
      if (credential.user == null) {
        ToastUtils.showError('لم يتم العثور على بيانات المستخدم.');
        return;
      }

      await _finishLogin(credential, signupType);
    } on FirebaseAuthException catch (e) {
      ToastUtils.showError(_authErrorMessage(e));
    } catch (e) {
      ToastUtils.showError('تعذر تسجيل الدخول: $e');
    } finally {
      loading.value = false;
    }
  }

  Future<void> _finishLogin(
    UserCredential credential,
    String signupType,
  ) async {
    final user = await _authService.refreshCurrentUser();

    if (user == null) {
      if (signupType == 'email') {
        await _authService.signOut();
        ToastUtils.showError('حساب السائق غير موجود. تواصل مع الإدارة.');
        return;
      }

      final firebaseUser = credential.user;
      final displayNameParts = (firebaseUser?.displayName ?? '').split(' ');
      await Get.offAllNamed(
        AppRoutes.signup,
        arguments: {
          'type': signupType,
          'email': firebaseUser?.email ?? '',
          'firstName':
              displayNameParts.isNotEmpty ? displayNameParts.first : '',
          'lastName': displayNameParts.length > 1
              ? displayNameParts.sublist(1).join(' ')
              : '',
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

  String _authErrorMessage(FirebaseAuthException e) {
    return switch (e.code) {
      'invalid-email' => 'البريد الإلكتروني غير صالح.',
      'user-disabled' => 'تم تعطيل هذا الحساب. تواصل مع الإدارة.',
      'user-not-found' => 'لا يوجد حساب بهذا البريد الإلكتروني.',
      'wrong-password' => 'كلمة المرور غير صحيحة.',
      'invalid-credential' => 'بيانات الدخول غير صحيحة.',
      'network-request-failed' => 'تحقق من اتصال الإنترنت وحاول مرة أخرى.',
      'sign-in-cancelled' => 'تم إلغاء عملية تسجيل الدخول.',
      _ => 'فشل تسجيل الدخول: ${e.message ?? e.code}',
    };
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
