import 'package:driver/app/modules/profile/controllers/profile_controller.dart';
import 'package:driver/app/modules/profile/views/widgets/profile_menu_item.dart';
import 'package:driver/app/modules/profile/views/widgets/profile_sheets.dart';
import 'package:driver/app/routes/app_pages.dart';
import 'package:driver/core/theme/app_colors.dart';
import 'package:driver/core/widgets/reusables/reusable_switch.dart';
import 'package:driver/core/widgets/reusables/reusable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class GeneralSettingsSection extends StatelessWidget {
  const GeneralSettingsSection({super.key, required this.controller});

  final ProfileController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 6.h),
          child: const ReusableText.bodySemiBold(
            text: 'الإعدادات والدعم',
            color: AppColors.grey500,
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardTheme.color,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: (Theme.of(context).dividerTheme.color ?? AppColors.grey200)
                  .withValues(alpha: 0.5),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.015),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              ProfileMenuItem(
                icon: Icons.language_rounded,
                title: 'اللغة',
                iconColor: const Color(0xFF42A5F5),
                iconBgColor: const Color(0xFF42A5F5).withValues(alpha: 0.08),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const ReusableText.bodyMedium(
                      text: 'العربية',
                      color: AppColors.grey500,
                    ),
                    SizedBox(width: 4.w),
                    Icon(
                      Icons.chevron_left_rounded,
                      color: AppColors.grey400,
                      size: 20.r,
                    ),
                  ],
                ),
                onTap: () => _showLanguageSelector(context),
              ),
              ProfileMenuItem(
                icon: Icons.dark_mode_outlined,
                title: 'الوضع الليلي',
                iconColor: const Color(0xFFFFA726),
                iconBgColor: const Color(0xFFFFA726).withValues(alpha: 0.08),
                trailing: Obx(
                  () => ReusableSwitch(
                    value: controller.isDark.value,
                    onChanged: controller.toggleTheme,
                    width: 42.w,
                    height: 22.h,
                    activeColor: AppColors.primary,
                    inactiveColor: AppColors.grey300,
                  ),
                ),
                onTap: () {
                  controller.toggleTheme(!controller.isDark.value);
                },
              ),
              ProfileMenuItem(
                icon: Icons.info_outline_rounded,
                title: 'من نحن',
                iconColor: const Color(0xFF26A69A),
                iconBgColor: const Color(0xFF26A69A).withValues(alpha: 0.08),
                onTap: () => _showAboutUsSheet(context),
              ),
              ProfileMenuItem(
                icon: Icons.support_agent_rounded,
                title: 'تواصل مع الدعم',
                iconColor: const Color(0xFFEC407A),
                iconBgColor: const Color(0xFFEC407A).withValues(alpha: 0.08),
                onTap: () => Get.toNamed(AppRoutes.support),
              ),
              ProfileMenuItem(
                icon: Icons.help_outline_rounded,
                title: 'الأسئلة الشائعة',
                iconColor: const Color(0xFF78909C),
                iconBgColor: const Color(0xFF78909C).withValues(alpha: 0.08),
                onTap: () => _showFaqSheet(context),
              ),
              ProfileMenuItem(
                icon: Icons.description_outlined,
                title: 'الشروط والأحكام',
                iconColor: const Color(0xFFAB47BC),
                iconBgColor: const Color(0xFFAB47BC).withValues(alpha: 0.08),
                onTap: () => _showTermsSheet(context),
              ),
              ProfileMenuItem(
                icon: Icons.shield_outlined,
                title: 'سياسة الخصوصية',
                iconColor: const Color(0xFF26C6DA),
                iconBgColor: const Color(0xFF26C6DA).withValues(alpha: 0.08),
                showDivider: false,
                onTap: () => _showPrivacySheet(context),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showAboutUsSheet(BuildContext context) {
    Get.bottomSheet(
      const InfoSheet(
        title: 'من نحن',
        content:
            'تطبيق المندوب هو شريكك الموثوق لتوصيل الطلبات بسرعة وأمان. نسعى دائماً لتقديم أفضل تجربة تشغيلية وزيادة أرباحك اليومية من خلال واجهة ذكية وعمليات سلسة.',
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  void _showFaqSheet(BuildContext context) {
    Get.bottomSheet(
      const FaqSheet(),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  void _showTermsSheet(BuildContext context) {
    Get.bottomSheet(
      const InfoSheet(
        title: 'الشروط والأحكام',
        content:
            'باستخدامك لتطبيق المندوب، فإنك توافق على الالتزام بكافة الشروط والأحكام الخاصة بالتقديم والتوصيل. يجب الحفاظ على سرية الحساب وتجنب أي سلوك يضر بالمنصة أو العملاء. يحق للإدارة تعليق الحساب في حال مخالفة التعليمات.',
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  void _showPrivacySheet(BuildContext context) {
    Get.bottomSheet(
      const InfoSheet(
        title: 'سياسة الخصوصية',
        content:
            'نحن ملتزمون بحماية بياناتك الشخصية وموقعك الجغرافي. يتم جمع بيانات الموقع في الخلفية لتمكين التتبع الدقيق للطلبات وضمان سلامة الشحنات. لا نشارك بياناتك مع أي طرف ثالث دون موافقتك الصريحة.',
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  void _showLanguageSelector(BuildContext context) {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40.w,
                height: 5.h,
                decoration: BoxDecoration(
                  color: AppColors.grey300,
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
            ),
            SizedBox(height: 18.h),
            const ReusableText.bodySemiBold(
              text: 'اختر لغة التطبيق',
              fontSize: 16,
            ),
            SizedBox(height: 16.h),
            ListTile(
              leading:
                  const Icon(Icons.check_rounded, color: AppColors.primary),
              title: const ReusableText.bodySemiBold(text: 'العربية'),
              onTap: () => Get.back(),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const SizedBox(width: 24),
              title: const ReusableText.bodyMedium(
                text: 'English (قريباً)',
                color: AppColors.grey400,
              ),
              onTap: () {
                Get.back();
                Get.snackbar(
                  'اللغة',
                  'سيتم إتاحة اللغة الإنجليزية في التحديث القادم',
                );
              },
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
    );
  }
}
