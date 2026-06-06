import 'package:driver/app/modules/otp/controllers/otp_controller.dart';
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

class OtpView extends GetView<OtpController> {
  const OtpView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'رمز التحقق',
      subtitle: 'أدخل الرمز المرسل إلى هاتفك',
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 420.w),
          child: AppCard(
            padding: EdgeInsets.all(22.r),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.verified_user_outlined,
                  size: 54.r,
                  color: AppColors.primary,
                ),
                SizedBox(height: 14.h),
                Text(
                  'تحقق من رقم الهاتف',
                  style: AppTextStyles.h2(),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8.h),
                Obx(
                  () => Text(
                    'تم إرسال رمز التحقق إلى ${controller.maskedPhone}',
                    style: AppTextStyles.body(color: AppColors.grey500),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 22.h),
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: AppTextField(
                    controller: controller.codeController,
                    hintText: '000000',
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    maxLength: 6,
                    prefixIcon: const Icon(Icons.pin_rounded),
                    onSubmitted: (_) => controller.verifyCode(),
                  ),
                ),
                SizedBox(height: 18.h),
                Obx(
                  () => AppButton(
                    label: 'تأكيد الرمز',
                    onPressed: controller.verifyCode,
                    isLoading: controller.isVerifying.value,
                    icon: const Icon(Icons.check_rounded, color: Colors.white),
                  ),
                ),
                SizedBox(height: 10.h),
                Obx(
                  () => TextButton(
                    onPressed: controller.isResending.value
                        ? null
                        : controller.resendCode,
                    child: Text(
                      controller.isResending.value
                          ? 'جاري إرسال رمز جديد...'
                          : 'إعادة إرسال الرمز',
                    ),
                  ),
                ),
              ],
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
