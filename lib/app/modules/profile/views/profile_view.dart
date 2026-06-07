import 'package:driver/app/modules/profile/controllers/profile_controller.dart';
import 'package:driver/app/modules/profile/views/widgets/account_settings_section.dart';
import 'package:driver/app/modules/profile/views/widgets/general_settings_section.dart';
import 'package:driver/app/routes/app_pages.dart';
import 'package:driver/app/services/settings_service.dart';
import 'package:driver/core/theme/app_colors.dart';
import 'package:driver/core/widgets/app_button.dart';
import 'package:driver/core/widgets/app_scaffold.dart';
import 'package:driver/core/widgets/driver_header.dart';
import 'package:driver/core/widgets/reusables/reusable_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart' hide Trans;

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AppScaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.surface,
      body: Obx(
        () => ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            DriverHeader(
              profilePictureUrl: controller.auth.user?.profilePictureURL,
              username: controller.auth.user?.fullName.isNotEmpty == true
                  ? controller.auth.user!.fullName
                  : 'driver.default_name'.tr(),
              isVerified: controller.auth.user?.isDocumentVerify == true,
              isOnline: controller.isOnline.value,
              onToggleOnline: controller.toggleOnlineStatus,
              notificationCount: controller.unreadNotificationsCount.value,
              onTapNotification: () => Get.toNamed(AppRoutes.notifications),
            ),
            SizedBox(height: 18.h),
            AccountSettingsSection(controller: controller),
            SizedBox(height: 20.h),
            GeneralSettingsSection(controller: controller),
            SizedBox(height: 24.h),
            AppButton(
              label: 'profile.logout'.tr(),
              onPressed: () => _showLogoutDialog(context),
              isOutlined: true,
              backgroundColor: AppColors.danger,
              textColor: AppColors.danger,
              icon: const Icon(
                Icons.logout_rounded,
                color: AppColors.danger,
              ),
            ),
            SizedBox(height: 10.h),
            Center(
              child: ReusableText.captionMedium(
                text:
                    '${'common.version_prefix'.tr()} ${SettingsService.to.effectiveAppVersion}',
                color: AppColors.grey500,
              ),
            ),
            SizedBox(height: 96.h),
          ],
        ).animate().fadeIn(duration: 220.ms).slideY(
              begin: 0.03,
              end: 0,
              curve: Curves.easeOut,
            ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: ReusableText.bodySemiBold(
          text: 'profile.logout_confirm_title'.tr(),
          fontSize: 16,
        ),
        content: ReusableText.bodyMedium(
          text: 'profile.logout_confirm_body'.tr(),
          color: AppColors.grey600,
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: ReusableText.bodyMedium(
              text: 'common.cancel'.tr(),
              color: AppColors.grey500,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.signOut();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.danger,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: ReusableText.bodySemiBold(
              text: 'profile.logout_action'.tr(),
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
