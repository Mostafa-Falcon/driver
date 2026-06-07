import 'package:driver/app/modules/profile/controllers/profile_controller.dart';
import 'package:driver/app/modules/profile/views/widgets/profile_menu_item.dart';
import 'package:driver/app/modules/profile/views/widgets/profile_section_card.dart';
import 'package:driver/app/modules/profile/views/widgets/profile_sheets.dart';
import 'package:driver/core/theme/app_colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;

class AccountSettingsSection extends StatelessWidget {
  const AccountSettingsSection({super.key, required this.controller});

  final ProfileController controller;

  @override
  Widget build(BuildContext context) {
    final iconColor = Theme.of(context).brightness == Brightness.dark
        ? AppColors.greyDark600
        : AppColors.grey600;

    return ProfileSectionCard(
      title: 'profile.account_settings'.tr(),
      children: [
        ProfileMenuItem(
          icon: Icons.person_outline_rounded,
          title: 'profile.account'.tr(),
          iconColor: iconColor,
          onTap: () => _showMyAccountSheet(context),
        ),
        ProfileMenuItem(
          icon: Icons.lock_outline_rounded,
          title: 'profile.change_password'.tr(),
          iconColor: iconColor,
          onTap: () => _showChangePasswordSheet(context),
        ),
        ProfileMenuItem(
          icon: Icons.credit_card_rounded,
          title: 'profile.bank_accounts'.tr(),
          iconColor: iconColor,
          showDivider: false,
          onTap: () => _showBankAccountsSheet(context),
        ),
      ],
    );
  }

  void _showMyAccountSheet(BuildContext context) {
    Get.bottomSheet(
      MyAccountSheet(
        controller: controller,
        driver: controller.auth.user,
      ),
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
      BankAccountsSheet(bankDetails: controller.auth.user?.userBankDetails),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }
}
