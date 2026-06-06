import 'package:driver/app/data/models/user_model.dart';
import 'package:driver/app/modules/profile/controllers/profile_controller.dart';
import 'package:driver/core/constants/app_assets.dart';
import 'package:driver/core/theme/app_colors.dart';
import 'package:driver/core/theme/app_text_styles.dart';
import 'package:driver/core/widgets/app_button.dart';
import 'package:driver/core/widgets/app_text_field.dart';
import 'package:driver/core/widgets/reusables/reusable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

// ── 1. My Account Details & Vehicle Info Sheet ───────────────────────────────
class MyAccountSheet extends StatelessWidget {
  const MyAccountSheet({super.key, required this.driver});

  final UserModel? driver;

  @override
  Widget build(BuildContext context) {
    final rating = driver?.averageRating ?? 0.0;
    final isVerified = driver?.isDocumentVerify == true;

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
                  text: 'تفاصيل الحساب الشخصي',
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
            Container(
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                color: (Theme.of(context).brightness == Brightness.dark
                        ? AppColors.greyDark100
                        : AppColors.grey100)
                    .withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: (Theme.of(context).dividerTheme.color ??
                          AppColors.grey200)
                      .withValues(alpha: 0.5),
                ),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30.r,
                    backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                    backgroundImage: driver?.profilePictureURL != null
                        ? NetworkImage(driver!.profilePictureURL!)
                        : const AssetImage(AppAssets.userPlaceholder)
                            as ImageProvider,
                  ),
                  SizedBox(width: 14.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: ReusableText.bodySemiBold(
                                text: driver?.fullName ?? 'السائق',
                                fontSize: 15.sp,
                              ),
                            ),
                            SizedBox(width: 6.w),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 6.w,
                                vertical: 2.h,
                              ),
                              decoration: BoxDecoration(
                                color: isVerified
                                    ? Colors.green.withValues(alpha: 0.1)
                                    : Colors.orange.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(6.r),
                              ),
                              child: ReusableText(
                                text: isVerified ? 'موثق' : 'قيد التفعيل',
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.bold,
                                  color: isVerified
                                      ? Colors.green[700]
                                      : Colors.orange[700],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4.h),
                        ReusableText.caption(
                          text: driver?.phoneNumber ?? 'لا يوجد رقم هاتف',
                          color: Theme.of(context).brightness == Brightness.dark
                              ? AppColors.greyDark500
                              : AppColors.grey600,
                        ),
                        if (driver?.email != null) ...[
                          SizedBox(height: 2.h),
                          ReusableText.caption(
                            text: driver!.email!,
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? AppColors.greyDark500
                                    : AppColors.grey500,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (rating > 0) ...[
              SizedBox(height: 16.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RatingBarIndicator(
                    rating: rating,
                    itemBuilder: (_, __) => const Icon(
                      Icons.star_rounded,
                      color: AppColors.warning,
                    ),
                    itemCount: 5,
                    itemSize: 22.r,
                    direction: Axis.horizontal,
                  ),
                  SizedBox(width: 8.w),
                  ReusableText.bodySemiBold(
                    text:
                        '${rating.toStringAsFixed(1)} (${driver?.reviewsCount ?? 0} تقييم)',
                    fontSize: 13,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppColors.greyDark500
                        : AppColors.grey700,
                  ),
                ],
              ),
            ],
            SizedBox(height: 20.h),
            Divider(color: Theme.of(context).dividerTheme.color),
            SizedBox(height: 12.h),
            Row(
              children: [
                Icon(
                  Icons.local_shipping_outlined,
                  color: AppColors.primary,
                  size: 20.r,
                ),
                SizedBox(width: 8.w),
                const ReusableText.bodySemiBold(
                  text: 'بيانات المركبة والترخيص',
                  fontSize: 14,
                ),
              ],
            ),
            SizedBox(height: 16.h),
            _InfoSheetRow(
              icon: Icons.category_outlined,
              label: 'نوع المركبة',
              value: driver?.vehicleType?.isNotEmpty == true
                  ? driver!.vehicleType!
                  : 'غير محدد',
            ),
            _InfoSheetRow(
              icon: Icons.directions_car_outlined,
              label: 'موديل المركبة',
              value: driver?.carName?.isNotEmpty == true
                  ? driver!.carName!
                  : 'غير محدد',
            ),
            _InfoSheetRow(
              icon: Icons.confirmation_number_outlined,
              label: 'رقم اللوحة',
              value: driver?.carNumber?.isNotEmpty == true
                  ? driver!.carNumber!
                  : 'غير محدد',
            ),
            _InfoSheetRow(
              icon: Icons.badge_outlined,
              label: 'رقم رخصة القيادة',
              value: driver?.driverLicenseNumber?.isNotEmpty == true
                  ? driver!.driverLicenseNumber!
                  : 'غير محدد',
            ),
            _InfoSheetRow(
              icon: Icons.fact_check_outlined,
              label: 'رقم رخصة المركبة',
              value: driver?.vehicleLicenseNumber?.isNotEmpty == true
                  ? driver!.vehicleLicenseNumber!
                  : 'غير محدد',
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}

class _InfoSheetRow extends StatelessWidget {
  const _InfoSheetRow({
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
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(6.r),
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.greyDark100
                  : AppColors.grey100,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              icon,
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.greyDark500
                  : AppColors.grey500,
              size: 16.r,
            ),
          ),
          SizedBox(width: 12.w),
          ReusableText.bodyMedium(
            text: '$label:',
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.greyDark500
                : AppColors.grey600,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: ReusableText.bodySemiBold(
                text: value,
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.greyDark900
                    : AppColors.grey800,
              ),
            ),
          ),
        ],
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
  const BankAccountsSheet({super.key});

  @override
  State<BankAccountsSheet> createState() => _BankAccountsSheetState();
}

class _BankAccountsSheetState extends State<BankAccountsSheet> {
  final List<Map<String, String>> _accounts = [
    {
      'bankName': 'مصرف الراجحي',
      'holderName': 'أحمد محمد عبد الله',
      'iban': 'SA80 8000 0000 1234 5678 9012',
    }
  ];

  final _bankNameController = TextEditingController();
  final _holderNameController = TextEditingController();
  final _ibanController = TextEditingController();
  bool _isAdding = false;

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
                  text: title,
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
              text: content,
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
