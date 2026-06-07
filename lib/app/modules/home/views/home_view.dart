import 'package:driver/app/modules/home/controllers/home_controller.dart';
import 'package:driver/app/modules/home/views/widgets/home_tab_bar.dart';
import 'package:driver/app/modules/home/views/widgets/orders_tab_content.dart';
import 'package:driver/app/routes/app_pages.dart';
import 'package:driver/core/widgets/app_scaffold.dart';
import 'package:driver/core/widgets/driver_header.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart' hide Trans;

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Column(
        children: [
          Obx(
            () {
              final driver = controller.driver;

              return DriverHeader(
                profilePictureUrl: driver?.profilePictureURL,
                username: driver?.fullName.isNotEmpty == true
                    ? driver!.fullName
                    : 'driver.default_name'.tr(),
                isVerified: driver?.isDocumentVerify == true,
                isOnline: controller.isOnline.value,
                onToggleOnline: controller.toggleOnlineStatus,
                notificationCount: controller.unreadNotificationsCount.value,
                onTapNotification: () => Get.toNamed(AppRoutes.notifications),
              );
            },
          ),
          SizedBox(height: 14.h),
          Obx(
            () => HomeTabBar(
              tabs: [
                HomeTabItem(
                  label: 'الجديدة',
                  count: controller.newOrders.length,
                ),
                HomeTabItem(
                  label: 'الحالية',
                  count: controller.activeOrders.length,
                ),
                HomeTabItem(
                  label: 'السابقة',
                  count: controller.previousOrders.length,
                ),
              ],
              currentIndex: controller.currentTab.value,
              onChanged: controller.selectTab,
            ),
          ),
          SizedBox(height: 14.h),
          Expanded(
            child: Obx(
              () => OrdersTabContent(
                isLoading: controller.isLoading.value,
                currentTab: controller.currentTab.value,
                isOnline: controller.isOnline.value,
                newOrders: controller.newOrders,
                activeOrders: controller.activeOrders,
                previousOrders: controller.previousOrders,
                onAcceptOrder: controller.acceptOrder,
                onHideOrder: controller.hideOrder,
                onTapOrder: controller.goToOrderDetails,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
