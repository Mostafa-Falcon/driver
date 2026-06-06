import 'dart:ui';
import 'package:driver/app/routes/app_pages.dart';
import 'package:driver/core/theme/app_colors.dart';
import 'package:driver/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    required this.body,
    this.title,
    this.subtitle,
    this.actions = const [],
    this.bottomNavigationBar,
    this.extendBody = false,
    this.useSafeArea = true,
    this.padding,
    this.backgroundColor,
  });

  final Widget body;
  final String? title;
  final String? subtitle;
  final List<Widget> actions;
  final Widget? bottomNavigationBar;
  final bool extendBody;
  final bool useSafeArea;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final content = Padding(
      padding: padding ?? EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 16.h),
      child: body,
    );

    final String currentRoute = Get.currentRoute;
    final bool showNavBar = currentRoute == AppRoutes.home ||
        currentRoute == AppRoutes.wallet ||
        currentRoute == AppRoutes.editProfile;

    return Scaffold(
      backgroundColor:
          backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
      extendBody: extendBody || showNavBar,
      appBar: title == null
          ? null
          : AppBar(
              titleSpacing: 16.w,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title!,
                    style: AppTextStyles.h3(
                      isDark:
                          Theme.of(context).brightness == Brightness.dark,
                    ),
                  ),
                  if (subtitle != null) ...[
                    SizedBox(height: 2.h),
                    Text(
                      subtitle!,
                      style: AppTextStyles.caption(
                          color: AppColors.grey500,
                          isDark: Theme.of(context).brightness ==
                              Brightness.dark,
                      ),
                    ),
                  ],
                ],
              ),
              actions: actions,
            ),
      bottomNavigationBar: bottomNavigationBar ??
          (showNavBar ? const _CustomBottomNavBar() : null),
      body: useSafeArea ? SafeArea(child: content) : content,
    );
  }
}

class _CustomBottomNavBar extends StatelessWidget {
  const _CustomBottomNavBar();

  @override
  Widget build(BuildContext context) {
    final String currentRoute = Get.currentRoute;

    int currentIndex = 0;
    if (currentRoute == AppRoutes.wallet) {
      currentIndex = 1;
    } else if (currentRoute == AppRoutes.editProfile) {
      currentIndex = 2;
    }

    final items = [
      (
        icon: Icons.local_shipping_outlined,
        activeIcon: Icons.local_shipping,
        label: 'طلباتي',
        route: AppRoutes.home,
      ),
      (
        icon: Icons.account_balance_wallet_outlined,
        activeIcon: Icons.account_balance_wallet,
        label: 'المحفظة',
        route: AppRoutes.wallet,
      ),
      (
        icon: Icons.person_outline_rounded,
        activeIcon: Icons.person_rounded,
        label: 'حسابي',
        route: AppRoutes.editProfile,
      ),
    ];

    return Container(
      margin: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 20.h),
      height: 68.h,
      decoration: BoxDecoration(
        color: Colors.transparent,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24.r),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.surfaceDark.withValues(alpha: 0.85)
                  : Colors.white.withValues(alpha: 0.85),
              borderRadius: BorderRadius.circular(24.r),
              border: Border.all(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white.withValues(alpha: 0.15)
                    : Colors.white.withValues(alpha: 0.45),
                width: 1.5,
              ),
            ),
            child: Stack(
              children: [
                // Active Sliding Capsule
                AnimatedAlign(
                  alignment:
                      AlignmentDirectional(-1.0 + currentIndex * 1.0, 0.0),
                  duration: const Duration(milliseconds: 320),
                  curve: Curves.easeOutBack,
                  child: FractionallySizedBox(
                    widthFactor: 0.31,
                    child: Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 6.h, horizontal: 4.w),
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(18.r),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Items
                Row(
                  children: List.generate(items.length, (index) {
                    final item = items[index];
                    final isSelected = index == currentIndex;

                    return _CustomBottomNavBarItem(
                      icon: item.icon,
                      activeIcon: item.activeIcon,
                      label: item.label,
                      isSelected: isSelected,
                      onTap: () {
                        if (isSelected) return;
                        Get.offAllNamed(item.route);
                      },
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CustomBottomNavBarItem extends StatelessWidget {
  const _CustomBottomNavBarItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedRotation(
                turns: isSelected ? 0.015 : 0.0,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutBack,
                child: AnimatedScale(
                  scale: isSelected ? 1.12 : 1.0,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutBack,
                  child: Icon(
                    isSelected ? activeIcon : icon,
                    color: isSelected ? Colors.white : AppColors.grey500,
                    size: 22.r,
                  ),
                ),
              ),
              AnimatedSize(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                child: isSelected
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(width: 6.w),
                          Text(
                            label,
                            style: AppTextStyles.bodySemiBold(
                              color: Colors.white,
                            ).copyWith(fontSize: 12.sp),
                          ),
                        ],
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
