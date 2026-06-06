import 'package:driver/app/data/models/order_model.dart';
import 'package:driver/core/constants/app_strings.dart';
import 'package:driver/core/theme/app_colors.dart';
import 'package:driver/core/theme/app_text_styles.dart';
import 'package:driver/core/widgets/address_row.dart';
import 'package:driver/core/widgets/app_button.dart';
import 'package:driver/core/widgets/app_card.dart';
import 'package:driver/core/widgets/status_chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class OrderCard extends StatelessWidget {
  const OrderCard({
    super.key,
    required this.order,
    this.isNew = false,
    this.onAccept,
    this.onHide,
    this.onTap,
  });

  final OrderModel order;
  final bool isNew;
  final VoidCallback? onAccept;
  final VoidCallback? onHide;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '#${_shortId(order.id)}',
                  style: AppTextStyles.bodySemiBold(),
                ),
              ),
              StatusChip(status: order.status),
            ],
          ),
          SizedBox(height: 14.h),
          AddressRow(
            title: 'الاستلام',
            address: order.pickupAddress?.fullAddress ?? '',
            icon: Icons.my_location_rounded,
            color: AppColors.primary,
          ),
          SizedBox(height: 10.h),
          AddressRow(
            title: 'التسليم',
            address: order.dropAddress?.fullAddress ?? '',
            icon: Icons.location_on_rounded,
            color: AppColors.danger,
          ),
          SizedBox(height: 14.h),
          Row(
            children: [
              Text(
                '${order.totalAmount.toStringAsFixed(2)} ${AppStrings.currencySuffix}',
                style: AppTextStyles.h3(color: AppColors.primary),
              ),
              const Spacer(),
              if (order.createdAt != null)
                Text(
                  DateFormat('hh:mm a').format(order.createdAt!.toDate()),
                  style: AppTextStyles.caption(color: AppColors.grey500),
                ),
            ],
          ),
          if (isNew) ...[
            SizedBox(height: 14.h),
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    label: 'قبول',
                    onPressed: onAccept,
                    height: 42,
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: AppButton(
                    label: 'إخفاء',
                    onPressed: onHide,
                    isOutlined: true,
                    height: 42,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  String _shortId(String? id) {
    if (id == null || id.isEmpty) return '---';
    return id.length <= 8 ? id : id.substring(0, 8);
  }
}
