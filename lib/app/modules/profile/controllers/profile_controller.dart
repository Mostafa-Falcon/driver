import 'dart:async';
import 'package:driver/app/data/models/notification_model.dart';
import 'package:driver/app/data/repositories/notification_repository.dart';
import 'package:driver/app/services/auth_service.dart';
import 'package:driver/app/services/theme_service.dart';
import 'package:driver/core/utils/app_logger.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  final AuthService auth = AuthService.to;
  final NotificationRepository _notificationRepository =
      NotificationRepository();

  final RxBool isOnline = false.obs;
  final RxInt unreadNotificationsCount = 0.obs;
  final RxBool isDark = false.obs;
  StreamSubscription<List<NotificationModel>>? _notificationsSub;

  @override
  void onInit() {
    super.onInit();
    isOnline.value = auth.user?.isOnline ?? false;
    isDark.value = ThemeService.to.isDark;
    _listenNotifications();
  }

  void _listenNotifications() {
    final userId = auth.userId;
    if (userId == null) return;

    _notificationsSub =
        _notificationRepository.listenDriverNotifications(userId).listen(
      (items) {
        unreadNotificationsCount.value =
            items.where((n) => n.isRead != true).length;
      },
      onError: (Object e) {
        AppLogger.error('notifications stream error in profile', error: e);
      },
    );
  }

  Future<void> toggleOnlineStatus() async {
    await auth.setOnlineStatus(!isOnline.value);
    isOnline.value = !isOnline.value;
    update();
  }

  void toggleTheme(bool val) {
    if (val) {
      ThemeService.to.setDark();
    } else {
      ThemeService.to.setLight();
    }
    isDark.value = val;
  }

  Future<bool> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null || user.email == null) return false;

      final cred = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );
      await user.reauthenticateWithCredential(cred);
      await user.updatePassword(newPassword);
      return true;
    } catch (e) {
      AppLogger.error('Failed to change password', error: e);
      return false;
    }
  }

  Future<void> signOut() => auth.signOut();

  @override
  void onClose() {
    unawaited(_notificationsSub?.cancel());
    super.onClose();
  }
}
