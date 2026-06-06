import 'package:driver/app/data/models/order_model.dart';
import 'package:driver/app/modules/home/controllers/home_controller.dart';
import 'package:driver/app/routes/app_pages.dart';
import 'package:driver/core/constants/app_assets.dart';
import 'package:driver/core/constants/app_strings.dart';
import 'package:driver/core/theme/app_colors.dart';
import 'package:driver/core/theme/app_text_styles.dart';
import 'package:driver/core/widgets/app_scaffold.dart';
import 'package:driver/core/widgets/order_card.dart';
import 'package:driver/core/widgets/state_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'لوحة السائق',
      subtitle: 'إدارة الطلبات اليومية',
      actions: [
        IconButton(
          onPressed: () => Get.toNamed(AppRoutes.notifications),
          icon: const Icon(Icons.notifications_none_rounded),
        ),
        IconButton(
          onPressed: () => Get.toNamed(AppRoutes.editProfile),
          icon: const Icon(Icons.person_outline_rounded),
        ),
      ],
      body: Column(
        children: [
          _HomeHeader(controller: controller),
          SizedBox(height: 14.h),
          Obx(() => _HomeTabBar(controller: controller)),
          SizedBox(height: 14.h),
          Expanded(
            child: Obx(() => _OrdersTabContent(controller: controller)),
          ),
        ],
      ),
    );
  }
}

// ── Header ────────────────────────────────────────────────────────────────────

class _HomeHeader extends StatelessWidget {
  const _HomeHeader({required this.controller});

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final driver = controller.driver;
      final isOnline = controller.isOnline;

      return Container(
        decoration: BoxDecoration(
          gradient: isOnline
              ? AppColors.primaryGradient
              : const LinearGradient(
                  colors: [Color(0xFF6B7280), Color(0xFF9CA3AF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: (isOnline ? AppColors.primary : AppColors.grey500)
                  .withValues(alpha: 0.25),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        padding: EdgeInsets.all(16.r),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28.r,
              backgroundColor: Colors.white.withValues(alpha: 0.25),
              backgroundImage: driver?.profilePictureURL != null
                  ? NetworkImage(driver!.profilePictureURL!)
                  : const AssetImage(AppAssets.userPlaceholder)
                      as ImageProvider,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    driver?.fullName.isNotEmpty == true
                        ? driver!.fullName
                        : AppStrings.driver,
                    style: AppTextStyles.h3(color: Colors.white),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Container(
                        width: 8.r,
                        height: 8.r,
                        decoration: BoxDecoration(
                          color: isOnline
                              ? const Color(0xFF6AE2AB)
                              : Colors.white38,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        isOnline ? 'متصل — يستقبل الطلبات' : 'غير متصل',
                        style: AppTextStyles.caption(color: Colors.white70),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: 12.w),
            _OnlineSwitch(
              isOnline: isOnline,
              onTap: controller.toggleOnlineStatus,
            ),
          ],
        ),
      );
    });
  }
}

// ── Online Switch ─────────────────────────────────────────────────────────────

class _OnlineSwitch extends StatelessWidget {
  const _OnlineSwitch({
    required this.isOnline,
    required this.onTap,
  });

  final bool isOnline;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 240),
        width: 54.w,
        height: 30.h,
        padding: EdgeInsets.all(4.r),
        decoration: BoxDecoration(
          color: isOnline ? Colors.white : Colors.white24,
          borderRadius: BorderRadius.circular(999.r),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 240),
          curve: Curves.easeOut,
          alignment: isOnline ? Alignment.centerRight : Alignment.centerLeft,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: isOnline ? AppColors.primary : Colors.white54,
              shape: BoxShape.circle,
            ),
            child: SizedBox.square(dimension: 22.r),
          ),
        ),
      ),
    );
  }
}

// ── Tab Bar with counts ───────────────────────────────────────────────────────

class _HomeTabBar extends StatelessWidget {
  const _HomeTabBar({required this.controller});

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    final tabs = [
      (label: 'الجديدة', count: controller.newOrders.length),
      (label: 'النشطة', count: controller.activeOrders.length),
      (label: 'السابقة', count: controller.previousOrders.length),
    ];
    final current = controller.currentTab.value;

    return SizedBox(
      height: 42.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: tabs.length,
        separatorBuilder: (_, __) => SizedBox(width: 8.w),
        itemBuilder: (_, index) {
          final tab = tabs[index];
          final isActive = index == current;

          return GestureDetector(
            onTap: () => controller.currentTab.value = index,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              decoration: BoxDecoration(
                color: isActive ? AppColors.primary : AppColors.grey100,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    tab.label,
                    style: AppTextStyles.bodySemiBold(
                      color: isActive ? Colors.white : AppColors.grey600,
                    ),
                  ),
                  if (tab.count > 0) ...[
                    SizedBox(width: 6.w),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 7.w,
                        vertical: 2.h,
                      ),
                      decoration: BoxDecoration(
                        color: isActive
                            ? Colors.white.withValues(alpha: 0.25)
                            : AppColors.primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(99),
                      ),
                      child: Text(
                        '${tab.count}',
                        style: AppTextStyles.caption(
                          color: isActive ? Colors.white : AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ── Orders Tab Content ────────────────────────────────────────────────────────

class _OrdersTabContent extends StatelessWidget {
  const _OrdersTabContent({required this.controller});

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    if (controller.isLoading.value) {
      return const LoadingWidget(message: 'جاري تحميل الطلبات...');
    }

    return switch (controller.currentTab.value) {
      0 => _OrdersList(
          orders: controller.newOrders,
          emptyMessage: 'لا توجد طلبات جديدة',
          emptySubMessage: controller.isOnline
              ? 'سيظهر هنا الطلبات المعروضة عليك فور وصولها.'
              : 'قم بتفعيل وضع الاتصال لاستقبال الطلبات.',
          emptyIcon: Icons.inbox_outlined,
          isNew: true,
          controller: controller,
        ),
      1 => _OrdersList(
          orders: controller.activeOrders,
          emptyMessage: 'لا توجد طلبات نشطة',
          emptySubMessage: 'اقبل طلباً جديداً وسيظهر هنا.',
          emptyIcon: Icons.local_shipping_outlined,
          controller: controller,
        ),
      2 => _OrdersList(
          orders: controller.previousOrders,
          emptyMessage: 'لا توجد طلبات سابقة',
          emptySubMessage: 'ستظهر هنا الطلبات المكتملة والملغاة.',
          emptyIcon: Icons.history_outlined,
          controller: controller,
        ),
      _ => const SizedBox.shrink(),
    };
  }
}

// ── Orders List ───────────────────────────────────────────────────────────────

class _OrdersList extends StatelessWidget {
  const _OrdersList({
    required this.orders,
    required this.emptyMessage,
    required this.emptyIcon,
    required this.controller,
    this.emptySubMessage,
    this.isNew = false,
  });

  final List<OrderModel> orders;
  final String emptyMessage;
  final String? emptySubMessage;
  final IconData emptyIcon;
  final HomeController controller;
  final bool isNew;

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) {
      return EmptyStateWidget(
        message: emptyMessage,
        subMessage: emptySubMessage,
        icon: emptyIcon,
      );
    }

    return ListView.separated(
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
