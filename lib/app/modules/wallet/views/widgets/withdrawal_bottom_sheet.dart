import 'package:driver/app/modules/wallet/controllers/wallet_controller.dart';
import 'package:driver/core/constants/app_strings.dart';
import 'package:driver/core/theme/app_colors.dart';
import 'package:driver/core/widgets/app_button.dart';
import 'package:driver/core/widgets/app_text_field.dart';
import 'package:driver/core/widgets/reusables/reusable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class WithdrawalBottomSheet extends StatelessWidget {
  const WithdrawalBottomSheet({
    super.key,
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
            const ReusableText.h3(text: 'طلب سحب رصيد'),
            SizedBox(height: 4.h),
            ReusableText.body(
              text:
                  'رصيدك الحالي: ${balance.toStringAsFixed(2)} ${AppStrings.currencySuffix}',
              color: AppColors.grey500,
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
            Obx(
              () => AppButton(
                label: 'إرسال طلب السحب',
                onPressed: onSubmit,
                isLoading: Get.find<WalletController>().isWithdrawing.value,
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
