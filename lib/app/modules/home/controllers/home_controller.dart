import 'dart:async';

import 'package:driver/app/data/models/order_model.dart';
import 'package:driver/app/data/models/user_model.dart';
import 'package:driver/app/data/repositories/order_repository.dart';
import 'package:driver/app/routes/app_pages.dart';
import 'package:driver/app/services/auth_service.dart';
import 'package:driver/core/utils/app_logger.dart';
import 'package:driver/core/utils/toast_utils.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final OrderRepository _orderRepository = OrderRepository();
  final AuthService _auth = AuthService.to;

  final RxBool isLoading = true.obs;
  final RxInt currentTab = 0.obs;

  final RxList<OrderModel> newOrders = <OrderModel>[].obs;
  final RxList<OrderModel> activeOrders = <OrderModel>[].obs;
  final RxList<OrderModel> previousOrders = <OrderModel>[].obs;

  StreamSubscription<List<OrderModel>>? _newOrdersSub;
  StreamSubscription<List<OrderModel>>? _activeOrdersSub;
  StreamSubscription<List<OrderModel>>? _previousOrdersSub;

  UserModel? get driver => _auth.user;
  bool get isOnline => driver?.isOnline ?? false;

  @override
  void onInit() {
    super.onInit();
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
          newOrders.value = orders;
          isLoading.value = false;
        },
        onError: (Object e) {
          AppLogger.error('newOrders stream error', error: e);
          isLoading.value = false;
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
    await _auth.setOnlineStatus(!isOnline);
    update();
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
      ToastUtils.showSuccess('تم قبول الطلب بنجاح');
      currentTab.value = 1;
    } else {
      ToastUtils.showError('الطلب لم يعد متاحا أو تم قبوله من سائق آخر');
    }
  }

  Future<void> hideOrder(OrderModel order) async {
    if (order.id == null || driver == null) return;

    final success = await _orderRepository.hideOrder(
      orderId: order.id!,
      driverId: driver!.id!,
    );

    if (success) {
      ToastUtils.showToast('تم إخفاء الطلب');
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
    super.onClose();
  }
}
