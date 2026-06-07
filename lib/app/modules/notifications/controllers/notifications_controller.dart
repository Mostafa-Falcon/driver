import 'dart:async';

import 'package:driver/app/data/models/notification_model.dart';
import 'package:driver/app/data/repositories/notification_repository.dart';
import 'package:driver/app/services/auth_service.dart';
import 'package:driver/core/utils/app_logger.dart';
import 'package:get/get.dart';

class NotificationsController extends GetxController {
  final NotificationRepository _notificationRepository =
      NotificationRepository();
  final AuthService _auth = AuthService.to;

  final RxBool isLoading = true.obs;
  final RxBool isMarkingAllRead = false.obs;
  final RxList<NotificationModel> notifications = <NotificationModel>[].obs;

  StreamSubscription<List<NotificationModel>>? _notificationsSub;

  int get unreadCount =>
      notifications.where((item) => item.isRead != true).length;

  @override
  void onInit() {
    super.onInit();
    _listenNotifications();
  }

  void _listenNotifications() {
    final driverId = _auth.userId;
    if (driverId == null) {
      isLoading.value = false;
      return;
    }

    _notificationsSub =
        _notificationRepository.listenDriverNotifications(driverId).listen(
      (items) {
        notifications.value = items;
        isLoading.value = false;
      },
      onError: (Object e) {
        AppLogger.error('notifications stream error', error: e);
        isLoading.value = false;
      },
    );
  }

  Future<void> markAsRead(NotificationModel notification) async {
    final id = notification.id;
    if (id == null || notification.isRead == true) return;
    await _notificationRepository.markAsRead(id);
  }

  Future<void> markAllAsRead() async {
    if (isMarkingAllRead.value) return;

    final ids = notifications
        .where((item) => item.isRead != true)
        .map((item) => item.id)
        .whereType<String>()
        .toList();
    if (ids.isEmpty) return;

    isMarkingAllRead.value = true;
    try {
      await _notificationRepository.markAllAsRead(ids);
    } finally {
      isMarkingAllRead.value = false;
    }
  }

  @override
  void onClose() {
    unawaited(_notificationsSub?.cancel());
    super.onClose();
  }
}
