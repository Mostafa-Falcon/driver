import 'package:driver/app/modules/wallet/controllers/wallet_controller.dart';
import 'package:driver/app/modules/wallet/views/widgets/recharge_bottom_sheet.dart';
import 'package:driver/app/modules/wallet/views/widgets/wallet_balance_card.dart';
import 'package:driver/app/modules/wallet/views/widgets/withdrawal_bottom_sheet.dart';
import 'package:driver/app/modules/wallet/views/widgets/transactions_list.dart';
import 'package:driver/app/modules/wallet/views/widgets/withdrawals_list.dart';
import 'package:driver/app/modules/home/views/widgets/header.dart';
import 'package:driver/app/routes/app_pages.dart';
import 'package:driver/core/constants/app_assets.dart';
import 'package:driver/core/theme/app_colors.dart';
import 'package:driver/core/widgets/app_scaffold.dart';
import 'package:driver/core/widgets/app_tab_bar.dart';
import 'package:driver/core/widgets/reusables/reusable_text.dart';
import 'package:driver/core/widgets/state_widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class WalletView extends GetView<WalletController> {
  const WalletView({super.key});

  static const _tabs = ['المعاملات', 'السحوبات'];

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Obx(
        () => ListView(
          children: [
            HeaderWidgets(
              userIcon: ClipOval(
                child: controller.driver?.profilePictureURL != null &&
                        controller.driver!.profilePictureURL!.startsWith('http')
                    ? CachedNetworkImage(
                        imageUrl: controller.driver!.profilePictureURL!,
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
              username: controller.driver?.fullName ?? 'السائق',
              userActivetion: controller.driver?.isDocumentVerify == true
                  ? 'حساب مفعل'
                  : 'قيد التفعيل',
              isOnline: controller.isOnline.value,
              onTapIsOnline: controller.toggleOnlineStatus,
              notificationCount: controller.unreadNotificationsCount.value,
              onTapNotification: () => Get.toNamed(AppRoutes.notifications),
            ),
            SizedBox(height: 14.h),
            WalletBalanceCard(
              balance: controller.balance,
              growth: controller.weekOverWeekGrowth,
              onRecharge: () => _showRechargeSheet(context),
              onWithdraw: () => _showWithdrawalSheet(context),
            )
                .animate()
                .fadeIn(duration: 260.ms)
                .slideY(begin: 0.04, end: 0, curve: Curves.easeOut),
            SizedBox(height: 20.h),
            const Row(
              children: [
                Expanded(
                  child: ReusableText.h3(
                    text: 'سجل الرصيد',
                    color: AppColors.grey800,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            AppTabBar(
              tabs: _tabs,
              currentIndex: controller.currentTab.value,
              onChanged: (index) => controller.currentTab.value = index,
            ),
            SizedBox(height: 12.h),
            if (controller.isLoading.value)
              LoadingWidget(
                message: controller.currentTab.value == 0
                    ? 'جاري تحميل المعاملات...'
                    : 'جاري تحميل السحوبات...',
              )
            else if (controller.currentTab.value == 0)
              TransactionsList(transactions: controller.transactions)
            else
              WithdrawalsList(withdrawals: controller.withdrawals),
            SizedBox(height: 96.h),
          ],
        ),
      ),
    );
  }

  void _showWithdrawalSheet(BuildContext context) {
    final amountController = TextEditingController();
    final noteController = TextEditingController();

    Get.bottomSheet(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      WithdrawalBottomSheet(
        amountController: amountController,
        noteController: noteController,
        balance: controller.balance,
        onSubmit: () async {
          final amount = double.tryParse(
            amountController.text.trim().replaceAll(',', '.'),
          );
          if (amount == null || amount <= 0) {
            Get.snackbar(
              'خطأ',
              'أدخل مبلغاً صحيحاً',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: AppColors.danger,
              colorText: Colors.white,
            );
            return;
          }
          if (amount > controller.balance) {
            Get.snackbar(
              'خطأ',
              'المبلغ أكبر من رصيدك الحالي',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: AppColors.danger,
              colorText: Colors.white,
            );
            return;
          }

          final success = await controller.submitWithdrawal(
            amount: amount,
            note: noteController.text.trim().isEmpty
                ? null
                : noteController.text.trim(),
          );

          Get.back();
          if (success) {
            Get.snackbar(
              'تم الإرسال',
              'سيتم مراجعة طلب السحب وصرفه قريباً',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: AppColors.primary,
              colorText: Colors.white,
              duration: const Duration(seconds: 3),
            );
          } else {
            Get.snackbar(
              'خطأ',
              'تعذر إرسال طلب السحب',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: AppColors.danger,
              colorText: Colors.white,
            );
          }
        },
      ),
    );
  }

  void _showRechargeSheet(BuildContext context) {
    final transactionController = TextEditingController();
    final noteController = TextEditingController();
    controller.clearRechargeDraft();

    Get.bottomSheet(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      RechargeBottomSheet(
        transactionController: transactionController,
        noteController: noteController,
        controller: controller,
        onSubmit: () async {
          final transactionNumber = transactionController.text.trim();
          if (transactionNumber.isEmpty) {
            Get.snackbar(
              'خطأ',
              'أدخل رقم العملية',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: AppColors.danger,
              colorText: Colors.white,
            );
            return;
          }
          if (controller.rechargeReceipt.value == null) {
            Get.snackbar(
              'خطأ',
              'أضف صورة إيصال التحويل',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: AppColors.danger,
              colorText: Colors.white,
            );
            return;
          }

          final success = await controller.submitRechargeRequest(
            transactionNumber: transactionNumber,
            note: noteController.text.trim().isEmpty
                ? null
                : noteController.text.trim(),
          );

          if (success) {
            Get.back();
            Get.snackbar(
              'تم الإرسال',
              'سيتم مراجعة طلب الشحن واعتماده من الإدارة',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: AppColors.primary,
              colorText: Colors.white,
              duration: const Duration(seconds: 3),
            );
          } else {
            Get.snackbar(
              'خطأ',
              'تعذر إرسال طلب الشحن',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: AppColors.danger,
              colorText: Colors.white,
            );
          }
        },
      ),
    );
  }
}
