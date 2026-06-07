import 'package:cached_network_image/cached_network_image.dart';
import 'package:driver/core/constants/app_assets.dart';
import 'package:driver/core/theme/app_colors.dart';
import 'package:driver/core/widgets/reusables/reusable_notification.dart';
import 'package:driver/core/widgets/reusables/reusable_switch.dart';
import 'package:driver/core/widgets/reusables/reusable_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DriverHeader extends StatelessWidget {
  const DriverHeader({
    super.key,
    required this.username,
    required this.isVerified,
    required this.isOnline,
    this.profilePictureUrl,
    this.notificationCount = 0,
    this.onTapNotification,
    this.onToggleOnline,
  });

  final String username;
  final bool isVerified;
  final bool isOnline;
  final String? profilePictureUrl;
  final int notificationCount;
  final VoidCallback? onTapNotification;
  final VoidCallback? onToggleOnline;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final activationColor = isVerified ? AppColors.success : AppColors.warning;
    final activationText = isVerified
        ? 'driver.verified_account'.tr()
        : 'driver.pending_activation'.tr();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 10.h),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                DriverAvatar(profilePictureUrl: profilePictureUrl),
                SizedBox(width: 10.w),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ReusableText.caption(
                        text: 'driver.welcome'.tr(),
                        color: AppColors.grey500,
                      ),
                      SizedBox(height: 2.h),
                      ReusableText.bodySemiBold(
                        text: username,
                        fontSize: 15.sp,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 2.h),
                      Row(
                        children: [
                          Container(
                            width: 6.r,
                            height: 6.r,
                            decoration: BoxDecoration(
                              color: activationColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 4.w),
                          Flexible(
                            child: ReusableText.caption(
                              text: activationText,
                              color: activationColor,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          _OnlineStatusBadge(
            isOnline: isOnline,
            isDark: isDark,
            onToggleOnline: onToggleOnline,
          ),
          SizedBox(width: 6.w),
          ReusableNotification(
            onTap: onTapNotification ?? () {},
            count: notificationCount,
          ),
        ],
      ),
    );
  }
}

class DriverAvatar extends StatelessWidget {
  const DriverAvatar({super.key, this.profilePictureUrl});

  final String? profilePictureUrl;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final avatarBg = isDark ? AppColors.greyDark200 : AppColors.grey200;

    return Container(
      width: 46.r,
      height: 46.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: avatarBg,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipOval(
        child: _DriverAvatarImage(profilePictureUrl: profilePictureUrl),
      ),
    );
  }
}

class _DriverAvatarImage extends StatelessWidget {
  const _DriverAvatarImage({this.profilePictureUrl});

  final String? profilePictureUrl;

  @override
  Widget build(BuildContext context) {
    final imageUrl = profilePictureUrl;
    if (imageUrl != null && imageUrl.startsWith('http')) {
      return CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.cover,
        placeholder: (_, __) => _placeholder,
        errorWidget: (_, __, ___) => _placeholder,
      );
    }

    return _placeholder;
  }

  Widget get _placeholder {
    return Image.asset(
      AppAssets.userPlaceholder,
      fit: BoxFit.cover,
    );
  }
}

class _OnlineStatusBadge extends StatelessWidget {
  const _OnlineStatusBadge({
    required this.isOnline,
    required this.isDark,
    this.onToggleOnline,
  });

  final bool isOnline;
  final bool isDark;
  final VoidCallback? onToggleOnline;

  @override
  Widget build(BuildContext context) {
    final onlineBadgeBg = isOnline
        ? AppColors.success.withValues(alpha: isDark ? 0.15 : 0.12)
        : (isDark ? AppColors.greyDark100 : AppColors.grey100);
    final onlineBadgeBorder = isOnline
        ? AppColors.success.withValues(alpha: 0.25)
        : (isDark ? AppColors.greyDark200 : AppColors.grey200);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 240),
      width: isOnline ? 100.w : 120.w,
      height: 38.h,
      decoration: BoxDecoration(
        color: onlineBadgeBg,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: onlineBadgeBorder,
          width: 1.2,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ReusableText(
            text: isOnline ? 'driver.online'.tr() : 'driver.offline'.tr(),
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.bold,
              color: isOnline
                  ? AppColors.success
                  : (isDark ? AppColors.greyDark600 : AppColors.grey600),
            ),
          ),
          SizedBox(width: 6.w),
          ReusableSwitch(
            value: isOnline,
            onChanged:
                onToggleOnline != null ? (_) => onToggleOnline!() : (_) {},
            width: 42.w,
            height: 22.h,
            activeColor: AppColors.success,
            inactiveColor: AppColors.grey400,
            activeThumbColor: Colors.white,
            inactiveThumbColor: isDark ? AppColors.greyDark900 : Colors.white,
          ),
        ],
      ),
    );
  }
}
