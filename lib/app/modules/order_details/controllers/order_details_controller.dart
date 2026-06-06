import 'dart:async';

import 'package:driver/app/data/models/order_model.dart';
import 'package:driver/app/data/repositories/order_repository.dart';
import 'package:driver/app/routes/app_pages.dart';
import 'package:driver/app/services/auth_service.dart';
import 'package:driver/core/constants/app_constants.dart';
import 'package:driver/core/utils/toast_utils.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class OrderDetailsController extends GetxController {
  final OrderRepository _orderRepository = OrderRepository();
  final AuthService _auth = AuthService.to;
  final ImagePicker _imagePicker = ImagePicker();

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
    final proofUrl = await _captureAndUploadProofPhoto('pickup');
    if (proofUrl == null) return;

    await _updateStatus(
      nextStatus: AppConstants.statusOrderShipped,
      allowedCurrentStatuses: const [AppConstants.statusDriverAccepted],
      eventType: AppConstants.eventPickedUp,
      successMessage: 'تم تسجيل استلام الطلب',
      orderUpdates: {'pickup_photo_url': proofUrl},
      eventMetadata: {'pickup_photo_url': proofUrl},
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
    final proofUrl = await _captureAndUploadProofPhoto('delivery');
    if (proofUrl == null) return;

    await _updateStatus(
      nextStatus: AppConstants.statusOrderCompleted,
      allowedCurrentStatuses: const [AppConstants.statusInTransit],
      eventType: AppConstants.eventCompleted,
      successMessage: 'تم إنهاء الطلب',
      orderUpdates: {'delivery_photo_url': proofUrl},
      eventMetadata: {'delivery_photo_url': proofUrl},
      clearFromActive: true,
    );
  }

  void openSupportForOrder() {
    final id = order.value?.id ?? orderId;
    Get.toNamed(
      AppRoutes.support,
      arguments: {
        if (id != null) 'orderId': id,
        'reason': 'حالات طارئة',
      },
    );
  }

  Future<String?> _captureAndUploadProofPhoto(String proofType) async {
    final id = order.value?.id;
    final currentDriverId = driverId;
    if (id == null || currentDriverId == null) return null;

    final image = await _imagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 82,
      maxWidth: 1600,
    );
    if (image == null) {
      ToastUtils.showToast('تم إلغاء التقاط الصورة');
      return null;
    }

    String? url;
    ToastUtils.showLoader(
      proofType == 'pickup'
          ? 'جاري رفع صورة الاستلام...'
          : 'جاري رفع صورة التسليم...',
    );
    try {
      url = await _orderRepository.uploadOrderProofPhoto(
        orderId: id,
        driverId: currentDriverId,
        proofType: proofType,
        bytes: await image.readAsBytes(),
        fileName: image.name,
      );
    } finally {
      ToastUtils.hideLoader();
    }

    if (url == null) {
      ToastUtils.showError('تعذر رفع الصورة، حاول مرة أخرى');
    }

    return url;
  }

  Future<void> _updateStatus({
    required String nextStatus,
    required List<String> allowedCurrentStatuses,
    required String eventType,
    required String successMessage,
    Map<String, dynamic>? orderUpdates,
    Map<String, dynamic>? eventMetadata,
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
      orderUpdates: orderUpdates,
      eventMetadata: eventMetadata,
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
