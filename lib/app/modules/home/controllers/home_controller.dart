import 'dart:async';

import 'package:driver/app/data/models/order_model.dart';
import 'package:driver/app/data/models/user_model.dart';
import 'package:driver/app/data/models/notification_model.dart';
import 'package:driver/app/data/repositories/notification_repository.dart';
import 'package:driver/app/data/repositories/order_repository.dart';
import 'package:driver/app/routes/app_pages.dart';
import 'package:driver/app/services/auth_service.dart';
import 'package:driver/app/services/notification_alarm_service.dart';
import 'package:driver/core/utils/app_logger.dart';
import 'package:driver/core/utils/toast_utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart' hide Trans;

class HomeController extends GetxController {
  final OrderRepository _orderRepository = OrderRepository();
  final NotificationRepository _notificationRepository =
      NotificationRepository();
  final AuthService _auth = AuthService.to;

  final RxBool isLoading = true.obs;
  final RxInt currentTab = 0.obs;

  final RxList<OrderModel> newOrders = <OrderModel>[].obs;
  final RxList<OrderModel> activeOrders = <OrderModel>[].obs;
  final RxList<OrderModel> previousOrders = <OrderModel>[].obs;

  StreamSubscription<List<OrderModel>>? _newOrdersSub;
  StreamSubscription<List<OrderModel>>? _activeOrdersSub;
  StreamSubscription<List<OrderModel>>? _previousOrdersSub;
  StreamSubscription<List<NotificationModel>>? _notificationsSub;
  Set<String> _knownNewOrderIds = <String>{};
  bool _hasLoadedInitialNewOrders = false;

  UserModel? get driver => _auth.user;
  final isOnline = false.obs;
  final RxInt unreadNotificationsCount = 0.obs;
  NotificationAlarmService? get _alarmService =>
      Get.isRegistered<NotificationAlarmService>()
          ? NotificationAlarmService.to
          : null;

  @override
  void onInit() {
    super.onInit();
    isOnline.value = driver?.isOnline ?? false;
    _initStreams();
  }

  void _initStreams() {
    final userId = _auth.userId;
    if (userId == null) {
      isLoading.value = false;
      return;
    }

    try {
      _newOrdersSub = _orderRepository.listenNewOrders(userId).listen(
        (orders) {
          _handleNewOrders(orders);
          isLoading.value = false;
        },
        onError: (Object e) {
          AppLogger.error('newOrders stream error', error: e);
          isLoading.value = false;
        },
      );

      _notificationsSub =
          _notificationRepository.listenDriverNotifications(userId).listen(
        (items) {
          unreadNotificationsCount.value =
              items.where((n) => n.isRead != true).length;
        },
        onError: (Object e) {
          AppLogger.error('notifications stream error', error: e);
        },
      );

      _activeOrdersSub = _orderRepository.listenActiveOrders(userId).listen(
            (orders) => activeOrders.value = orders,
            onError: (Object e) =>
                AppLogger.error('activeOrders stream error', error: e),
          );

      _previousOrdersSub = _orderRepository.listenPreviousOrders(userId).listen(
            (orders) => previousOrders.value = orders,
            onError: (Object e) =>
                AppLogger.error('previousOrders stream error', error: e),
          );
    } catch (e) {
      AppLogger.error('HomeController._initStreams failed', error: e);
      isLoading.value = false;
    }
  }

  Future<void> toggleOnlineStatus() async {
    await _auth.setOnlineStatus(!isOnline.value);
    isOnline.value = !isOnline.value;
    update();
  }

  void selectTab(int index) {
    if (index == currentTab.value) return;
    currentTab.value = index;
  }

  Future<void> acceptOrder(OrderModel order) async {
    if (order.id == null || driver == null) return;

    ToastUtils.showLoader('جاري قبول الطلب...');
    final success = await _orderRepository.acceptOrder(
      orderId: order.id!,
      driver: driver!,
    );
    ToastUtils.hideLoader();

    if (success) {
      final alarmService = _alarmService;
      if (alarmService != null) await alarmService.stopAlarm();
      await _auth.refreshCurrentUser();
      ToastUtils.showSuccess('تم قبول الطلب بنجاح');
      currentTab.value = 1;
    } else {
      ToastUtils.showError(
        _orderRepository.lastErrorMessage ??
            'الطلب لم يعد متاحا أو تم قبوله من سائق آخر',
      );
    }
  }

  Future<void> hideOrder(OrderModel order) async {
    if (order.id == null || driver == null) return;

    final success = await _orderRepository.hideOrder(
      orderId: order.id!,
      driverId: driver!.id!,
    );

    if (success) {
      final alarmService = _alarmService;
      if (alarmService != null) await alarmService.stopAlarm();
      ToastUtils.showToast('تم إخفاء الطلب');
    }
  }

  void _handleNewOrders(List<OrderModel> orders) {
    final currentIds =
        orders.map((order) => order.id).whereType<String>().toSet();
    final hasNewOrder = _hasLoadedInitialNewOrders &&
        currentIds.any((id) => !_knownNewOrderIds.contains(id));

    newOrders.value = orders;
    _knownNewOrderIds = currentIds;
    _hasLoadedInitialNewOrders = true;

    final alarmService = _alarmService;
    if (hasNewOrder && isOnline.value && alarmService != null) {
      unawaited(alarmService.playNewOrderAlarm());
      ToastUtils.showToast('home.new_order_alert'.tr());
    }
  }

  void goToOrderDetails(OrderModel order) {
    Get.toNamed(
      AppRoutes.orderDetails,
      arguments: {'orderId': order.id},
    );
  }

  @override
  void onClose() {
    unawaited(_newOrdersSub?.cancel());
    unawaited(_activeOrdersSub?.cancel());
    unawaited(_previousOrdersSub?.cancel());
    unawaited(_notificationsSub?.cancel());
    super.onClose();
  }
}
