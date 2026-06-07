import 'package:driver/app/data/models/order_model.dart';
import 'package:driver/core/theme/app_colors.dart';
import 'package:driver/core/widgets/order_card.dart';
import 'package:driver/core/widgets/reusables/reusable_icon_animation.dart';
import 'package:driver/core/widgets/state_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrdersTabContent extends StatelessWidget {
  const OrdersTabContent({
    super.key,
    required this.isLoading,
    required this.currentTab,
    required this.isOnline,
    required this.newOrders,
    required this.activeOrders,
    required this.previousOrders,
    required this.onAcceptOrder,
    required this.onHideOrder,
    required this.onTapOrder,
  });

  final bool isLoading;
  final int currentTab;
  final bool isOnline;
  final List<OrderModel> newOrders;
  final List<OrderModel> activeOrders;
  final List<OrderModel> previousOrders;
  final ValueChanged<OrderModel> onAcceptOrder;
  final ValueChanged<OrderModel> onHideOrder;
  final ValueChanged<OrderModel> onTapOrder;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const LoadingWidget(message: 'جاري تحميل الطلبات...');
    }

    final Widget tabContent = switch (currentTab) {
      0 => _OrdersList(
          key: const ValueKey('new_orders'),
          orders: newOrders,
          emptyMessage: 'لا توجد طلبات جديدة',
          emptySubMessage: isOnline
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
          onAcceptOrder: onAcceptOrder,
          onHideOrder: onHideOrder,
          onTapOrder: onTapOrder,
        ),
      1 => _OrdersList(
          key: const ValueKey('active_orders'),
          orders: activeOrders,
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
          onTapOrder: onTapOrder,
        ),
      2 => _OrdersList(
          key: const ValueKey('previous_orders'),
          orders: previousOrders,
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
          onTapOrder: onTapOrder,
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
  }
}

// ── Orders List ───────────────────────────────────────────────────────────────

class _OrdersList extends StatelessWidget {
  const _OrdersList({
    super.key,
    required this.orders,
    required this.emptyMessage,
    required this.emptyIcon,
    required this.onTapOrder,
    this.emptySubMessage,
    this.emptyIconWidget,
    this.onAcceptOrder,
    this.onHideOrder,
    this.isNew = false,
  });

  final List<OrderModel> orders;
  final String emptyMessage;
  final String? emptySubMessage;
  final IconData emptyIcon;
  final Widget? emptyIconWidget;
  final ValueChanged<OrderModel>? onAcceptOrder;
  final ValueChanged<OrderModel>? onHideOrder;
  final ValueChanged<OrderModel> onTapOrder;
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
          onAccept: isNew ? () => onAcceptOrder?.call(order) : null,
          onHide: isNew ? () => onHideOrder?.call(order) : null,
          onTap: () => onTapOrder(order),
        )
            .animate(delay: (index * 40).ms)
            .fadeIn(duration: 220.ms)
            .slideY(begin: 0.04, end: 0, curve: Curves.easeOut);
      },
    );
  }
}
