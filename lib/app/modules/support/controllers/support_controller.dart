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
  final RxnString linkedOrderId = RxnString();

  final RxList<SupportTicketModel> myTickets = <SupportTicketModel>[].obs;
  final RxBool isLoadingTickets = true.obs;

  StreamSubscription<List<SupportTicketModel>>? _ticketsSub;

  List<String> get reasons => SupportRepository.defaultReasons;

  @override
  void onInit() {
    super.onInit();
    _readArguments();
    _listenMyTickets();
  }

  void _readArguments() {
    final args = Get.arguments;
    if (args is! Map) return;

    final orderId = args['orderId'];
    if (orderId is String && orderId.trim().isNotEmpty) {
      linkedOrderId.value = orderId.trim();
    }

    final reason = args['reason'];
    if (reason is String && SupportRepository.defaultReasons.contains(reason)) {
      selectedReason.value = reason;
    }
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
        orderId: linkedOrderId.value,
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
