import 'dart:math' as math;
import 'package:driver/app/data/models/driver_payout_model.dart';
import 'package:driver/core/constants/app_strings.dart';
import 'package:driver/core/theme/app_colors.dart';
import 'package:driver/core/widgets/reusables/reusable_text.dart';
import 'package:driver/core/widgets/state_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Helper functions for formatting dates and codes safely in Arabic RTL
String _formatArabicDate(DateTime date) {
  final hours =
      date.hour > 12 ? date.hour - 12 : (date.hour == 0 ? 12 : date.hour);
  final amPm = date.hour >= 12 ? 'م' : 'ص';
  final minutes = date.minute.toString().padLeft(2, '0');

  final monthsAr = [
    'يناير',
    'فبراير',
    'مارس',
    'أبريل',
    'مايو',
    'يونيو',
    'يوليو',
    'أغسطس',
    'سبتمبر',
    'أكتوبر',
    'نوفمبر',
    'ديسمبر',
  ];
  final monthName = monthsAr[date.month - 1];

  return '$hours:$minutes $amPm، $monthName ${date.day} ${date.year}';
}

String _formatWithdrawalCode(DriverPayoutModel withdrawal) {
  if (withdrawal.id != null && withdrawal.id!.isNotEmpty) {
    final cleanId = withdrawal.id!.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '');
    return '#${cleanId.substring(0, math.min(6, cleanId.length))}';
  }
  return '';
}

class WithdrawalsList extends StatelessWidget {
  const WithdrawalsList({super.key, required this.withdrawals});

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
        return WithdrawalTile(withdrawals[index])
            .animate(delay: (index * 35).ms)
            .fadeIn(duration: 220.ms)
            .slideY(begin: 0.03, end: 0, curve: Curves.easeOut);
      }),
    );
  }
}

class WithdrawalTile extends StatelessWidget {
  const WithdrawalTile(this.withdrawal, {super.key});

  final DriverPayoutModel withdrawal;

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(withdrawal.status);

    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.greyDark100 : AppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: isDark
              ? AppColors.greyDark200.withValues(alpha: 0.6)
              : AppColors.grey200.withValues(alpha: 0.5),
          width: 1.2,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: Row(
          children: [
            // Vertical Indicator Bar
            Container(
              width: 5.w,
              height: 64.h,
              color: color,
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Right: Amount & Date
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ReusableText.bodySemiBold(
                          text:
                              '${(withdrawal.amount ?? 0).toStringAsFixed(0)} ${AppStrings.currencySuffix}',
                          color: color,
                          fontSize: 16.sp,
                        ),
                        if (withdrawal.displayDate != null) ...[
                          SizedBox(height: 6.h),
                          ReusableText.caption(
                            text: _formatArabicDate(
                              withdrawal.displayDate!.toDate(),
                            ),
                            color: AppColors.grey500,
                          ),
                        ],
                      ],
                    ),
                    // Left: Status Capsule & Code
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(
                              color: color.withValues(alpha: 0.15),
                              width: 1,
                            ),
                          ),
                          child: ReusableText.captionMedium(
                            text: _statusLabel(withdrawal.status),
                            color: color,
                          ),
                        ),
                        SizedBox(height: 6.h),
                        ReusableText.caption(
                          text: _formatWithdrawalCode(withdrawal),
                          color: AppColors.grey400,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
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
