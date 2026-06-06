import 'package:driver/core/constants/app_strings.dart';
import 'package:driver/core/theme/app_text_styles.dart';
import 'package:driver/core/widgets/reusables/reusable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WalletBalanceCard extends StatelessWidget {
  const WalletBalanceCard({
    super.key,
    required this.balance,
    required this.growth,
    required this.onRecharge,
    required this.onWithdraw,
  });

  final double balance;
  final double growth;
  final VoidCallback onRecharge;
  final VoidCallback onWithdraw;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF104F32),
            Color(0xFF1E955E),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF104F32).withValues(alpha: 0.35),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.15),
          width: 1.5,
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 22.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: Chevron + Title
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const ReusableText.bodySemiBold(
                    text: 'رصيدك',
                    color: Colors.white,
                  ),
                  SizedBox(width: 6.w),
                  Text('💰', style: TextStyle(fontSize: 16.sp)),
                ],
              ),
              Icon(
                Icons.chevron_left_rounded,
                color: Colors.white.withValues(alpha: 0.8),
                size: 22.r,
              ),
            ],
          ),
          SizedBox(height: 14.h),

          // Middle: Large balance and growth pill
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  ReusableText(
                    text: balance.toStringAsFixed(0),
                    style: TextStyle(
                      fontSize: 38.sp,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 6.w),
                  const ReusableText.bodyMedium(
                    text: AppStrings.currencySuffix,
                    color: Colors.white70,
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.25),
                    width: 1.2,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      growth >= 0
                          ? Icons.arrow_upward_rounded
                          : Icons.arrow_downward_rounded,
                      size: 12.r,
                      color: Colors.white,
                    ),
                    SizedBox(width: 3.w),
                    ReusableText(
                      text: growth >= 0
                          ? '${growth.toStringAsFixed(0)}%+'
                          : '${growth.toStringAsFixed(0)}%',
                      style: AppTextStyles.captionMedium(color: Colors.white)
                          .copyWith(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 5.w),
                    ReusableText(
                      text: 'الاسبوع السابق',
                      style: AppTextStyles.caption(
                        color: Colors.white.withValues(alpha: 0.9),
                      ).copyWith(
                        fontSize: 10.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 24.h),

          // Bottom Buttons
          Row(
            children: [
              // "شحن" (Solid white on the right)
              Expanded(
                child: ElevatedButton(
                  onPressed: onRecharge,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    elevation: 4,
                    shadowColor: Colors.black.withValues(alpha: 0.15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                  ),
                  child: const ReusableText.bodySemiBold(
                    text: 'شحن',
                    color: Color(0xFF104F32),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              // "سحب" (Frosted Glass on the left)
              Expanded(
                child: OutlinedButton(
                  onPressed: onWithdraw,
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white.withValues(alpha: 0.15),
                    side: BorderSide(
                      color: Colors.white.withValues(alpha: 0.45),
                      width: 1.5,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                  ),
                  child: const ReusableText.bodySemiBold(
                    text: 'سحب',
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
