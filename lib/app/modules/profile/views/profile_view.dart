import 'package:cached_network_image/cached_network_image.dart';
import 'package:driver/app/modules/home/views/widgets/header.dart';
import 'package:driver/app/modules/profile/controllers/profile_controller.dart';
import 'package:driver/app/modules/profile/views/widgets/account_settings_section.dart';
import 'package:driver/app/modules/profile/views/widgets/general_settings_section.dart';
import 'package:driver/app/routes/app_pages.dart';
import 'package:driver/core/constants/app_assets.dart';
import 'package:driver/core/theme/app_colors.dart';
import 'package:driver/core/widgets/app_button.dart';
import 'package:driver/core/widgets/app_scaffold.dart';
import 'package:driver/core/widgets/reusables/reusable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Obx(
        () => ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            // ── 1. Dynamic Header ──────────────────────────────────────────────
            HeaderWidgets(
              userIcon: ClipOval(
                child: controller.auth.user?.profilePictureURL != null &&
                        controller.auth.user!.profilePictureURL!
                            .startsWith('http')
                    ? CachedNetworkImage(
                        imageUrl: controller.auth.user!.profilePictureURL!,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Image.asset(
                          AppAssets.userPlaceholder,
                          fit: BoxFit.cover,
                        ),
                        errorWidget: (context, url, error) => Image.asset(
                          AppAssets.userPlaceholder,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Image.asset(
                        AppAssets.userPlaceholder,
                        fit: BoxFit.cover,
                      ),
              ),
              username: controller.auth.user?.fullName ?? 'السائق',
              userActivetion: controller.auth.user?.isDocumentVerify == true
                  ? 'حساب مفعل'
                  : 'قيد التفعيل',
              isOnline: controller.isOnline.value,
              onTapIsOnline: controller.toggleOnlineStatus,
              notificationCount: controller.unreadNotificationsCount.value,
              onTapNotification: () => Get.toNamed(AppRoutes.notifications),
            ),
            SizedBox(height: 18.h),

            // ── 2. Account Settings Section ─────────────────────────────────────
            AccountSettingsSection(controller: controller),
            SizedBox(height: 20.h),

            // ── 3. General Settings & Support Section ───────────────────────────
            GeneralSettingsSection(controller: controller),
            SizedBox(height: 24.h),

            // ── 4. Premium Logout Button ───────────────────────────────────────
            AppButton(
              label: 'تسجيل الخروج',
              onPressed: () => _showLogoutDialog(context),
              isOutlined: true,
              backgroundColor: AppColors.danger,
              textColor: AppColors.danger,
              icon: const Icon(
                Icons.logout_rounded,
                color: AppColors.danger,
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
        title: const ReusableText.bodySemiBold(
          text: 'تسجيل الخروج',
          fontSize: 16,
        ),
        content: const ReusableText.bodyMedium(
          text: 'هل أنت متأكد من رغبتك في تسجيل الخروج من التطبيق؟',
          color: AppColors.grey600,
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const ReusableText.bodyMedium(
              text: 'إلغاء',
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
            child: const ReusableText.bodySemiBold(
              text: 'خروج',
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
