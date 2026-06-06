import 'package:driver/app/data/models/notification_model.dart';
import 'package:driver/app/modules/notifications/controllers/notifications_controller.dart';
import 'package:driver/core/theme/app_colors.dart';
import 'package:driver/core/theme/app_text_styles.dart';
import 'package:driver/core/widgets/app_card.dart';
import 'package:driver/core/widgets/app_scaffold.dart';
import 'package:driver/core/widgets/state_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class NotificationsView extends GetView<NotificationsController> {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'الإشعارات',
      subtitle: 'آخر تحديثات الطلبات والمحفظة',
      body: Obx(() {
        if (controller.isLoading.value) {
          return const LoadingWidget(message: 'جاري تحميل الإشعارات...');
        }

        if (controller.notifications.isEmpty) {
          return const EmptyStateWidget(
            message: 'لا توجد إشعارات',
            icon: Icons.notifications_none_rounded,
          );
        }

        return ListView.separated(
          itemCount: controller.notifications.length,
          separatorBuilder: (_, __) => SizedBox(height: 10.h),
          itemBuilder: (_, index) {
            final notification = controller.notifications[index];

            return _NotificationTile(
              notification: notification,
              onTap: () => controller.markAsRead(notification),
            )
                .animate(delay: (index * 35).ms)
                .fadeIn(duration: 220.ms)
                .slideY(begin: 0.03, end: 0, curve: Curves.easeOut);
          },
        );
      }),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({
    required this.notification,
    required this.onTap,
  });

  final NotificationModel notification;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isUnread = notification.isRead != true;

    return AppCard(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Padding(
              padding: EdgeInsets.all(10.r),
              child: Icon(
                Icons.notifications_active_outlined,
                size: 20.r,
                color: AppColors.primary,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        notification.title ?? 'إشعار جديد',
                        style: AppTextStyles.bodySemiBold(),
                      ),
                    ),
                    if (isUnread)
                      Icon(
                        Icons.circle,
                        size: 8.r,
                        color: AppColors.primary,
                      ),
                  ],
                ),
                SizedBox(height: 5.h),
                Text(
                  notification.message ?? '',
                  style: AppTextStyles.body(color: AppColors.grey600),
                ),
                if (notification.createdAt != null) ...[
                  SizedBox(height: 6.h),
                  Text(
                    DateFormat('yyyy/MM/dd - hh:mm a')
                        .format(notification.createdAt!.toDate()),
                    style: AppTextStyles.caption(color: AppColors.grey500),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
