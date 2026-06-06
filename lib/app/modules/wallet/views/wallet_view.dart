import 'package:driver/app/data/models/driver_payout_model.dart';
import 'package:driver/app/data/models/wallet_transaction_model.dart';
import 'package:driver/app/modules/wallet/controllers/wallet_controller.dart';
import 'package:driver/core/constants/app_assets.dart';
import 'package:driver/core/constants/app_strings.dart';
import 'package:driver/core/theme/app_colors.dart';
import 'package:driver/core/theme/app_text_styles.dart';
import 'package:driver/core/widgets/app_button.dart';
import 'package:driver/core/widgets/app_card.dart';
import 'package:driver/core/widgets/app_scaffold.dart';
import 'package:driver/core/widgets/app_tab_bar.dart';
import 'package:driver/core/widgets/app_text_field.dart';
import 'package:driver/core/widgets/state_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class WalletView extends GetView<WalletController> {
  const WalletView({super.key});

  static const _tabs = ['المعاملات', 'السحوبات'];

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'المحفظة',
      subtitle: 'الرصيد وسجل المعاملات',
      actions: [
        IconButton(
          tooltip: 'طلب سحب',
          onPressed: () => _showWithdrawalSheet(context),
          icon: const Icon(Icons.payments_outlined),
        ),
      ],
      body: Obx(
        () => ListView(
          children: [
            _WalletBalanceCard(
              balance: controller.balance,
              onWithdraw: () => _showWithdrawalSheet(context),
            )
                .animate()
                .fadeIn(duration: 260.ms)
                .slideY(begin: 0.04, end: 0, curve: Curves.easeOut),
            SizedBox(height: 14.h),
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
              _TransactionsList(transactions: controller.transactions)
            else
              _WithdrawalsList(withdrawals: controller.withdrawals),
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
      _WithdrawalBottomSheet(
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
}

// ── Withdrawal Bottom Sheet ───────────────────────────────────────────────────

class _WithdrawalBottomSheet extends StatelessWidget {
  const _WithdrawalBottomSheet({
    required this.amountController,
    required this.noteController,
    required this.balance,
    required this.onSubmit,
  });

  final TextEditingController amountController;
  final TextEditingController noteController;
  final double balance;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 24.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: AppColors.grey200,
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
            ),
            SizedBox(height: 18.h),
            Text('طلب سحب رصيد', style: AppTextStyles.h3()),
            SizedBox(height: 4.h),
            Text(
              'رصيدك الحالي: ${balance.toStringAsFixed(2)} ${AppStrings.currencySuffix}',
              style: AppTextStyles.body(color: AppColors.grey500),
            ),
            SizedBox(height: 20.h),
            AppTextField(
              controller: amountController,
              hintText: 'المبلغ المطلوب سحبه',
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
              ],
              prefixIcon: const Icon(Icons.attach_money_rounded),
              textInputAction: TextInputAction.next,
            ),
            SizedBox(height: 12.h),
            AppTextField(
              controller: noteController,
              hintText: 'ملاحظة اختيارية (رقم الحساب، طريقة الاستلام...)',
              minLines: 2,
              maxLines: 3,
              textInputAction: TextInputAction.done,
            ),
            SizedBox(height: 20.h),
            GetBuilder<WalletController>(
              builder: (c) => AppButton(
                label: 'إرسال طلب السحب',
                onPressed: onSubmit,
                isLoading: c.isWithdrawing.value,
                icon: const Icon(Icons.send_rounded, color: Colors.white),
              ),
            ),
          ]
              .animate(interval: 40.ms)
              .fadeIn(duration: 200.ms)
              .slideY(begin: 0.03, end: 0, curve: Curves.easeOut),
        ),
      ),
    );
  }
}

// ── Transactions List ─────────────────────────────────────────────────────────

class _TransactionsList extends StatelessWidget {
  const _TransactionsList({required this.transactions});

  final List<WalletTransactionModel> transactions;

  @override
  Widget build(BuildContext context) {
    if (transactions.isEmpty) {
      return const EmptyStateWidget(
        message: 'لا توجد معاملات',
        icon: Icons.account_balance_wallet_outlined,
      );
    }

    return Column(
      children: List.generate(transactions.length, (index) {
        return _WalletTransactionTile(transactions[index])
            .animate(delay: (index * 35).ms)
            .fadeIn(duration: 220.ms)
            .slideY(begin: 0.03, end: 0, curve: Curves.easeOut);
      }),
    );
  }
}

// ── Withdrawals List ──────────────────────────────────────────────────────────

class _WithdrawalsList extends StatelessWidget {
  const _WithdrawalsList({required this.withdrawals});

  final List<DriverPayoutModel> withdrawals;

  @override
  Widget build(BuildContext context) {
    if (withdrawals.isEmpty) {
      return const EmptyStateWidget(
        message: 'لا توجد طلبات سحب',
        icon: Icons.payments_outlined,
      );
    }

    return Column(
      children: List.generate(withdrawals.length, (index) {
        return _WithdrawalTile(withdrawals[index])
            .animate(delay: (index * 35).ms)
            .fadeIn(duration: 220.ms)
            .slideY(begin: 0.03, end: 0, curve: Curves.easeOut);
      }),
    );
  }
}

// ── Balance Card ──────────────────────────────────────────────────────────────

class _WalletBalanceCard extends StatelessWidget {
  const _WalletBalanceCard({
    required this.balance,
    required this.onWithdraw,
  });

  final double balance;
  final VoidCallback onWithdraw;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.28),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: EdgeInsets.all(20.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'رصيدك الحالي',
                      style: AppTextStyles.body(color: Colors.white70),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      '${balance.toStringAsFixed(2)} ${AppStrings.currencySuffix}',
                      style: AppTextStyles.display(color: Colors.white),
                    ),
                  ],
                ),
              ),
              Image.asset(AppAssets.wallet, width: 74.r, height: 74.r),
            ],
          ),
          SizedBox(height: 16.h),
          GestureDetector(
            onTap: onWithdraw,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.35),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.payments_outlined,
                    color: Colors.white,
                    size: 18.r,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'طلب سحب',
                    style: AppTextStyles.bodySemiBold(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Transaction Tile ──────────────────────────────────────────────────────────

class _WalletTransactionTile extends StatelessWidget {
  const _WalletTransactionTile(this.transaction);

  final WalletTransactionModel transaction;

  @override
  Widget build(BuildContext context) {
    final isTopup = transaction.isTopup == true;
    final color = isTopup ? AppColors.success : AppColors.danger;

    return AppCard(
      margin: EdgeInsets.only(bottom: 10.h),
      child: Row(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Padding(
              padding: EdgeInsets.all(10.r),
              child: Icon(
                isTopup ? Icons.add : Icons.remove,
                color: color,
                size: 18.r,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.note?.isNotEmpty == true
                      ? transaction.note!
                      : transaction.transactionType ?? 'معاملة',
                  style: AppTextStyles.bodySemiBold(),
                ),
                if (transaction.date != null) ...[
                  SizedBox(height: 4.h),
                  Text(
                    DateFormat('yyyy/MM/dd - hh:mm a')
                        .format(transaction.date!.toDate()),
                    style: AppTextStyles.caption(color: AppColors.grey500),
                  ),
                ],
              ],
            ),
          ),
          Text(
            '${isTopup ? '+' : '-'}${(transaction.amount ?? 0).toStringAsFixed(2)}',
            style: AppTextStyles.bodySemiBold(color: color),
          ),
        ],
      ),
    );
  }
}

// ── Withdrawal Tile ───────────────────────────────────────────────────────────

class _WithdrawalTile extends StatelessWidget {
  const _WithdrawalTile(this.withdrawal);

  final DriverPayoutModel withdrawal;

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(withdrawal.status);

    return AppCard(
      margin: EdgeInsets.only(bottom: 10.h),
      child: Row(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Padding(
              padding: EdgeInsets.all(10.r),
              child: Icon(Icons.payments_outlined, color: color, size: 18.r),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _statusLabel(withdrawal.status),
                  style: AppTextStyles.bodySemiBold(),
                ),
                if (withdrawal.displayDate != null) ...[
                  SizedBox(height: 4.h),
                  Text(
                    DateFormat('yyyy/MM/dd - hh:mm a')
                        .format(withdrawal.displayDate!.toDate()),
                    style: AppTextStyles.caption(color: AppColors.grey500),
                  ),
                ],
                if (withdrawal.note?.isNotEmpty == true) ...[
                  SizedBox(height: 4.h),
                  Text(
                    withdrawal.note!,
                    style: AppTextStyles.caption(color: AppColors.grey500),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          Text(
            '${(withdrawal.amount ?? 0).toStringAsFixed(2)} ${AppStrings.currencySuffix}',
            style: AppTextStyles.bodySemiBold(color: color),
          ),
        ],
      ),
    );
  }

  Color _statusColor(String? status) {
    return switch (status?.toLowerCase()) {
      'success' || 'paid' || 'approved' || 'completed' => AppColors.success,
      'rejected' || 'cancelled' || 'canceled' => AppColors.danger,
      _ => AppColors.warning,
    };
  }

  String _statusLabel(String? status) {
    return switch (status?.toLowerCase()) {
      'success' || 'paid' || 'approved' || 'completed' => 'تم الصرف',
      'rejected' => 'مرفوض',
      'cancelled' || 'canceled' => 'ملغي',
      _ => 'قيد المراجعة',
    };
  }
}
