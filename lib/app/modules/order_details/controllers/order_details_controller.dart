import 'dart:async';

import 'package:driver/app/data/models/order_model.dart';
import 'package:driver/app/data/repositories/order_repository.dart';
import 'package:driver/app/services/auth_service.dart';
import 'package:driver/core/constants/app_constants.dart';
import 'package:driver/core/utils/toast_utils.dart';
import 'package:get/get.dart';

class OrderDetailsController extends GetxController {
  final OrderRepository _orderRepository = OrderRepository();
  final AuthService _auth = AuthService.to;

  final RxBool isLoading = true.obs;
  final Rxn<OrderModel> order = Rxn<OrderModel>();

  String? get orderId => Get.arguments is Map
      ? (Get.arguments as Map)['orderId'] as String?
      : null;

  String? get driverId => _auth.userId;

  @override
  void onInit() {
    super.onInit();
    unawaited(loadOrder());
  }

  Future<void> loadOrder() async {
    final id = orderId;
    if (id == null) {
      isLoading.value = false;
      return;
    }

    order.value = await _orderRepository.getOrderById(id);
    isLoading.value = false;
  }

  Future<void> markPickedUp() async {
    await _updateStatus(
      nextStatus: AppConstants.statusOrderShipped,
      allowedCurrentStatuses: const [AppConstants.statusDriverAccepted],
      eventType: AppConstants.eventPickedUp,
      successMessage: 'تم تسجيل استلام الطلب',
    );
  }

  Future<void> startDelivery() async {
    await _updateStatus(
      nextStatus: AppConstants.statusInTransit,
      allowedCurrentStatuses: const [AppConstants.statusOrderShipped],
      eventType: AppConstants.eventStatusChanged,
      successMessage: 'تم بدء التوصيل',
    );
  }

  Future<void> completeOrder() async {
    await _updateStatus(
      nextStatus: AppConstants.statusOrderCompleted,
      allowedCurrentStatuses: const [AppConstants.statusInTransit],
      eventType: AppConstants.eventCompleted,
      successMessage: 'تم إنهاء الطلب',
      clearFromActive: true,
    );
  }

  Future<void> _updateStatus({
    required String nextStatus,
    required List<String> allowedCurrentStatuses,
    required String eventType,
    required String successMessage,
    bool clearFromActive = false,
  }) async {
    final id = order.value?.id;
    final currentDriverId = driverId;
    if (id == null || currentDriverId == null) return;

    ToastUtils.showLoader('جاري التحديث...');
    final success = await _orderRepository.updateOrderStatus(
      orderId: id,
      driverId: currentDriverId,
      nextStatus: nextStatus,
      allowedCurrentStatuses: allowedCurrentStatuses,
      eventType: eventType,
      clearFromActive: clearFromActive,
    );
    ToastUtils.hideLoader();

    if (success) {
      ToastUtils.showSuccess(successMessage);
      await loadOrder();
    } else {
      ToastUtils.showError('تعذر تحديث حالة الطلب');
    }
  }
}
