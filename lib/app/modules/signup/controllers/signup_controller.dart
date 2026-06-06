import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver/app/data/models/user_model.dart';
import 'package:driver/app/data/repositories/auth_repository.dart';
import 'package:driver/app/data/repositories/user_repository.dart';
import 'package:driver/app/routes/app_pages.dart';
import 'package:driver/app/services/auth_service.dart';
import 'package:driver/app/services/settings_service.dart';
import 'package:driver/core/utils/toast_utils.dart';
import 'package:driver/core/utils/validators.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupController extends GetxController {
  final AuthRepository _authRepository = AuthRepository();
  final UserRepository _userRepository = UserRepository();
  final AuthService _authService = AuthService.to;

  final formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final countryCodeController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final carNameController = TextEditingController();
  final carNumberController = TextEditingController();
  final vehicleTypeController = TextEditingController();

  final RxString signupType = 'email'.obs;
  final RxBool obscurePassword = true.obs;
  final RxBool obscureConfirmPassword = true.obs;
  final RxBool isSubmitting = false.obs;

  bool get isEmailSignup => signupType.value == 'email';

  @override
  void onInit() {
    super.onInit();
    _readArguments();
  }

  void _readArguments() {
    countryCodeController.text = SettingsService.to.defaultCountryCode;

    final args = Get.arguments;
    if (args is! Map) return;

    signupType.value = (args['type'] as String?) ?? 'email';
    countryCodeController.text =
        (args['countryCode'] as String?) ?? countryCodeController.text;
    phoneController.text = (args['phoneNumber'] as String?) ?? '';
    emailController.text = (args['email'] as String?) ?? '';
    firstNameController.text = (args['firstName'] as String?) ?? '';
    lastNameController.text = (args['lastName'] as String?) ?? '';
  }

  String? validateRequired(String? value, String fieldName) {
    return Validators.required(value, fieldName);
  }

  String? validateEmail(String? value) {
    if (!isEmailSignup && (value == null || value.trim().isEmpty)) return null;
    return Validators.email(value);
  }

  String? validatePhone(String? value) => Validators.phone(value);

  String? validatePassword(String? value) {
    if (!isEmailSignup) return null;
    return Validators.password(value);
  }

  String? validateConfirmPassword(String? value) {
    if (!isEmailSignup) return null;
    if (value != passwordController.text) return 'كلمتا المرور غير متطابقتين';
    return null;
  }

  Future<void> submit() async {
    if (!formKey.currentState!.validate() || isSubmitting.value) return;

    isSubmitting.value = true;
    try {
      final firebaseUser = await _resolveFirebaseUser();
      if (firebaseUser == null) {
        ToastUtils.showError('تعذر إنشاء حساب السائق.');
        return;
      }

      final user = _buildUser(firebaseUser.uid);
      final saved = await _userRepository.saveUser(user);
      if (!saved) {
        ToastUtils.showError('تعذر حفظ بيانات السائق.');
        return;
      }

      _authService.updateUserLocally(user);
      ToastUtils.showSuccess('تم إنشاء حساب السائق بنجاح');
      await Get.offAllNamed(AppRoutes.home);
    } on FirebaseAuthException catch (e) {
      ToastUtils.showError(_authErrorMessage(e));
    } catch (_) {
      ToastUtils.showError('تعذر إنشاء الحساب. حاول مرة أخرى.');
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<User?> _resolveFirebaseUser() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (!isEmailSignup) return currentUser;

    final credential = await _authRepository.createUserWithEmail(
      email: emailController.text.trim().toLowerCase(),
      password: passwordController.text.trim(),
    );

    return credential.user;
  }

  UserModel _buildUser(String uid) {
    return UserModel(
      id: uid,
      firstName: firstNameController.text.trim(),
      lastName: lastNameController.text.trim(),
      email: emailController.text.trim().toLowerCase(),
      countryCode: countryCodeController.text.trim(),
      phoneNumber: phoneController.text.trim(),
      role: 'driver',
      active: false,
      isActive: false,
      isDocumentVerify: false,
      createdAt: Timestamp.now(),
      walletAmount: 0,
      carName: carNameController.text.trim(),
      carNumber: carNumberController.text.trim(),
      vehicleType: vehicleTypeController.text.trim(),
      inProgressOrderID: const [],
      orderRequestData: const [],
      reviewsCount: '0',
      reviewsSum: '0',
    );
  }

  String _authErrorMessage(FirebaseAuthException e) {
    return switch (e.code) {
      'email-already-in-use' => 'هذا البريد مستخدم بالفعل.',
      'invalid-email' => 'البريد الإلكتروني غير صالح.',
      'weak-password' => 'كلمة المرور ضعيفة.',
      'network-request-failed' => 'تحقق من اتصال الإنترنت وحاول مرة أخرى.',
      _ => 'تعذر إنشاء الحساب. حاول مرة أخرى.',
    };
  }

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    countryCodeController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    carNameController.dispose();
    carNumberController.dispose();
    vehicleTypeController.dispose();
    super.onClose();
  }
}
