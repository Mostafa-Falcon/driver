import 'package:driver/app/data/models/order_model.dart';
import 'package:driver/app/modules/order_details/controllers/order_details_controller.dart';
import 'package:driver/core/constants/app_constants.dart';
import 'package:driver/core/constants/app_strings.dart';
import 'package:driver/core/theme/app_colors.dart';
import 'package:driver/core/theme/app_text_styles.dart';
import 'package:driver/core/widgets/address_row.dart';
import 'package:driver/core/widgets/amount_row.dart';
import 'package:driver/core/widgets/app_button.dart';
import 'package:driver/core/widgets/app_card.dart';
import 'package:driver/core/widgets/app_scaffold.dart';
import 'package:driver/core/widgets/journey_stepper.dart';
import 'package:driver/core/widgets/section_title.dart';
import 'package:driver/core/widgets/state_widgets.dart';
import 'package:driver/core/widgets/status_chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderDetailsView extends GetView<OrderDetailsController> {
  const OrderDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'تفاصيل الطلب',
      subtitle: 'متابعة الرحلة وتحديث حالتها',
      body: Obx(() {
        if (controller.isLoading.value) {
          return const LoadingWidget(message: 'جاري تحميل الطلب...');
        }

        final order = controller.order.value;
        if (order == null) {
          return const EmptyStateWidget(
            message: 'الطلب غير موجود',
            subMessage: 'قد يكون الطلب حذف أو لم يعد متاحا.',
            icon: Icons.search_off_rounded,
          );
        }

        return ListView(
          children: [
            _OrderSummaryCard(order: order),
            SizedBox(height: 12.h),
            _JourneyCard(order: order),
            SizedBox(height: 12.h),
            _AddressCard(order: order),
            SizedBox(height: 12.h),
            _MoneyCard(order: order),
            SizedBox(height: 12.h),
            _NotesCard(order: order),
            SizedBox(height: 20.h),
            _ActionBar(order: order),
          ].animate(interval: 45.ms).fadeIn(duration: 220.ms).slideY(
                begin: 0.04,
                end: 0,
                curve: Curves.easeOut,
              ),
        );
      }),
    );
  }
}

class _OrderSummaryCard extends StatelessWidget {
  const _OrderSummaryCard({required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '#${order.id ?? '---'}',
                  style: AppTextStyles.bodySemiBold(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 6.h),
                Text(
                  '${order.totalAmount.toStringAsFixed(2)} ${AppStrings.currencySuffix}',
                  style: AppTextStyles.h2(color: AppColors.primary),
                ),
              ],
            ),
          ),
          StatusChip(status: order.status),
        ],
      ),
    );
  }
}

class _JourneyCard extends StatelessWidget {
  const _JourneyCard({required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(title: 'مراحل الرحلة'),
          SizedBox(height: 14.h),
          JourneyStepper(status: order.status),
        ],
      ),
    );
  }
}

class _AddressCard extends StatelessWidget {
  const _AddressCard({required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        children: [
          AddressRow(
            title: 'عنوان الاستلام',
            address: order.pickupAddress?.fullAddress ?? '',
            icon: Icons.my_location_rounded,
            color: AppColors.primary,
          ),
          SizedBox(height: 12.h),
          AddressRow(
            title: 'عنوان التسليم',
            address: order.dropAddress?.fullAddress ?? '',
            icon: Icons.location_on_rounded,
            color: AppColors.danger,
          ),
        ],
      ),
    );
  }
}

class _MoneyCard extends StatelessWidget {
  const _MoneyCard({required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        children: [
          AmountRow(
            label: 'قيمة الطلب',
            amount: double.tryParse(order.subTotal ?? '0') ?? 0,
          ),
          SizedBox(height: 8.h),
          AmountRow(
            label: 'رسوم التوصيل',
            amount: double.tryParse(order.deliveryCharge ?? '0') ?? 0,
          ),
          const Divider(height: 22),
          AmountRow(
            label: 'الإجمالي',
            amount: order.totalAmount,
            isHighlighted: true,
          ),
          SizedBox(height: 8.h),
          AmountRow(
            label: 'صافي السائق',
            amount: order.driverEarnings,
          ),
        ],
      ),
    );
  }
}

class _NotesCard extends StatelessWidget {
  const _NotesCard({required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    final notes = order.notes?.trim();
    final hasNotes = notes != null && notes.isNotEmpty;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(title: 'ملاحظات ومرفقات'),
          SizedBox(height: 10.h),
          Text(
            hasNotes ? notes : 'لا توجد ملاحظات لهذا الطلب.',
            style: AppTextStyles.body(color: AppColors.grey600),
          ),
          if (order.hasAudioNote) ...[
            SizedBox(height: 10.h),
            _AttachmentLink(
              label: 'فتح الملاحظة الصوتية',
              value: order.audioNote!,
              icon: Icons.graphic_eq_rounded,
            ),
          ],
          if (order.hasAttachments)
            ...List.generate(order.attachments!.length, (index) {
              final attachment = order.attachments![index];
              return Padding(
                padding: EdgeInsets.only(top: 8.h),
                child: _AttachmentLink(
                  label: _attachmentLabel(attachment, index),
                  value: _attachmentUrl(attachment),
                  icon: Icons.attach_file_rounded,
                ),
              );
            }),
        ],
      ),
    );
  }

  String _attachmentLabel(dynamic attachment, int index) {
    if (attachment is Map) {
      final name = attachment['name'] ?? attachment['fileName'];
      if (name is String && name.isNotEmpty) return name;
    }

    return 'مرفق ${index + 1}';
  }

  String _attachmentUrl(dynamic attachment) {
    if (attachment is String) return attachment;
    if (attachment is Map) {
      final value = attachment['url'] ??
          attachment['downloadURL'] ??
          attachment['file_url'] ??
          attachment['path'];
      return value is String ? value : '';
    }

    return '';
  }
}

class _AttachmentLink extends StatelessWidget {
  const _AttachmentLink({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: value.isEmpty ? null : () => _open(),
      icon: Icon(icon, size: 18.r),
      label: Text(label, style: AppTextStyles.bodyMedium()),
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      ),
    );
  }

  Future<void> _open() async {
    final uri = Uri.tryParse(value);
    if (uri == null || !uri.hasScheme) return;

    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}

class _ActionBar extends GetView<OrderDetailsController> {
  const _ActionBar({required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    final status = order.status;

    if (status == AppConstants.statusDriverAccepted) {
      return AppButton(
        label: 'تأكيد استلام الطلب',
        onPressed: controller.markPickedUp,
        icon: const Icon(Icons.inventory_2_outlined, color: Colors.white),
      );
    }

    if (status == AppConstants.statusOrderShipped) {
      return AppButton(
        label: 'بدء التوصيل',
        onPressed: controller.startDelivery,
        icon: const Icon(Icons.route_rounded, color: Colors.white),
      );
    }

    if (status == AppConstants.statusInTransit) {
      return AppButton(
        label: 'إنهاء الطلب',
        onPressed: controller.completeOrder,
        icon: const Icon(Icons.check_circle_outline, color: Colors.white),
      );
    }

    return Text(
      'لا يوجد إجراء مطلوب حاليا.',
      style: AppTextStyles.body(color: AppColors.grey500),
      textAlign: TextAlign.center,
    );
  }
}
