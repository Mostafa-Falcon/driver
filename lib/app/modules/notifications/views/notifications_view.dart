import 'package:driver/app/data/models/notification_model.dart';
import 'package:driver/app/modules/notifications/controllers/notifications_controller.dart';
import 'package:driver/core/theme/app_colors.dart';
import 'package:driver/core/theme/app_text_styles.dart';
import 'package:driver/core/widgets/app_scaffold.dart';
import 'package:driver/core/widgets/state_widgets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart' hide Trans;

class NotificationsView extends GetView<NotificationsController> {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'notifications.title'.tr(),
      subtitle: 'notifications.subtitle'.tr(),
      actions: [
        Obx(
          () => TextButton(
            onPressed:
                controller.unreadCount == 0 || controller.isMarkingAllRead.value
                    ? null
                    : controller.markAllAsRead,
            child: Text(
              'notifications.mark_all_read'.tr(),
              style: AppTextStyles.bodySemiBold(
                color: controller.unreadCount == 0
                    ? AppColors.grey400
                    : AppColors.primary,
              ),
            ),
          ),
        ),
      ],
      body: Obx(() {
        if (controller.isLoading.value) {
          return LoadingWidget(message: 'notifications.loading'.tr());
        }

        if (controller.notifications.isEmpty) {
          return EmptyStateWidget(
            message: 'notifications.empty'.tr(),
            icon: Icons.notifications_none_rounded,
          );
        }

        return ListView.separated(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.only(bottom: 24.h),
          itemCount: controller.notifications.length,
          separatorBuilder: (_, __) => SizedBox(height: 2.h),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isUnread = notification.isRead != true;
    final accentColor = _accentColor(notification);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 12.h),
        child: Row(
          children: [
            SizedBox(
              width: 20.w,
              child: AnimatedScale(
                scale: isUnread ? 1 : 0,
                duration: const Duration(milliseconds: 180),
                child: Icon(
                  Icons.circle,
                  size: 8.r,
                  color: AppColors.primary,
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ReusableNotificationTitle(
                    title: _title,
                    isUnread: isUnread,
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    _message,
                    textAlign: TextAlign.right,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.body(
                      color: isDark ? AppColors.greyDark500 : AppColors.grey600,
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    _relativeTime,
                    textAlign: TextAlign.right,
                    style: AppTextStyles.caption(
                      color: isDark ? AppColors.greyDark400 : AppColors.grey400,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 12.w),
            Container(
              width: 54.r,
              height: 54.r,
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: isUnread ? 0.22 : 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _icon,
                color: accentColor,
                size: 24.r,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String get _title {
    final title = notification.title;
    if (title != null && title.trim().isNotEmpty) return title;

    return switch (notification.type) {
      'new_order' || 'new_order_placed' => 'notifications.new_order'.tr(),
      'driver_completed' ||
      'order_completed' =>
        'notifications.order_completed'.tr(),
      _ => 'notifications.new'.tr(),
    };
  }

  String get _message {
    final message = notification.message;
    if (message != null && message.trim().isNotEmpty) return message;

    final orderId = notification.orderId;
    if (orderId != null && orderId.isNotEmpty) {
      return '${'notifications.new_order_body'.tr()} #${_shortId(orderId)}';
    }

    return 'notifications.new_order_body'.tr();
  }

  String get _relativeTime {
    final createdAt = notification.createdAt?.toDate();
    if (createdAt == null) return '';

    final diff = DateTime.now().difference(createdAt);
    if (diff.inMinutes < 1) return 'notifications.just_now'.tr();
    if (diff.inHours < 1) {
      return 'notifications.minutes_ago'.tr(
        namedArgs: {'count': '${diff.inMinutes}'},
      );
    }
    if (diff.inDays < 1) {
      return 'notifications.hours_ago'.tr(
        namedArgs: {'count': '${diff.inHours}'},
      );
    }
    return 'notifications.days_ago'.tr(
      namedArgs: {'count': '${diff.inDays}'},
    );
  }

  IconData get _icon {
    return switch (notification.type) {
      'new_order' || 'new_order_placed' => Icons.delivery_dining_rounded,
      'driver_completed' || 'order_completed' => Icons.check_circle_rounded,
      _ => Icons.notifications_active_outlined,
    };
  }

  Color _accentColor(NotificationModel notification) {
    return switch (notification.type) {
      'driver_completed' || 'order_completed' => AppColors.success,
      _ => AppColors.primary,
    };
  }

  String _shortId(String id) => id.length <= 8 ? id : id.substring(0, 8);
}

class ReusableNotificationTitle extends StatelessWidget {
  const ReusableNotificationTitle({
    super.key,
    required this.title,
    required this.isUnread,
  });

  final String title;
  final bool isUnread;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Flexible(
          child: Text(
            title,
            textAlign: TextAlign.right,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.bodySemiBold().copyWith(
              fontSize: 15.sp,
              fontWeight: isUnread ? FontWeight.w700 : FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
