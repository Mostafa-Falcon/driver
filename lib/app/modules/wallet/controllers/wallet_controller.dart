import 'dart:async';

import 'package:driver/app/data/models/driver_payout_model.dart';
import 'package:driver/app/data/models/notification_model.dart';
import 'package:driver/app/data/models/user_model.dart';
import 'package:driver/app/data/models/wallet_transaction_model.dart';
import 'package:driver/app/data/repositories/notification_repository.dart';
import 'package:driver/app/data/repositories/wallet_repository.dart';
import 'package:driver/app/services/auth_service.dart';
import 'package:driver/core/utils/app_logger.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class WalletController extends GetxController {
  final WalletRepository _walletRepository = WalletRepository();
  final NotificationRepository _notificationRepository =
      NotificationRepository();
  final AuthService _auth = AuthService.to;
  final ImagePicker _imagePicker = ImagePicker();

  final RxBool isLoading = true.obs;
  final RxInt currentTab = 0.obs;
  final RxList<WalletTransactionModel> transactions =
      <WalletTransactionModel>[].obs;
  final RxList<DriverPayoutModel> withdrawals = <DriverPayoutModel>[].obs;

  final RxBool isOnline = false.obs;
  final RxInt unreadNotificationsCount = 0.obs;

  StreamSubscription<List<WalletTransactionModel>>? _transactionsSub;
  StreamSubscription<List<DriverPayoutModel>>? _withdrawalsSub;
  StreamSubscription<List<NotificationModel>>? _notificationsSub;
  bool _transactionsLoaded = false;
  bool _withdrawalsLoaded = false;

  UserModel? get driver => _auth.user;
  double get balance => (_auth.user?.walletAmount ?? 0).toDouble();

  double get weekOverWeekGrowth {
    if (transactions.isEmpty) return 0.0;

    final now = DateTime.now();
    final sevenDaysAgo = now.subtract(const Duration(days: 7));
    final fourteenDaysAgo = now.subtract(const Duration(days: 14));

    double currentWeekSum = 0.0;
    double lastWeekSum = 0.0;

    for (final tx in transactions) {
      if (tx.isTopup != true || tx.amount == null || tx.date == null) continue;
      final txDate = tx.date!.toDate();
      if (txDate.isAfter(sevenDaysAgo)) {
        currentWeekSum += tx.amount!;
      } else if (txDate.isAfter(fourteenDaysAgo)) {
        lastWeekSum += tx.amount!;
      }
    }

    if (lastWeekSum == 0.0) {
      return currentWeekSum > 0.0 ? 100.0 : 0.0;
    }

    return ((currentWeekSum - lastWeekSum) / lastWeekSum) * 100;
  }

  @override
  void onInit() {
    super.onInit();
    isOnline.value = _auth.user?.isOnline ?? false;
    _listenTransactions();
    _listenNotifications();
  }

  void _listenTransactions() {
    final driverId = _auth.userId;
    if (driverId == null) {
      isLoading.value = false;
      return;
    }

    _transactionsSub = _walletRepository.listenTransactions(driverId).listen(
      (items) {
        transactions.value = items;
        _transactionsLoaded = true;
        _updateLoadingState();
      },
      onError: (Object e) {
        AppLogger.error('wallet transactions stream error', error: e);
        _transactionsLoaded = true;
        _updateLoadingState();
      },
    );

    _withdrawalsSub = _walletRepository.listenWithdrawals(driverId).listen(
      (items) {
        withdrawals.value = items;
        _withdrawalsLoaded = true;
        _updateLoadingState();
      },
      onError: (Object e) {
        AppLogger.error('wallet withdrawals stream error', error: e);
        _withdrawalsLoaded = true;
        _updateLoadingState();
      },
    );
  }

  void _updateLoadingState() {
    isLoading.value = !(_transactionsLoaded && _withdrawalsLoaded);
  }

  // ── Withdrawal ────────────────────────────────────────────

  final RxBool isWithdrawing = false.obs;
  final RxBool isSubmittingRecharge = false.obs;
  final Rxn<XFile> rechargeReceipt = Rxn<XFile>();

  /// يُرسل طلب سحب بالمبلغ المحدد بعد التحقق من الرصيد
  Future<bool> submitWithdrawal({
    required double amount,
    String? note,
  }) async {
    final driverId = _auth.userId;
    if (driverId == null) return false;
    if (amount <= 0 || amount > balance) return false;

    isWithdrawing.value = true;
    final success = await _walletRepository.requestWithdrawal(
      driverId: driverId,
      amount: amount,
      methodId: 'manual',
      note: note,
    );
    isWithdrawing.value = false;
    return success;
  }

  void clearRechargeDraft() {
    rechargeReceipt.value = null;
  }

  Future<void> pickRechargeReceipt({
    ImageSource source = ImageSource.camera,
  }) async {
    final image = await _imagePicker.pickImage(
      source: source,
      imageQuality: 82,
      maxWidth: 1600,
    );
    if (image != null) {
      rechargeReceipt.value = image;
    }
  }

  Future<bool> submitRechargeRequest({
    required String transactionNumber,
    String? note,
  }) async {
    final driverId = _auth.userId;
    final receipt = rechargeReceipt.value;
    if (driverId == null || receipt == null) return false;

    isSubmittingRecharge.value = true;
    try {
      final receiptUrl = await _walletRepository.uploadRechargeReceipt(
        driverId: driverId,
        bytes: await receipt.readAsBytes(),
        fileName: receipt.name,
      );
      if (receiptUrl == null) return false;

      final success = await _walletRepository.requestRecharge(
        driverId: driverId,
        transactionNumber: transactionNumber,
        receiptUrl: receiptUrl,
        note: note,
      );
      if (success) clearRechargeDraft();
      return success;
    } finally {
      isSubmittingRecharge.value = false;
    }
  }

  void _listenNotifications() {
    final userId = _auth.userId;
    if (userId == null) return;

    _notificationsSub =
        _notificationRepository.listenDriverNotifications(userId).listen(
      (items) {
        unreadNotificationsCount.value =
            items.where((n) => n.isRead != true).length;
      },
      onError: (Object e) {
        AppLogger.error('notifications stream error in wallet', error: e);
      },
    );
  }

  Future<void> toggleOnlineStatus() async {
    await _auth.setOnlineStatus(!isOnline.value);
    isOnline.value = !isOnline.value;
    update();
  }

  @override
  void onClose() {
    unawaited(_transactionsSub?.cancel());
    unawaited(_withdrawalsSub?.cancel());
    unawaited(_notificationsSub?.cancel());
    super.onClose();
  }
}
