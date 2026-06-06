import 'package:driver/app/modules/profile/controllers/profile_controller.dart';
import 'package:driver/app/modules/profile/views/widgets/profile_menu_item.dart';
import 'package:driver/app/modules/profile/views/widgets/profile_sheets.dart';
import 'package:driver/core/theme/app_colors.dart';
import 'package:driver/core/widgets/reusables/reusable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AccountSettingsSection extends StatelessWidget {
  const AccountSettingsSection({super.key, required this.controller});

  final ProfileController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 6.h),
          child: const ReusableText.bodySemiBold(
            text: 'إعدادات الحساب',
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
                icon: Icons.person_outline_rounded,
                title: 'حسابي',
                onTap: () => _showMyAccountSheet(context),
              ),
              ProfileMenuItem(
                icon: Icons.lock_outline_rounded,
                title: 'تغيير كلمة المرور',
                iconColor: const Color(0xFFE28743),
                iconBgColor: const Color(0xFFE28743).withValues(alpha: 0.08),
                onTap: () => _showChangePasswordSheet(context),
              ),
              ProfileMenuItem(
                icon: Icons.credit_card_rounded,
                title: 'حساباتي المصرفية',
                iconColor: const Color(0xFF7E57C2),
                iconBgColor: const Color(0xFF7E57C2).withValues(alpha: 0.08),
                showDivider: false,
                onTap: () => _showBankAccountsSheet(context),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showMyAccountSheet(BuildContext context) {
    Get.bottomSheet(
      MyAccountSheet(driver: controller.auth.user),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  void _showChangePasswordSheet(BuildContext context) {
    Get.bottomSheet(
      ChangePasswordSheet(controller: controller),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  void _showBankAccountsSheet(BuildContext context) {
    Get.bottomSheet(
      const BankAccountsSheet(),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }
}
