import 'dart:io';

import 'package:driver/app/data/models/user_model.dart';
import 'package:driver/app/modules/profile/controllers/profile_controller.dart';
import 'package:driver/core/theme/app_colors.dart';
import 'package:driver/core/theme/app_text_styles.dart';
import 'package:driver/core/widgets/app_button.dart';
import 'package:driver/core/widgets/app_text_field.dart';
import 'package:driver/core/widgets/driver_header.dart';
import 'package:driver/core/widgets/reusables/reusable_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart' hide Trans;
import 'package:image_picker/image_picker.dart';

// ── 1. My Account Details & Vehicle Info Sheet ───────────────────────────────
class MyAccountSheet extends StatelessWidget {
  const MyAccountSheet({
    super.key,
    required this.controller,
    required this.driver,
  });

  final ProfileController controller;
  final UserModel? driver;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final height = MediaQuery.sizeOf(context).height * 0.92;

    return SizedBox(
      height: height,
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.backgroundDark : AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(26.r)),
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 0),
              child: const _SheetGrabber(),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 0),
              child: _AccountSheetHeader(onClose: Get.back),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 20.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ProfileSummaryCard(driver: driver),
                    SizedBox(height: 22.h),
                    Row(
                      children: [
                        Expanded(
                          child: _AccountStatCard(
                            value: _formatNumber(driver?.totalOrders),
                            label: 'profile.total_trips'.tr(),
                            color: isDark
                                ? AppColors.greyDark100
                                : const Color(0xFFF6F7F6),
                            valueColor: isDark
                                ? AppColors.greyDark900
                                : AppColors.grey900,
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: _AccountStatCard(
                            value: '${driver?.acceptanceRate.round() ?? 0}%',
                            label: 'profile.acceptance_rate'.tr(),
                            color: isDark
                                ? AppColors.primary500.withValues(alpha: 0.28)
                                : AppColors.primary50,
                            valueColor: AppColors.primary,
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: _AccountStatCard(
                            value: '${driver?.cancellationRate.round() ?? 0}%',
                            label: 'profile.cancel_rate'.tr(),
                            color: isDark
                                ? AppColors.danger.withValues(alpha: 0.14)
                                : AppColors.danger50,
                            valueColor: AppColors.danger,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    _VehicleLicenseCard(driver: driver),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 18.h),
              decoration: BoxDecoration(
                color: isDark ? AppColors.backgroundDark : AppColors.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.18 : 0.05),
                    blurRadius: 18,
                    offset: const Offset(0, -8),
                  ),
                ],
              ),
              child: AppButton(
                label: 'profile.edit_account'.tr(),
                borderRadius: 10,
                onPressed: () {
                  Get.bottomSheet(
                    EditProfileSheet(controller: controller),
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatNumber(num? value) => (value ?? 0).round().toString();
}

class _SheetGrabber extends StatelessWidget {
  const _SheetGrabber();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 42.w,
        height: 4.h,
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? AppColors.greyDark300
              : AppColors.grey200,
          borderRadius: BorderRadius.circular(999.r),
        ),
      ),
    );
  }
}

class _AccountSheetHeader extends StatelessWidget {
  const _AccountSheetHeader({required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        ReusableText.h3(text: 'profile.account'.tr()),
        const Spacer(),
        InkWell(
          onTap: onClose,
          borderRadius: BorderRadius.circular(12.r),
          child: Container(
            width: 42.r,
            height: 42.r,
            decoration: BoxDecoration(
              color: isDark ? AppColors.greyDark100 : AppColors.grey50,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: isDark ? AppColors.greyDark200 : AppColors.grey100,
              ),
            ),
            child: Icon(
              Icons.chevron_left_rounded,
              color: isDark ? AppColors.greyDark600 : AppColors.grey700,
              size: 22.r,
            ),
          ),
        ),
      ],
    );
  }
}

class _ProfileSummaryCard extends StatelessWidget {
  const _ProfileSummaryCard({required this.driver});

  final UserModel? driver;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isVerified = driver?.isDocumentVerify == true;
    final phone = driver?.phoneNumber;

    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: isDark ? AppColors.greyDark100 : Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: isDark
              ? AppColors.greyDark200
              : AppColors.grey100.withValues(alpha: 0.7),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.12 : 0.035),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          DriverAvatar(profilePictureUrl: driver?.profilePictureURL),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ReusableText.bodySemiBold(
                  text: driver?.fullName.isNotEmpty == true
                      ? driver!.fullName
                      : 'driver.default_name'.tr(),
                  fontSize: 15.sp,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                ReusableText.caption(
                  text: phone?.isNotEmpty == true
                      ? phone!
                      : 'profile.no_phone'.tr(),
                  color: isDark ? AppColors.greyDark500 : AppColors.grey500,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    _MiniBadge(
                      text: isVerified
                          ? 'profile.verified'.tr()
                          : 'driver.pending_activation'.tr(),
                      color: isVerified ? AppColors.success : AppColors.warning,
                    ),
                    if ((driver?.averageRating ?? 0) > 0) ...[
                      SizedBox(width: 6.w),
                      _MiniBadge(
                        text: '${driver!.averageRating.toStringAsFixed(1)} ★',
                        color: AppColors.warning,
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          ReusableText.caption(
            text: _memberSinceText(driver),
            color: isDark ? AppColors.greyDark500 : AppColors.grey500,
            maxLines: 1,
          ),
        ],
      ),
    );
  }

  String _memberSinceText(UserModel? driver) {
    final createdAt = driver?.createdAt?.toDate();
    if (createdAt == null) return 'common.new_member'.tr();

    final days = DateTime.now().difference(createdAt).inDays;
    if (days <= 0) return 'common.today'.tr();
    if (days < 7) {
      return 'profile.member_since_day'.tr(namedArgs: {'count': '$days'});
    }
    if (days < 30) {
      return 'profile.member_since_week'.tr(
        namedArgs: {'count': '${(days / 7).floor()}'},
      );
    }
    if (days < 365) {
      return 'profile.member_since_month'.tr(
        namedArgs: {'count': '${(days / 30).floor()}'},
      );
    }
    return 'profile.member_since_year'.tr(
      namedArgs: {'count': '${(days / 365).floor()}'},
    );
  }
}

class _MiniBadge extends StatelessWidget {
  const _MiniBadge({
    required this.text,
    required this.color,
  });

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999.r),
      ),
      child: ReusableText.captionMedium(
        text: text,
        color: color,
        fontSize: 10.sp,
      ),
    );
  }
}

class _AccountStatCard extends StatelessWidget {
  const _AccountStatCard({
    required this.value,
    required this.label,
    required this.color,
    required this.valueColor,
  });

  final String value;
  final String label;
  final Color color;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: 76.h),
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ReusableText.h3(
            text: value,
            color: valueColor,
            fontSize: 18.sp,
            align: TextAlign.center,
          ),
          SizedBox(height: 6.h),
          ReusableText.captionMedium(
            text: label,
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.greyDark500
                : AppColors.grey600,
            fontSize: 10.sp,
            align: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _VehicleLicenseCard extends StatelessWidget {
  const _VehicleLicenseCard({required this.driver});

  final UserModel? driver;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final vehicleName = _firstNotEmpty([
      driver?.carName,
      driver?.vehicleType,
      'profile.my_vehicle'.tr(),
    ]);
    final vehicleType = _firstNotEmpty([
      driver?.vehicleType,
      'profile.vehicle_type_missing'.tr(),
    ]);
    final licenseCode = _firstNotEmpty([
      driver?.vehicleLicenseNumber,
      driver?.driverLicenseNumber,
      driver?.carNumber,
      'profile.unavailable'.tr(),
    ]);

    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: isDark ? AppColors.greyDark100 : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isDark ? AppColors.greyDark200 : AppColors.grey200,
          style: BorderStyle.solid,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 52.r,
            height: 52.r,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: ClipOval(
              child: driver?.carPictureURL?.startsWith('http') == true
                  ? Image.network(
                      driver!.carPictureURL!,
                      fit: BoxFit.cover,
                    )
                  : Icon(
                      Icons.two_wheeler_rounded,
                      color: AppColors.primary,
                      size: 28.r,
                    ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ReusableText.bodySemiBold(
                  text: vehicleName,
                  fontSize: 14.sp,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                ReusableText.caption(
                  text: vehicleType,
                  color: isDark ? AppColors.greyDark500 : AppColors.grey500,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          SizedBox(width: 10.w),
          ReusableText.captionMedium(
            text: licenseCode,
            color: isDark ? AppColors.greyDark500 : AppColors.grey600,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  String _firstNotEmpty(List<String?> values) {
    for (final value in values) {
      if (value != null && value.trim().isNotEmpty) return value.trim();
    }
    return '';
  }
}

class EditProfileSheet extends StatefulWidget {
  const EditProfileSheet({super.key, required this.controller});

  final ProfileController controller;

  @override
  State<EditProfileSheet> createState() => _EditProfileSheetState();
}

class _EditProfileSheetState extends State<EditProfileSheet> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _vehicleTypeController = TextEditingController();
  final _carNameController = TextEditingController();
  final _carNumberController = TextEditingController();
  final _imagePicker = ImagePicker();

  XFile? _profileImage;
  XFile? _vehicleImage;

  @override
  void initState() {
    super.initState();
    final driver = widget.controller.auth.user;
    _firstNameController.text = driver?.firstName ?? '';
    _lastNameController.text = driver?.lastName ?? '';
    _vehicleTypeController.text = driver?.vehicleType ?? '';
    _carNameController.text = driver?.carName ?? '';
    _carNumberController.text = driver?.carNumber ?? '';
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _vehicleTypeController.dispose();
    _carNameController.dispose();
    _carNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final driver = widget.controller.auth.user;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.92,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.greyDark100 : AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(26.r)),
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(
            20.w,
            14.h,
            20.w,
            MediaQuery.viewInsetsOf(context).bottom + 20.h,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _SheetGrabber(),
              SizedBox(height: 18.h),
              Row(
                children: [
                  ReusableText.h3(text: 'profile.edit_sheet_title'.tr()),
                  const Spacer(),
                  IconButton(
                    onPressed: Get.back,
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
              SizedBox(height: 18.h),
              Row(
                children: [
                  Expanded(
                    child: _EditableImageTile(
                      title: 'profile.profile_photo'.tr(),
                      localImage: _profileImage,
                      imageUrl: driver?.profilePictureURL,
                      icon: Icons.person_rounded,
                      onTap: () => _pickImage(isVehicle: false),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: _EditableImageTile(
                      title: 'profile.vehicle_photo'.tr(),
                      localImage: _vehicleImage,
                      imageUrl: driver?.carPictureURL,
                      icon: Icons.two_wheeler_rounded,
                      onTap: () => _pickImage(isVehicle: true),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 18.h),
              Row(
                children: [
                  Expanded(
                    child: AppTextField(
                      controller: _firstNameController,
                      hintText: 'profile.first_name'.tr(),
                      validator: _requiredValidator,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: AppTextField(
                      controller: _lastNameController,
                      hintText: 'profile.last_name'.tr(),
                      validator: _requiredValidator,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              AppTextField(
                controller: _vehicleTypeController,
                hintText: 'profile.vehicle_type'.tr(),
                prefixIcon: const Icon(Icons.local_shipping_outlined),
              ),
              SizedBox(height: 12.h),
              AppTextField(
                controller: _carNameController,
                hintText: 'profile.vehicle_model'.tr(),
                prefixIcon: const Icon(Icons.directions_car_outlined),
              ),
              SizedBox(height: 12.h),
              AppTextField(
                controller: _carNumberController,
                hintText: 'profile.plate_number'.tr(),
                prefixIcon: const Icon(Icons.confirmation_number_outlined),
              ),
              SizedBox(height: 22.h),
              Obx(
                () => AppButton(
                  label: 'profile.save_changes'.tr(),
                  isLoading: widget.controller.isUpdatingProfile.value,
                  onPressed: _submit,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? _requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'profile.required_field'.tr();
    }
    return null;
  }

  Future<void> _pickImage({required bool isVehicle}) async {
    final source = await Get.bottomSheet<ImageSource>(
      Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(22.r)),
        ),
        padding: EdgeInsets.fromLTRB(22.w, 16.h, 22.w, 24.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const _SheetGrabber(),
            SizedBox(height: 18.h),
            ReusableText.bodySemiBold(
              text: 'profile.pick_source'.tr(),
              fontSize: 16.sp,
            ),
            SizedBox(height: 16.h),
            Row(
              children: [
                Expanded(
                  child: _ImageSourceButton(
                    icon: Icons.camera_alt_rounded,
                    label: 'profile.camera'.tr(),
                    onTap: () => Get.back(result: ImageSource.camera),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _ImageSourceButton(
                    icon: Icons.photo_library_rounded,
                    label: 'profile.gallery'.tr(),
                    onTap: () => Get.back(result: ImageSource.gallery),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
    );

    if (source == null) return;
    final image = await _imagePicker.pickImage(
      source: source,
      imageQuality: 82,
      maxWidth: 1600,
    );
    if (image == null) return;

    setState(() {
      if (isVehicle) {
        _vehicleImage = image;
      } else {
        _profileImage = image;
      }
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await widget.controller.updateProfileDetails(
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      vehicleType: _vehicleTypeController.text.trim(),
      carName: _carNameController.text.trim(),
      carNumber: _carNumberController.text.trim(),
      profileImage: _profileImage,
      vehicleImage: _vehicleImage,
    );

    if (success) {
      Get.back();
      Get.back();
      Get.snackbar(
        'profile.edit_account'.tr(),
        'profile.update_success'.tr(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.primary,
        colorText: Colors.white,
      );
    } else {
      Get.snackbar(
        'profile.edit_account'.tr(),
        'profile.update_failed'.tr(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.danger,
        colorText: Colors.white,
      );
    }
  }
}

class _EditableImageTile extends StatelessWidget {
  const _EditableImageTile({
    required this.title,
    required this.icon,
    required this.onTap,
    this.localImage,
    this.imageUrl,
  });

  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final XFile? localImage;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: isDark ? AppColors.greyDark200 : AppColors.grey50,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isDark ? AppColors.greyDark300 : AppColors.grey200,
          ),
        ),
        child: Column(
          children: [
            SizedBox(
              width: 74.r,
              height: 74.r,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.r),
                child: _buildPreview(),
              ),
            ),
            SizedBox(height: 10.h),
            ReusableText.captionMedium(
              text: title,
              align: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreview() {
    if (localImage != null) {
      return Image.file(
        File(localImage!.path),
        fit: BoxFit.cover,
      );
    }

    if (imageUrl != null && imageUrl!.startsWith('http')) {
      return Image.network(
        imageUrl!,
        fit: BoxFit.cover,
      );
    }

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
      ),
      child: Icon(
        icon,
        color: AppColors.primary,
        size: 30.r,
      ),
    );
  }
}

class _ImageSourceButton extends StatelessWidget {
  const _ImageSourceButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14.r),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primary, size: 28.r),
            SizedBox(height: 8.h),
            ReusableText.bodySemiBold(text: label),
          ],
        ),
      ),
    );
  }
}

// ── 2. Change Password Sheet ─────────────────────────────────────────────────
class ChangePasswordSheet extends StatefulWidget {
  const ChangePasswordSheet({super.key, required this.controller});

  final ProfileController controller;

  @override
  State<ChangePasswordSheet> createState() => _ChangePasswordSheetState();
}

class _ChangePasswordSheetState extends State<ChangePasswordSheet> {
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _isLoading = false.obs;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 40.w,
                height: 5.h,
                decoration: BoxDecoration(
                  color: AppColors.grey300,
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
            ),
            SizedBox(height: 18.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const ReusableText.bodySemiBold(
                  text: 'تغيير كلمة المرور',
                  fontSize: 16,
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon:
                      const Icon(Icons.close_rounded, color: AppColors.grey500),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            AppTextField(
              controller: _currentPasswordController,
              hintText: 'كلمة المرور الحالية',
              obscureText: true,
              prefixIcon: const Icon(
                Icons.lock_open_rounded,
                color: AppColors.grey400,
              ),
            ),
            SizedBox(height: 12.h),
            AppTextField(
              controller: _newPasswordController,
              hintText: 'كلمة المرور الجديدة',
              obscureText: true,
              prefixIcon: const Icon(
                Icons.lock_outline_rounded,
                color: AppColors.grey400,
              ),
            ),
            SizedBox(height: 12.h),
            AppTextField(
              controller: _confirmPasswordController,
              hintText: 'تأكيد كلمة المرور الجديدة',
              obscureText: true,
              prefixIcon:
                  const Icon(Icons.lock_rounded, color: AppColors.grey400),
            ),
            SizedBox(height: 24.h),
            Obx(
              () => AppButton(
                label: 'حفظ التغييرات',
                isLoading: _isLoading.value,
                onPressed: () async {
                  final currentPassword =
                      _currentPasswordController.text.trim();
                  final newPassword = _newPasswordController.text.trim();
                  final confirmPassword =
                      _confirmPasswordController.text.trim();

                  if (currentPassword.isEmpty ||
                      newPassword.isEmpty ||
                      confirmPassword.isEmpty) {
                    Get.snackbar(
                      'خطأ',
                      'يرجى ملء جميع الحقول المطلوبة',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: AppColors.danger,
                      colorText: Colors.white,
                    );
                    return;
                  }

                  if (newPassword.length < 6) {
                    Get.snackbar(
                      'خطأ',
                      'كلمة المرور يجب أن لا تقل عن 6 أحرف',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: AppColors.danger,
                      colorText: Colors.white,
                    );
                    return;
                  }

                  if (newPassword != confirmPassword) {
                    Get.snackbar(
                      'خطأ',
                      'تأكيد كلمة المرور غير متطابق',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: AppColors.danger,
                      colorText: Colors.white,
                    );
                    return;
                  }

                  _isLoading.value = true;
                  final success = await widget.controller.changePassword(
                    currentPassword,
                    newPassword,
                  );
                  _isLoading.value = false;

                  if (success) {
                    Get.back();
                    Get.snackbar(
                      'نجاح',
                      'تم تغيير كلمة المرور بنجاح',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: AppColors.success,
                      colorText: Colors.white,
                    );
                  } else {
                    Get.snackbar(
                      'خطأ',
                      'فشل في تغيير كلمة المرور، يرجى التحقق من كلمة المرور الحالية',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: AppColors.danger,
                      colorText: Colors.white,
                    );
                  }
                },
              ),
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}

// ── 3. Bank Accounts Sheet ───────────────────────────────────────────────────
class BankAccountsSheet extends StatefulWidget {
  const BankAccountsSheet({super.key, this.bankDetails});

  final UserBankDetails? bankDetails;

  @override
  State<BankAccountsSheet> createState() => _BankAccountsSheetState();
}

class _BankAccountsSheetState extends State<BankAccountsSheet> {
  final List<Map<String, String>> _accounts = [];

  final _bankNameController = TextEditingController();
  final _holderNameController = TextEditingController();
  final _ibanController = TextEditingController();
  bool _isAdding = false;

  @override
  void initState() {
    super.initState();

    final bankDetails = widget.bankDetails;
    if (bankDetails == null || bankDetails.accountNumber.trim().isEmpty) {
      return;
    }

    _accounts.add({
      'bankName': bankDetails.bankName.trim().isEmpty
          ? 'حساب بنكي'
          : bankDetails.bankName.trim(),
      'holderName': bankDetails.holderName.trim().isEmpty
          ? 'غير محدد'
          : bankDetails.holderName.trim(),
      'iban': bankDetails.accountNumber.trim(),
    });
  }

  @override
  void dispose() {
    _bankNameController.dispose();
    _holderNameController.dispose();
    _ibanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 40.w,
                height: 5.h,
                decoration: BoxDecoration(
                  color: AppColors.grey300,
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
            ),
            SizedBox(height: 18.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const ReusableText.bodySemiBold(
                  text: 'حساباتي المصرفية',
                  fontSize: 16,
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon:
                      const Icon(Icons.close_rounded, color: AppColors.grey500),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            if (!_isAdding) ...[
              ..._accounts.map(
                (acc) => Container(
                  margin: EdgeInsets.only(bottom: 12.h),
                  padding: EdgeInsets.all(16.r),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primary.withValues(alpha: 0.05),
                        AppColors.primary.withValues(alpha: 0.01),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(14.r),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.12),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ReusableText.bodySemiBold(
                            text: acc['bankName']!,
                            color: AppColors.primary,
                          ),
                          Icon(
                            Icons.credit_card,
                            color: AppColors.primary500,
                            size: 18.r,
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      ReusableText.body(
                        text: 'المستفيد: ${acc['holderName']!}',
                        color: Theme.of(context).brightness == Brightness.dark
                            ? AppColors.greyDark500
                            : AppColors.grey700,
                      ),
                      SizedBox(height: 4.h),
                      ReusableText.bodySemiBold(
                        text: acc['iban']!,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? AppColors.greyDark900
                            : AppColors.grey800,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              AppButton(
                label: 'إضافة حساب بنكي جديد',
                isOutlined: true,
                onPressed: () {
                  setState(() {
                    _isAdding = true;
                  });
                },
              ),
            ] else ...[
              AppTextField(
                controller: _bankNameController,
                hintText: 'اسم البنك',
                prefixIcon: const Icon(
                  Icons.account_balance_rounded,
                  color: AppColors.grey400,
                ),
              ),
              SizedBox(height: 12.h),
              AppTextField(
                controller: _holderNameController,
                hintText: 'اسم صاحب الحساب بالكامل',
                prefixIcon: const Icon(
                  Icons.person_outline_rounded,
                  color: AppColors.grey400,
                ),
              ),
              SizedBox(height: 12.h),
              AppTextField(
                controller: _ibanController,
                hintText: 'رقم الآيبان (IBAN)',
                prefixIcon: const Icon(
                  Icons.numbers_rounded,
                  color: AppColors.grey400,
                ),
              ),
              SizedBox(height: 20.h),
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      label: 'إضافة',
                      onPressed: () {
                        final bank = _bankNameController.text.trim();
                        final holder = _holderNameController.text.trim();
                        final iban = _ibanController.text.trim();

                        if (bank.isEmpty || holder.isEmpty || iban.isEmpty) {
                          Get.snackbar(
                            'خطأ',
                            'يرجى ملء كافة البيانات',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: AppColors.danger,
                            colorText: Colors.white,
                          );
                          return;
                        }

                        setState(() {
                          _accounts.add({
                            'bankName': bank,
                            'holderName': holder,
                            'iban': iban,
                          });
                          _isAdding = false;
                          _bankNameController.clear();
                          _holderNameController.clear();
                          _ibanController.clear();
                        });

                        Get.snackbar(
                          'نجاح',
                          'تمت إضافة الحساب البنكي بنجاح',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: AppColors.success,
                          colorText: Colors.white,
                        );
                      },
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: AppButton(
                      label: 'إلغاء',
                      isOutlined: true,
                      onPressed: () {
                        setState(() {
                          _isAdding = false;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ],
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}

// ── 4. Info Sheet (About Us, Terms, Privacy) ─────────────────────────────────
class InfoSheet extends StatelessWidget {
  const InfoSheet({super.key, required this.title, required this.content});

  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 40.w,
                height: 5.h,
                decoration: BoxDecoration(
                  color: AppColors.grey300,
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
            ),
            SizedBox(height: 18.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ReusableText.bodySemiBold(
                  text: title.tr(),
                  fontSize: 16,
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon:
                      const Icon(Icons.close_rounded, color: AppColors.grey500),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            ReusableText(
              text: content.tr(),
              style: AppTextStyles.body(
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.greyDark500
                    : AppColors.grey700,
              ).copyWith(
                height: 1.6,
                fontSize: 13.sp,
              ),
              align: TextAlign.justify,
            ),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }
}

// ── 5. FAQs Sheet ────────────────────────────────────────────────────────────
class FaqSheet extends StatelessWidget {
  const FaqSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final faqs = [
      {
        'q': 'كيف يمكنني سحب رصيدي؟',
        'a':
            'يمكنك تقديم طلب سحب من شاشة المحفظة عبر الضغط على زر "سحب" وتحديد المبلغ. سيتم مراجعة طلبك وتحويله لحسابك البنكي.',
      },
      {
        'q': 'كيف أقوم بشحن رصيد محفظتي؟',
        'a':
            'اضغط على زر "شحن" في المحفظة، قم بتحويل المبلغ للحساب البنكي المحدد، ثم أدخل رقم التحويل وأرفق صورة الإيصال ليتم مراجعته واعتماده.',
      },
      {
        'q': 'ماذا أفعل في حال واجهتني مشكلة في طلب فعال؟',
        'a':
            'يمكنك التواصل الفوري مع الدعم الفني عبر الضغط على "تواصل مع الدعم" في الحساب أو استخدام أيقونة الدعم، وفتح تذكرة دعم مرتبطة بالطلب ليتواصل معك الفني المختص.',
      },
      {
        'q': 'كيف يتم تفعيل حسابي بشكل كامل؟',
        'a':
            'يتطلب تفعيل الحساب رفع مستنداتك الثبوتية (الهوية، رخصة القيادة، ترخيص المركبة) والانتظار حتى تتم مراجعتها من قبل الإدارة.',
      },
    ];

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 40.w,
                height: 5.h,
                decoration: BoxDecoration(
                  color: AppColors.grey300,
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
            ),
            SizedBox(height: 18.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const ReusableText.bodySemiBold(
                  text: 'الأسئلة الشائعة',
                  fontSize: 16,
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon:
                      const Icon(Icons.close_rounded, color: AppColors.grey500),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            ...faqs.map(
              (faq) => Container(
                margin: EdgeInsets.only(bottom: 10.h),
                decoration: BoxDecoration(
                  color: (Theme.of(context).brightness == Brightness.dark
                          ? AppColors.greyDark100
                          : AppColors.grey100)
                      .withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Theme(
                  data: Theme.of(context).copyWith(
                    dividerColor: Colors.transparent,
                  ),
                  child: ExpansionTile(
                    iconColor: AppColors.primary,
                    title: ReusableText.bodySemiBold(
                      text: faq['q']!,
                      fontSize: 13.sp,
                    ),
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          left: 16.w,
                          right: 16.w,
                          bottom: 12.h,
                        ),
                        child: ReusableText(
                          text: faq['a']!,
                          style: AppTextStyles.body(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? AppColors.greyDark500
                                    : AppColors.grey600,
                          ).copyWith(
                            height: 1.5,
                            fontSize: 12.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}
