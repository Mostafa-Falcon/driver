import 'package:driver/app/modules/profile/controllers/profile_controller.dart';
import 'package:driver/app/modules/profile/views/widgets/profile_menu_item.dart';
import 'package:driver/app/modules/profile/views/widgets/profile_section_card.dart';
import 'package:driver/app/modules/profile/views/widgets/profile_sheets.dart';
import 'package:driver/app/routes/app_pages.dart';
import 'package:driver/app/services/localization_service.dart';
import 'package:driver/core/theme/app_colors.dart';
import 'package:driver/core/widgets/reusables/reusable_switch.dart';
import 'package:driver/core/widgets/reusables/reusable_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart' hide Trans;

class GeneralSettingsSection extends StatelessWidget {
  const GeneralSettingsSection({super.key, required this.controller});

  final ProfileController controller;

  @override
  Widget build(BuildContext context) {
    final iconColor = Theme.of(context).brightness == Brightness.dark
        ? AppColors.greyDark600
        : AppColors.grey600;

    return ProfileSectionCard(
      title: 'profile.settings_support'.tr(),
      children: [
        ProfileMenuItem(
          icon: Icons.language_rounded,
          title: 'profile.language'.tr(),
          iconColor: iconColor,
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ReusableText.bodyMedium(
                text: LocalizationService.languageFromCode(
                  context.locale.languageCode,
                ).nativeName,
                color: AppColors.grey500,
              ),
              SizedBox(width: 4.w),
              Icon(
                Icons.chevron_left_rounded,
                color: AppColors.grey500,
                size: 20.r,
              ),
            ],
          ),
          onTap: () => _showLanguageSelector(context),
        ),
        ProfileMenuItem(
          icon: Icons.dark_mode_outlined,
          title: 'profile.dark_mode'.tr(),
          iconColor: iconColor,
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
          title: 'profile.about_us'.tr(),
          iconColor: iconColor,
          onTap: () => _showAboutUsSheet(context),
        ),
        ProfileMenuItem(
          icon: Icons.support_agent_rounded,
          title: 'profile.contact_support'.tr(),
          iconColor: iconColor,
          onTap: () => Get.toNamed(AppRoutes.support),
        ),
        ProfileMenuItem(
          icon: Icons.help_outline_rounded,
          title: 'profile.faq'.tr(),
          iconColor: iconColor,
          onTap: () => _showFaqSheet(context),
        ),
        ProfileMenuItem(
          icon: Icons.description_outlined,
          title: 'profile.terms'.tr(),
          iconColor: iconColor,
          onTap: () => _showTermsSheet(context),
        ),
        ProfileMenuItem(
          icon: Icons.shield_outlined,
          title: 'profile.privacy'.tr(),
          iconColor: iconColor,
          showDivider: false,
          onTap: () => _showPrivacySheet(context),
        ),
      ],
    );
  }

  void _showAboutUsSheet(BuildContext context) {
    Get.bottomSheet(
      const InfoSheet(
        title: 'profile.about_us',
        content: 'profile.about_content',
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
        title: 'profile.terms',
        content: 'profile.terms_content',
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  void _showPrivacySheet(BuildContext context) {
    Get.bottomSheet(
      const InfoSheet(
        title: 'profile.privacy',
        content: 'profile.privacy_content',
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
            ReusableText.bodySemiBold(
              text: 'profile.choose_language'.tr(),
              fontSize: 16,
            ),
            SizedBox(height: 16.h),
            ...LocalizationService.supportedLanguages.map(
              (language) => Column(
                children: [
                  ListTile(
                    leading: Icon(
                      context.locale.languageCode == language.code
                          ? Icons.check_rounded
                          : Icons.language_rounded,
                      color: language.isFullyTranslated
                          ? AppColors.primary
                          : AppColors.grey400,
                    ),
                    title: ReusableText.bodySemiBold(
                      text: language.nativeName,
                      color:
                          language.isFullyTranslated ? null : AppColors.grey400,
                    ),
                    subtitle: language.isFullyTranslated
                        ? null
                        : ReusableText.caption(
                            text: 'common.soon'.tr(),
                            color: AppColors.grey400,
                          ),
                    onTap: () async {
                      if (!language.isFullyTranslated) {
                        Get.snackbar(
                          'profile.language'.tr(),
                          'profile.language_available_later'.tr(),
                        );
                        return;
                      }

                      await context.setLocale(language.locale);
                      Get.back();
                    },
                  ),
                  const Divider(height: 1),
                ],
              ),
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
    );
  }
}
