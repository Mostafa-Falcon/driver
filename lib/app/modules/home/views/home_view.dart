import 'package:driver/app/modules/home/controllers/home_controller.dart';
import 'package:driver/app/modules/home/views/widgets/header.dart';
import 'package:driver/app/modules/home/views/widgets/home_tab_bar.dart';
import 'package:driver/app/modules/home/views/widgets/orders_tab_content.dart';
import 'package:driver/app/routes/app_pages.dart';
import 'package:driver/core/constants/app_assets.dart';
import 'package:driver/core/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Column(
        children: [
          Obx(
            () => HeaderWidgets(
              userIcon: ClipOval(
                child: controller.driver?.profilePictureURL != null &&
                        controller.driver!.profilePictureURL!.startsWith('http')
                    ? CachedNetworkImage(
                        imageUrl: controller.driver!.profilePictureURL!,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Image.asset(
                          AppAssets.userPlaceholder,
                          fit: BoxFit.cover,
                        ),
                        errorWidget: (context, url, error) => Image.asset(
                          AppAssets.userPlaceholder,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Image.asset(
                        AppAssets.userPlaceholder,
                        fit: BoxFit.cover,
                      ),
              ),
              username: controller.driver?.fullName ?? 'السائق',
              userActivetion: controller.driver?.isDocumentVerify == true
                  ? 'حساب مفعل'
                  : 'قيد التفعيل',
              isOnline: controller.isOnline.value,
              onTapIsOnline: controller.toggleOnlineStatus,
              notificationCount: controller.unreadNotificationsCount.value,
              onTapNotification: () => Get.toNamed(AppRoutes.notifications),
            ),
          ),
          SizedBox(height: 14.h),
          HomeTabBar(controller: controller),
          SizedBox(height: 14.h),
          Expanded(
            child: OrdersTabContent(controller: controller),
          ),
        ],
      ),
    );
  }
}
