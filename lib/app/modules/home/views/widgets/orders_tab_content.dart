import 'package:driver/app/data/models/order_model.dart';
import 'package:driver/app/modules/home/controllers/home_controller.dart';
import 'package:driver/core/theme/app_colors.dart';
import 'package:driver/core/widgets/order_card.dart';
import 'package:driver/core/widgets/state_widgets.dart';
import 'package:driver/core/widgets/reusables/reusable_icon_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class OrdersTabContent extends StatelessWidget {
  const OrdersTabContent({super.key, required this.controller});

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const LoadingWidget(message: 'جاري تحميل الطلبات...');
      }

      final Widget tabContent = switch (controller.currentTab.value) {
        0 => _OrdersList(
            key: const ValueKey('new_orders'),
            orders: controller.newOrders,
            emptyMessage: 'لا توجد طلبات جديدة',
            emptySubMessage: controller.isOnline.value
                ? 'سيظهر هنا الطلبات المعروضة عليك فور وصولها.'
                : 'قم بتفعيل وضع الاتصال لاستقبال الطلبات.',
            emptyIcon: Icons.receipt_long_outlined,
            emptyIconWidget: ReusableIconAnimation(
              baseIcon: Icons.receipt_long_outlined,
              overlayIcon: Icons.search,
              type: IconAnimationType.scan,
              baseSize: 64.r,
              overlaySize: 34.r,
              overlayColor: Theme.of(context).primaryColor,
              baseColor: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.greyDark300
                  : AppColors.grey300,
              duration: const Duration(milliseconds: 2000),
            ),
            isNew: true,
            controller: controller,
          ),
        1 => _OrdersList(
            key: const ValueKey('active_orders'),
            orders: controller.activeOrders,
            emptyMessage: 'لا توجد طلبات حالية',
            emptySubMessage: 'اقبل طلباً جديداً وسيظهر هنا.',
            emptyIcon: Icons.local_shipping_outlined,
            emptyIconWidget: ReusableIconAnimation(
              baseIcon: Icons.local_shipping_outlined,
              overlayIcon: Icons.location_on,
              type: IconAnimationType.bounce,
              baseSize: 64.r,
              overlaySize: 24.r,
              overlayColor: AppColors.danger,
              baseColor: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.greyDark300
                  : AppColors.grey300,
              overlayOffset: Offset(12.w, -8.h),
            ),
            controller: controller,
          ),
        2 => _OrdersList(
            key: const ValueKey('previous_orders'),
            orders: controller.previousOrders,
            emptyMessage: 'لا توجد طلبات سابقة',
            emptySubMessage: 'ستظهر هنا الطلبات المكتملة والملغاة.',
            emptyIcon: Icons.history_outlined,
            emptyIconWidget: ReusableIconAnimation(
              baseIcon: Icons.history_outlined,
              overlayIcon: Icons.check_circle,
              type: IconAnimationType.pulse,
              baseSize: 64.r,
              overlaySize: 24.r,
              overlayColor: AppColors.success,
              baseColor: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.greyDark300
                  : AppColors.grey300,
            ),
            controller: controller,
          ),
        _ => const SizedBox.shrink(),
      };

      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        switchInCurve: Curves.easeInOut,
        switchOutCurve: Curves.easeInOut,
        transitionBuilder: (child, animation) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.0, 0.05),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
          );
        },
        child: tabContent,
      );
    });
  }
}

// ── Orders List ───────────────────────────────────────────────────────────────

class _OrdersList extends StatelessWidget {
  const _OrdersList({
    super.key,
    required this.orders,
    required this.emptyMessage,
    required this.emptyIcon,
    required this.controller,
    this.emptySubMessage,
    this.emptyIconWidget,
    this.isNew = false,
  });

  final List<OrderModel> orders;
  final String emptyMessage;
  final String? emptySubMessage;
  final IconData emptyIcon;
  final Widget? emptyIconWidget;
  final HomeController controller;
  final bool isNew;

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) {
      return EmptyStateWidget(
        message: emptyMessage,
        subMessage: emptySubMessage,
        icon: emptyIcon,
        iconWidget: emptyIconWidget,
      );
    }

    return ListView.separated(
      padding: EdgeInsets.only(bottom: 96.h),
      itemCount: orders.length,
      separatorBuilder: (_, __) => SizedBox(height: 12.h),
      itemBuilder: (_, index) {
        final order = orders[index];

        return OrderCard(
          order: order,
          isNew: isNew,
          onAccept: isNew ? () => controller.acceptOrder(order) : null,
          onHide: isNew ? () => controller.hideOrder(order) : null,
          onTap: () => controller.goToOrderDetails(order),
        )
            .animate(delay: (index * 40).ms)
            .fadeIn(duration: 220.ms)
            .slideY(begin: 0.04, end: 0, curve: Curves.easeOut);
      },
    );
  }
}
