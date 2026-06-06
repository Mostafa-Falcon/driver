import 'package:driver/app/data/models/user_model.dart';
import 'package:driver/app/modules/profile/controllers/profile_controller.dart';
import 'package:driver/core/constants/app_assets.dart';
import 'package:driver/core/constants/app_strings.dart';
import 'package:driver/core/theme/app_colors.dart';
import 'package:driver/core/theme/app_text_styles.dart';
import 'package:driver/core/widgets/app_button.dart';
import 'package:driver/core/widgets/app_card.dart';
import 'package:driver/core/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final driver = controller.auth.user;

    return AppScaffold(
      title: 'حساب السائق',
      subtitle: 'البيانات وإحصائيات التشغيل',
      body: ListView(
        children: [
          // ── بطاقة الهوية ───────────────────────────────────────
          AppCard(
            padding: EdgeInsets.all(20.r),
            child: Column(
              children: [
                // صورة + اسم + حالة
                Row(
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 36.r,
                          backgroundColor: AppColors.primary50,
                          backgroundImage: driver?.profilePictureURL != null
                              ? NetworkImage(driver!.profilePictureURL!)
                              : const AssetImage(AppAssets.userPlaceholder)
                                  as ImageProvider,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 14.r,
                            height: 14.r,
                            decoration: BoxDecoration(
                              color: driver?.isOnline == true
                                  ? AppColors.success
                                  : AppColors.grey300,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.surface,
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 14.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            driver?.fullName.isNotEmpty == true
                                ? driver!.fullName
                                : AppStrings.driver,
                            style: AppTextStyles.h3(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            driver?.phoneNumber ?? 'لا يوجد رقم هاتف',
                            style: AppTextStyles.body(color: AppColors.grey500),
                          ),
                          if (driver?.email != null) ...[
                            SizedBox(height: 2.h),
                            Text(
                              driver!.email!,
                              style: AppTextStyles.caption(
                                color: AppColors.grey400,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
                // تقييم النجوم
                if ((driver?.averageRating ?? 0) > 0) ...[
                  SizedBox(height: 14.h),
                  Row(
                    children: [
                      RatingBarIndicator(
                        rating: driver!.averageRating,
                        itemBuilder: (_, __) => const Icon(
                          Icons.star_rounded,
                          color: AppColors.warning,
                        ),
                        itemCount: 5,
                        itemSize: 20.r,
                        direction: Axis.horizontal,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        '${driver.averageRating.toStringAsFixed(1)} (${driver.reviewsCount ?? 0})',
                        style: AppTextStyles.captionMedium(
                          color: AppColors.grey600,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          SizedBox(height: 12.h),

          // ── بطاقة المركبة ──────────────────────────────────────
          if (driver?.carName != null ||
              driver?.vehicleType != null ||
              driver?.carNumber != null)
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.local_shipping_outlined,
                        color: AppColors.primary,
                        size: 20.r,
                      ),
                      SizedBox(width: 8.w),
                      Text('بيانات المركبة', style: AppTextStyles.h3()),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  if (driver?.vehicleType?.isNotEmpty == true)
                    _InfoRow(
                      icon: Icons.category_outlined,
                      label: 'النوع',
                      value: driver!.vehicleType!,
                    ),
                  if (driver?.carName?.isNotEmpty == true)
                    _InfoRow(
                      icon: Icons.directions_car_outlined,
                      label: 'الموديل',
                      value: driver!.carName!,
                    ),
                  if (driver?.carNumber?.isNotEmpty == true)
                    _InfoRow(
                      icon: Icons.confirmation_number_outlined,
                      label: 'رقم اللوحة',
                      value: driver!.carNumber!,
                    ),
                ],
              ),
            ),
          if (driver?.carName != null ||
              driver?.vehicleType != null ||
              driver?.carNumber != null)
            SizedBox(height: 12.h),

          // ── إحصائيات التشغيل ───────────────────────────────────
          _StatsSection(driver: driver),
          SizedBox(height: 20.h),

          // ── تسجيل الخروج ───────────────────────────────────────
          AppButton(
            label: 'تسجيل الخروج',
            onPressed: controller.signOut,
            isOutlined: true,
            icon: const Icon(Icons.logout_rounded, color: AppColors.primary),
          ),
          SizedBox(height: 8.h),
        ]
            .animate(interval: 50.ms)
            .fadeIn(duration: 220.ms)
            .slideY(begin: 0.03, end: 0, curve: Curves.easeOut),
      ),
    );
  }
}

// ── Stats Section ─────────────────────────────────────────────────────────────

class _StatsSection extends StatelessWidget {
  const _StatsSection({required this.driver});

  final UserModel? driver;

  @override
  Widget build(BuildContext context) {
    final rating = driver?.averageRating ?? 0.0;
    final walletAmount = (driver?.walletAmount ?? 0).toDouble();
    final isVerified = driver?.isDocumentVerify == true;
    final isOnline = driver?.isOnline == true;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 4.h),
          child: Text(
            'إحصائيات التشغيل',
            style: AppTextStyles.h3(color: AppColors.grey700),
          ),
        ),
        SizedBox(height: 10.h),
        Row(
          children: [
            Expanded(
              child: _StatCard(
                label: 'التقييم',
                value: rating > 0 ? rating.toStringAsFixed(1) : '—',
                icon: Icons.star_rounded,
                iconColor: AppColors.warning,
                subLabel: 'من 5',
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: _StatCard(
                label: 'المحفظة',
                value: walletAmount.toStringAsFixed(0),
                icon: Icons.account_balance_wallet_outlined,
                iconColor: AppColors.primary,
                subLabel: AppStrings.currencySuffix,
              ),
            ),
          ],
        ),
        SizedBox(height: 10.h),
        Row(
          children: [
            Expanded(
              child: _StatCard(
                label: 'الحالة',
                value: isOnline ? 'متصل' : 'غير متصل',
                icon: Icons.circle,
                iconColor: isOnline ? AppColors.success : AppColors.grey400,
                subLabel: isOnline ? 'يستقبل الطلبات' : 'لا يستقبل طلبات',
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: _StatCard(
                label: 'التحقق',
                value: isVerified ? 'موثق' : 'قيد المراجعة',
                icon: isVerified
                    ? Icons.verified_rounded
                    : Icons.pending_outlined,
                iconColor: isVerified ? AppColors.success : AppColors.warning,
                subLabel: isVerified ? 'حساب مفعّل' : 'في انتظار التفعيل',
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ── Stat Card ─────────────────────────────────────────────────────────────────

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.iconColor,
    required this.subLabel,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color iconColor;
  final String subLabel;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 18.r),
              SizedBox(width: 6.w),
              Text(
                label,
                style: AppTextStyles.caption(color: AppColors.grey500),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            value,
            style: AppTextStyles.h2(color: AppColors.grey900),
          ),
          SizedBox(height: 2.h),
          Text(
            subLabel,
            style: AppTextStyles.caption(color: AppColors.grey400),
          ),
        ],
      ),
    );
  }
}

// ── Info Row ──────────────────────────────────────────────────────────────────

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Row(
        children: [
          Icon(icon, color: AppColors.grey400, size: 18.r),
          SizedBox(width: 10.w),
          Text(
            '$label: ',
            style: AppTextStyles.body(color: AppColors.grey500),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.bodySemiBold(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
