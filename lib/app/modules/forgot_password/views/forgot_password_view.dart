import 'package:driver/app/modules/forgot_password/controllers/forgot_password_controller.dart';
import 'package:driver/core/theme/app_colors.dart';
import 'package:driver/core/theme/app_text_styles.dart';
import 'package:driver/core/widgets/app_button.dart';
import 'package:driver/core/widgets/app_card.dart';
import 'package:driver/core/widgets/app_scaffold.dart';
import 'package:driver/core/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ForgotPasswordView extends GetView<ForgotPasswordController> {
  const ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'استعادة كلمة المرور',
      subtitle: 'سنرسل رابط إعادة التعيين إلى بريدك',
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 420.w),
          child: AppCard(
            padding: EdgeInsets.all(22.r),
            child: Form(
              key: controller.formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.lock_reset_rounded,
                    size: 54.r,
                    color: AppColors.primary,
                  ),
                  SizedBox(height: 14.h),
                  Text(
                    'نسيت كلمة المرور؟',
                    style: AppTextStyles.h2(),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'اكتب بريدك الإلكتروني وسنرسل لك رابطًا آمنًا لتعيين كلمة مرور جديدة.',
                    style: AppTextStyles.body(color: AppColors.grey500),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20.h),
                  AppTextField(
                    controller: controller.emailController,
                    hintText: 'البريد الإلكتروني',
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.done,
                    validator: controller.validateEmail,
                    prefixIcon: const Icon(Icons.mail_outline_rounded),
                    onSubmitted: (_) => controller.sendResetLink(),
                  ),
                  SizedBox(height: 18.h),
                  Obx(
                    () => AppButton(
                      label: 'إرسال الرابط',
                      onPressed: controller.sendResetLink,
                      isLoading: controller.isSubmitting.value,
                      icon: const Icon(Icons.send_rounded, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          )
              .animate()
              .fadeIn(duration: 240.ms)
              .slideY(begin: 0.04, end: 0, curve: Curves.easeOut),
        ),
      ),
    );
  }
}
