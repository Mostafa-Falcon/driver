import 'package:driver/app/modules/wallet/controllers/wallet_controller.dart';
import 'package:driver/core/theme/app_colors.dart';
import 'package:driver/core/widgets/app_button.dart';
import 'package:driver/core/widgets/app_card.dart';
import 'package:driver/core/widgets/app_text_field.dart';
import 'package:driver/core/widgets/reusables/reusable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class RechargeBottomSheet extends StatelessWidget {
  const RechargeBottomSheet({
    super.key,
    required this.transactionController,
    required this.noteController,
    required this.controller,
    required this.onSubmit,
  });

  final TextEditingController transactionController;
  final TextEditingController noteController;
  final WalletController controller;
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
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
              const ReusableText.h3(text: 'شحن المحفظة'),
              SizedBox(height: 4.h),
              const ReusableText.body(
                text: 'أرسل رقم العملية وصورة الإيصال للمراجعة.',
                color: AppColors.grey500,
              ),
              SizedBox(height: 20.h),
              AppTextField(
                controller: transactionController,
                hintText: 'رقم العملية أو التحويل',
                prefixIcon: const Icon(Icons.receipt_long_outlined),
                textInputAction: TextInputAction.next,
              ),
              SizedBox(height: 12.h),
              AppTextField(
                controller: noteController,
                hintText: 'ملاحظة اختيارية',
                minLines: 2,
                maxLines: 3,
                textInputAction: TextInputAction.done,
              ),
              SizedBox(height: 14.h),
              Obx(() {
                final receipt = controller.rechargeReceipt.value;
                return AppCard(
                  backgroundColor: AppColors.grey50,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.image_outlined,
                            color: AppColors.primary,
                            size: 20.r,
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: ReusableText.bodySemiBold(
                              text: receipt == null
                                  ? 'لم يتم اختيار إيصال'
                                  : 'تم اختيار: ${receipt.name}',
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      Wrap(
                        spacing: 8.w,
                        runSpacing: 8.h,
                        children: [
                          OutlinedButton.icon(
                            onPressed: () => controller.pickRechargeReceipt(),
                            icon: const Icon(Icons.photo_camera_outlined),
                            label:
                                const ReusableText.bodyMedium(text: 'كاميرا'),
                          ),
                          OutlinedButton.icon(
                            onPressed: () => controller.pickRechargeReceipt(
                              source: ImageSource.gallery,
                            ),
                            icon: const Icon(Icons.photo_library_outlined),
                            label:
                                const ReusableText.bodyMedium(text: 'المعرض'),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }),
              SizedBox(height: 20.h),
              Obx(
                () => AppButton(
                  label: 'إرسال طلب الشحن',
                  onPressed: onSubmit,
                  isLoading: controller.isSubmittingRecharge.value,
                  icon: const Icon(Icons.send_rounded, color: Colors.white),
                ),
              ),
            ]
                .animate(interval: 40.ms)
                .fadeIn(duration: 200.ms)
                .slideY(begin: 0.03, end: 0, curve: Curves.easeOut),
          ),
        ),
      ),
    );
  }
}
