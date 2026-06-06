import 'dart:async';

import 'package:driver/app/data/models/driver_payout_model.dart';
import 'package:driver/app/data/models/wallet_transaction_model.dart';
import 'package:driver/app/data/repositories/wallet_repository.dart';
import 'package:driver/app/services/auth_service.dart';
import 'package:driver/core/utils/app_logger.dart';
import 'package:get/get.dart';

class WalletController extends GetxController {
  final WalletRepository _walletRepository = WalletRepository();
  final AuthService _auth = AuthService.to;

  final RxBool isLoading = true.obs;
  final RxInt currentTab = 0.obs;
  final RxList<WalletTransactionModel> transactions =
      <WalletTransactionModel>[].obs;
  final RxList<DriverPayoutModel> withdrawals = <DriverPayoutModel>[].obs;

  StreamSubscription<List<WalletTransactionModel>>? _transactionsSub;
  StreamSubscription<List<DriverPayoutModel>>? _withdrawalsSub;
  bool _transactionsLoaded = false;
  bool _withdrawalsLoaded = false;

  double get balance => (_auth.user?.walletAmount ?? 0).toDouble();

  @override
  void onInit() {
    super.onInit();
    _listenTransactions();
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

  @override
  void onClose() {
    unawaited(_transactionsSub?.cancel());
    unawaited(_withdrawalsSub?.cancel());
    super.onClose();
  }
}
