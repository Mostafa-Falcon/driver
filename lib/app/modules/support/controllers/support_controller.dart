import 'dart:async';

import 'package:driver/app/data/models/support_ticket_model.dart';
import 'package:driver/app/data/repositories/support_repository.dart';
import 'package:driver/app/services/auth_service.dart';
import 'package:driver/core/utils/app_logger.dart';
import 'package:driver/core/utils/toast_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SupportController extends GetxController {
  final SupportRepository _supportRepository = SupportRepository();
  final AuthService _auth = AuthService.to;

  final TextEditingController messageController = TextEditingController();
  final RxString selectedReason = SupportRepository.defaultReasons.first.obs;
  final RxBool isSubmitting = false.obs;

  final RxList<SupportTicketModel> myTickets = <SupportTicketModel>[].obs;
  final RxBool isLoadingTickets = true.obs;

  StreamSubscription<List<SupportTicketModel>>? _ticketsSub;

  List<String> get reasons => SupportRepository.defaultReasons;

  @override
  void onInit() {
    super.onInit();
    _listenMyTickets();
  }

  void _listenMyTickets() {
    final driverId = _auth.userId;
    if (driverId == null) {
      isLoadingTickets.value = false;
      return;
    }

    _ticketsSub = _supportRepository.listenDriverTickets(driverId).listen(
      (tickets) {
        myTickets.value = tickets;
        isLoadingTickets.value = false;
      },
      onError: (Object e) {
        AppLogger.error('support tickets stream error', error: e);
        isLoadingTickets.value = false;
      },
    );
  }

  Future<void> submitTicket() async {
    final driverId = _auth.userId;
    if (driverId == null) return;

    isSubmitting.value = true;
    final success = await _supportRepository.createTicket(
      SupportTicketModel(
        driverId: driverId,
        reason: selectedReason.value,
        message: messageController.text.trim(),
      ),
    );
    isSubmitting.value = false;

    if (success) {
      messageController.clear();
      ToastUtils.showSuccess('تم إرسال تذكرة الدعم');
    } else {
      ToastUtils.showError('تعذر إرسال التذكرة');
    }
  }

  @override
  void onClose() {
    messageController.dispose();
    unawaited(_ticketsSub?.cancel());
    super.onClose();
  }
}
