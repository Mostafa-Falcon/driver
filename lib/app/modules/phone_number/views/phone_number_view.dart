import 'package:driver/app/modules/phone_number/controllers/phone_number_controller.dart';
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

class PhoneNumberView extends GetView<PhoneNumberController> {
  const PhoneNumberView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'الدخول برقم الهاتف',
      subtitle: 'سنرسل رمز تحقق قصير إلى هاتفك',
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
                    Icons.phone_android_rounded,
                    size: 54.r,
                    color: AppColors.primary,
                  ),
                  SizedBox(height: 14.h),
                  Text(
                    'رقم الهاتف',
                    style: AppTextStyles.h2(),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'اكتب رقم الهاتف المرتبط بحساب السائق.',
                    style: AppTextStyles.body(color: AppColors.grey500),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 96.w,
                        child: AppTextField(
                          controller: controller.countryCodeController,
                          hintText: '+966',
                          keyboardType: TextInputType.phone,
                          validator: controller.validateCountryCode,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: AppTextField(
                          controller: controller.phoneController,
                          hintText: 'رقم الهاتف',
                          keyboardType: TextInputType.phone,
                          textInputAction: TextInputAction.done,
                          validator: controller.validatePhone,
                          prefixIcon: const Icon(Icons.phone_outlined),
                          onSubmitted: (_) => controller.sendCode(),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 18.h),
                  Obx(
                    () => AppButton(
                      label: 'إرسال رمز التحقق',
                      onPressed: controller.sendCode,
                      isLoading: controller.isSending.value,
                      icon: const Icon(Icons.sms_rounded, color: Colors.white),
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
