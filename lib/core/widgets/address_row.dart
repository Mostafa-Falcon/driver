import 'package:driver/core/constants/app_strings.dart';
import 'package:driver/core/theme/app_colors.dart';
import 'package:driver/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddressRow extends StatelessWidget {
  const AddressRow({
    super.key,
    required this.title,
    required this.address,
    required this.icon,
    required this.color,
  });

  final String title;
  final String address;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: Padding(
            padding: EdgeInsets.all(8.r),
            child: Icon(icon, size: 18.r, color: color),
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.captionMedium(color: AppColors.grey500),
              ),
              SizedBox(height: 4.h),
              Text(
                address.isEmpty ? AppStrings.undefined : address,
                style: AppTextStyles.bodyMedium(color: AppColors.grey800),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
