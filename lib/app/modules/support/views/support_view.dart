import 'package:driver/app/data/models/support_ticket_model.dart';
import 'package:driver/app/modules/support/controllers/support_controller.dart';
import 'package:driver/core/theme/app_colors.dart';
import 'package:driver/core/theme/app_text_styles.dart';
import 'package:driver/core/widgets/app_button.dart';
import 'package:driver/core/widgets/app_card.dart';
import 'package:driver/core/widgets/app_scaffold.dart';
import 'package:driver/core/widgets/app_tab_bar.dart';
import 'package:driver/core/widgets/app_text_field.dart';
import 'package:driver/core/widgets/section_title.dart';
import 'package:driver/core/widgets/state_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class SupportView extends GetView<SupportController> {
  const SupportView({super.key});

  static const _tabs = ['تذكرة جديدة', 'تذاكري'];

  @override
  Widget build(BuildContext context) {
    final currentTab = 0.obs;

    return AppScaffold(
      title: 'الدعم الفني',
      subtitle: 'نحن هنا لمساعدتك في أي وقت',
      body: Obx(
        () => Column(
          children: [
            AppTabBar(
              tabs: _tabs,
              currentIndex: currentTab.value,
              onChanged: (i) => currentTab.value = i,
            ),
            SizedBox(height: 16.h),
            Expanded(
              child: currentTab.value == 0
                  ? _NewTicketTab(controller: controller)
                  : _MyTicketsTab(controller: controller),
            ),
          ],
        ),
      ),
    );
  }
}

// ── New Ticket Tab ────────────────────────────────────────────────────────────

class _NewTicketTab extends StatelessWidget {
  const _NewTicketTab({required this.controller});

  final SupportController controller;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Obx(() {
          final orderId = controller.linkedOrderId.value;
          if (orderId == null) return const SizedBox.shrink();

          return Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: AppCard(
              backgroundColor: AppColors.primary50,
              child: Row(
                children: [
                  Icon(
                    Icons.receipt_long_outlined,
                    color: AppColors.primary,
                    size: 20.r,
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Text(
                      'التذكرة مرتبطة بالطلب #$orderId',
                      style: AppTextStyles.bodySemiBold(
                        color: AppColors.primary500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
        const SectionTitle(
          title: 'سبب التواصل',
          subtitle: 'اختر أقرب سبب للمشكلة حتى يتم التعامل معها أسرع.',
        ),
        SizedBox(height: 12.h),
        Obx(
          () => Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: controller.reasons.map((reason) {
              final selected = controller.selectedReason.value == reason;

              return ChoiceChip(
                label: Text(reason),
                selected: selected,
                onSelected: (_) => controller.selectedReason.value = reason,
                selectedColor: AppColors.primary,
                labelStyle: AppTextStyles.captionMedium(
                  color: selected ? Colors.white : AppColors.grey600,
                ),
                backgroundColor: AppColors.grey100,
                side: BorderSide.none,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              );
            }).toList(),
          ),
        ),
        SizedBox(height: 16.h),
        AppTextField(
          controller: controller.messageController,
          minLines: 4,
          maxLines: 6,
          hintText: 'اكتب تفاصيل إضافية إن وجدت...',
        ),
        SizedBox(height: 18.h),
        Obx(
          () => AppButton(
            label: 'إرسال التذكرة',
            onPressed: controller.submitTicket,
            isLoading: controller.isSubmitting.value,
            icon: const Icon(Icons.support_agent_rounded, color: Colors.white),
          ),
        ),
      ]
          .animate(interval: 45.ms)
          .fadeIn(duration: 220.ms)
          .slideY(begin: 0.03, end: 0, curve: Curves.easeOut),
    );
  }
}

// ── My Tickets Tab ────────────────────────────────────────────────────────────

class _MyTicketsTab extends StatelessWidget {
  const _MyTicketsTab({required this.controller});

  final SupportController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingTickets.value) {
        return const LoadingWidget(message: 'جاري تحميل التذاكر...');
      }

      if (controller.myTickets.isEmpty) {
        return const EmptyStateWidget(
          message: 'لا توجد تذاكر دعم',
          subMessage: 'أرسل تذكرة من التبويب الأول وستظهر هنا.',
          icon: Icons.support_agent_outlined,
        );
      }

      return ListView.separated(
        itemCount: controller.myTickets.length,
        separatorBuilder: (_, __) => SizedBox(height: 10.h),
        itemBuilder: (_, index) {
          final ticket = controller.myTickets[index];
          return _TicketCard(ticket: ticket)
              .animate(delay: (index * 35).ms)
              .fadeIn(duration: 220.ms)
              .slideY(begin: 0.03, end: 0, curve: Curves.easeOut);
        },
      );
    });
  }
}

// ── Ticket Card ───────────────────────────────────────────────────────────────

class _TicketCard extends StatelessWidget {
  const _TicketCard({required this.ticket});

  final SupportTicketModel ticket;

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(ticket.status);
    final statusLabel = _statusLabel(ticket.status);

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  ticket.reason ?? 'تذكرة دعم',
                  style: AppTextStyles.bodySemiBold(),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  statusLabel,
                  style: AppTextStyles.captionMedium(color: statusColor),
                ),
              ),
            ],
          ),
          if (ticket.message?.isNotEmpty == true) ...[
            SizedBox(height: 8.h),
            Text(
              ticket.message!,
              style: AppTextStyles.body(color: AppColors.grey600),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          if (ticket.createdAt != null) ...[
            SizedBox(height: 8.h),
            Text(
              DateFormat('yyyy/MM/dd - hh:mm a')
                  .format(ticket.createdAt!.toDate()),
              style: AppTextStyles.caption(color: AppColors.grey400),
            ),
          ],
        ],
      ),
    );
  }

  Color _statusColor(String? status) {
    return switch (status?.toLowerCase()) {
      'closed' || 'resolved' => AppColors.success,
      'open' => AppColors.primary,
      'pending' => AppColors.warning,
      _ => AppColors.grey400,
    };
  }

  String _statusLabel(String? status) {
    return switch (status?.toLowerCase()) {
      'closed' || 'resolved' => 'تم الإغلاق',
      'open' => 'مفتوحة',
      'pending' => 'قيد المراجعة',
      _ => 'مفتوحة',
    };
  }
}
