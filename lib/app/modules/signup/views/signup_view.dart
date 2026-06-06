import 'package:driver/app/modules/signup/controllers/signup_controller.dart';
import 'package:driver/app/routes/app_pages.dart';
import 'package:driver/core/theme/app_colors.dart';
import 'package:driver/core/theme/app_text_styles.dart';
import 'package:driver/core/widgets/app_button.dart';
import 'package:driver/core/widgets/app_card.dart';
import 'package:driver/core/widgets/app_scaffold.dart';
import 'package:driver/core/widgets/app_text_field.dart';
import 'package:driver/core/widgets/section_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SignupView extends GetView<SignupController> {
  const SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'إنشاء حساب سائق',
      subtitle: 'أكمل البيانات الأساسية للانضمام إلى منظومة التوصيل',
      body: Form(
        key: controller.formKey,
        child: ListView(
          children: [
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SectionTitle(
                    title: 'البيانات الشخصية',
                    subtitle: 'اكتب بياناتك كما تظهر في ملف السائق.',
                  ),
                  SizedBox(height: 16.h),
                  Row(
                    children: [
                      Expanded(
                        child: AppTextField(
                          controller: controller.firstNameController,
                          hintText: 'الاسم الأول',
                          validator: (value) => controller.validateRequired(
                            value,
                            'الاسم الأول',
                          ),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: AppTextField(
                          controller: controller.lastNameController,
                          hintText: 'اسم العائلة',
                          validator: (value) => controller.validateRequired(
                            value,
                            'اسم العائلة',
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  AppTextField(
                    controller: controller.emailController,
                    hintText: 'البريد الإلكتروني',
                    keyboardType: TextInputType.emailAddress,
                    validator: controller.validateEmail,
                    prefixIcon: const Icon(Icons.mail_outline_rounded),
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 96.w,
                        child: AppTextField(
                          controller: controller.countryCodeController,
                          hintText: '+966',
                          keyboardType: TextInputType.phone,
                          validator: (value) => controller.validateRequired(
                            value,
                            'كود الدولة',
                          ),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: AppTextField(
                          controller: controller.phoneController,
                          hintText: 'رقم الهاتف',
                          keyboardType: TextInputType.phone,
                          validator: controller.validatePhone,
                          prefixIcon: const Icon(Icons.phone_outlined),
                        ),
                      ),
                    ],
                  ),
                  Obx(
                    () {
                      if (!controller.isEmailSignup) {
                        return const SizedBox.shrink();
                      }

                      return Column(
                        children: [
                          SizedBox(height: 12.h),
                          AppTextField(
                            controller: controller.passwordController,
                            hintText: 'كلمة المرور',
                            obscureText: controller.obscurePassword.value,
                            validator: controller.validatePassword,
                            prefixIcon: const Icon(Icons.lock_outline_rounded),
                            suffixIcon: IconButton(
                              onPressed: () =>
                                  controller.obscurePassword.toggle(),
                              icon: Icon(
                                controller.obscurePassword.value
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                              ),
                            ),
                          ),
                          SizedBox(height: 12.h),
                          AppTextField(
                            controller: controller.confirmPasswordController,
                            hintText: 'تأكيد كلمة المرور',
                            obscureText:
                                controller.obscureConfirmPassword.value,
                            validator: controller.validateConfirmPassword,
                            prefixIcon: const Icon(Icons.lock_outline_rounded),
                            suffixIcon: IconButton(
                              onPressed: () =>
                                  controller.obscureConfirmPassword.toggle(),
                              icon: Icon(
                                controller.obscureConfirmPassword.value
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 12.h),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SectionTitle(
                    title: 'بيانات المركبة',
                    subtitle: 'يمكن تعديلها لاحقًا من ملف السائق.',
                  ),
                  SizedBox(height: 16.h),
                  AppTextField(
                    controller: controller.vehicleTypeController,
                    hintText: 'نوع المركبة',
                    prefixIcon: const Icon(Icons.local_shipping_outlined),
                  ),
                  SizedBox(height: 12.h),
                  AppTextField(
                    controller: controller.carNameController,
                    hintText: 'اسم أو موديل المركبة',
                    prefixIcon: const Icon(Icons.directions_car_outlined),
                  ),
                  SizedBox(height: 12.h),
                  AppTextField(
                    controller: controller.carNumberController,
                    hintText: 'رقم اللوحة',
                    prefixIcon: const Icon(Icons.confirmation_number_outlined),
                  ),
                ],
              ),
            ),
            SizedBox(height: 18.h),
            Obx(
              () => AppButton(
                label: 'إنشاء الحساب',
                onPressed: controller.submit,
                isLoading: controller.isSubmitting.value,
                icon: const Icon(Icons.person_add_rounded, color: Colors.white),
              ),
            ),
            SizedBox(height: 10.h),
            TextButton(
              onPressed: () => Get.offAllNamed(AppRoutes.login),
              child: Text(
                'لديك حساب بالفعل؟ تسجيل الدخول',
                style: AppTextStyles.bodyMedium(color: AppColors.primary),
              ),
            ),
          ].animate(interval: 45.ms).fadeIn(duration: 220.ms).slideY(
                begin: 0.03,
                end: 0,
                curve: Curves.easeOut,
              ),
        ),
      ),
    );
  }
}
