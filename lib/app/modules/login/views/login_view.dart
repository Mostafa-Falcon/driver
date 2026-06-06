import 'dart:io';

import 'package:driver/app/modules/login/controllers/login_controller.dart';
import 'package:driver/app/routes/app_pages.dart';
import 'package:driver/core/constants/app_assets.dart';
import 'package:driver/core/theme/app_colors.dart';
import 'package:driver/core/theme/app_text_styles.dart';
import 'package:driver/core/widgets/app_brand_mark.dart';
import 'package:driver/core/widgets/app_button.dart';
import 'package:driver/core/widgets/app_card.dart';
import 'package:driver/core/widgets/app_scaffold.dart';
import 'package:driver/core/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      useSafeArea: true,
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 420.w),
            child: AppCard(
              padding: EdgeInsets.all(24.r),
              child: Form(
                key: controller.formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const AppBrandMark(
                      size: 92,
                      assetPath: AppAssets.appLogo,
                    ),
                    SizedBox(height: 20.h),
                    Text(
                      'تسجيل الدخول',
                      style: AppTextStyles.h2(),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'ادخل بحساب السائق لإدارة الطلبات والمحفظة.',
                      style: AppTextStyles.body(color: AppColors.grey500),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 22.h),
                    AppTextField(
                      controller: controller.emailController,
                      hintText: 'البريد الإلكتروني',
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      validator: controller.validateEmail,
                      prefixIcon: const Icon(Icons.mail_outline_rounded),
                    ),
                    SizedBox(height: 12.h),
                    Obx(
                      () => AppTextField(
                        controller: controller.passwordController,
                        hintText: 'كلمة المرور',
                        obscureText: controller.obscurePassword.value,
                        textInputAction: TextInputAction.done,
                        validator: controller.validatePassword,
                        prefixIcon: const Icon(Icons.lock_outline_rounded),
                        suffixIcon: IconButton(
                          onPressed: () => controller.obscurePassword.toggle(),
                          icon: Icon(
                            controller.obscurePassword.value
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                          ),
                        ),
                        onSubmitted: (_) =>
                            controller.loginWithEmailAndPassword(),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: TextButton(
                        onPressed: () => Get.toNamed(
                          AppRoutes.forgotPassword,
                        ),
                        child: const Text('نسيت كلمة المرور؟'),
                      ),
                    ),
                    SizedBox(height: 18.h),
                    Obx(
                      () => AppButton(
                        label: 'دخول',
                        onPressed: controller.isBusy
                            ? null
                            : controller.loginWithEmailAndPassword,
                        isLoading: controller.isEmailLoading.value,
                        icon: const Icon(
                          Icons.login_rounded,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 14.h),
                    const _DividerLabel(label: 'أو'),
                    SizedBox(height: 14.h),
                    Obx(
                      () => AppButton(
                        label: 'الدخول بحساب Google',
                        onPressed: controller.isBusy
                            ? null
                            : controller.loginWithGoogle,
                        isLoading: controller.isGoogleLoading.value,
                        isOutlined: true,
                        icon: const Icon(
                          Icons.g_mobiledata_rounded,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    AppButton(
                      label: 'الدخول برقم الهاتف',
                      onPressed: () => Get.toNamed(AppRoutes.phoneNumber),
                      isOutlined: true,
                      icon: const Icon(
                        Icons.phone_android_rounded,
                        color: AppColors.primary,
                      ),
                    ),
                    if (Platform.isIOS) ...[
                      SizedBox(height: 10.h),
                      Obx(
                        () => AppButton(
                          label: 'الدخول بحساب Apple',
                          onPressed: controller.isBusy
                              ? null
                              : controller.loginWithApple,
                          isLoading: controller.isAppleLoading.value,
                          isOutlined: true,
                          icon: const Icon(
                            Icons.apple_rounded,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                    SizedBox(height: 14.h),
                    TextButton(
                      onPressed: () => Get.toNamed(AppRoutes.signup),
                      child: Text(
                        'ليس لديك حساب؟ إنشاء حساب سائق',
                        style: AppTextStyles.bodyMedium(
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
                .animate()
                .fadeIn(duration: 300.ms)
                .slideY(begin: 0.06, end: 0, curve: Curves.easeOutCubic),
          ),
        ),
      ),
    );
  }
}

class _DividerLabel extends StatelessWidget {
  const _DividerLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider()),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Text(
            label,
            style: AppTextStyles.captionMedium(color: AppColors.grey400),
          ),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }
}
