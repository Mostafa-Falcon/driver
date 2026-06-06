import 'dart:async';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver/app/data/models/driver_payout_model.dart';
import 'package:driver/app/data/models/wallet_transaction_model.dart';
import 'package:driver/core/constants/collection_names.dart';
import 'package:driver/core/utils/app_logger.dart';
import 'package:firebase_storage/firebase_storage.dart';

/// Repository للمحفظة المالية
/// يضمن أمان جميع العمليات المالية عبر Transactions
class WalletRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // ── Read ──────────────────────────────────────────────────

  /// الاستماع لمعاملات المحفظة بشكل مباشر
  Stream<List<WalletTransactionModel>> listenTransactions(String driverId) {
    return _db
        .collection(CollectionNames.wallet)
        .where('user_id', isEqualTo: driverId)
        .orderBy('date', descending: true)
        .limit(100)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((d) => WalletTransactionModel.fromJson(d.data()))
              .toList(),
        );
  }

  Stream<List<DriverPayoutModel>> listenWithdrawals(String driverId) {
    final controller = StreamController<List<DriverPayoutModel>>();
    List<DriverPayoutModel> currentItems = [];
    List<DriverPayoutModel> legacyItems = [];
    StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? currentSub;
    StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? legacySub;

    void emitCombined() {
      final byId = <String, DriverPayoutModel>{};

      for (final item in [...currentItems, ...legacyItems]) {
        byId[item.id ?? '${item.driverId}_${item.amount}_${item.displayDate}'] =
            item;
      }

      final combined = byId.values.toList()
        ..sort((a, b) {
          final aDate = a.displayDate?.toDate();
          final bDate = b.displayDate?.toDate();
          if (aDate == null && bDate == null) return 0;
          if (aDate == null) return 1;
          if (bDate == null) return -1;
          return bDate.compareTo(aDate);
        });

      controller.add(combined);
    }

    currentSub = _db
        .collection(CollectionNames.driverPayouts)
        .where('driver_id', isEqualTo: driverId)
        .orderBy('createdAt', descending: true)
        .limit(100)
        .snapshots()
        .listen(
      (snap) {
        currentItems =
            snap.docs.map((d) => DriverPayoutModel.fromJson(d.data())).toList();
        emitCombined();
      },
      onError: controller.addError,
    );

    legacySub = _db
        .collection(CollectionNames.driverPayouts)
        .where('driverID', isEqualTo: driverId)
        .orderBy('createdAt', descending: true)
        .limit(100)
        .snapshots()
        .listen(
      (snap) {
        legacyItems =
            snap.docs.map((d) => DriverPayoutModel.fromJson(d.data())).toList();
        emitCombined();
      },
      onError: controller.addError,
    );

    controller.onCancel = () async {
      await currentSub?.cancel();
      await legacySub?.cancel();
      await controller.close();
    };

    return controller.stream;
  }

  // ── Write ─────────────────────────────────────────────────

  /// إضافة معاملة مالية آمنة مع تحديث الرصيد في Transaction واحد
  /// [transaction]: نموذج المعاملة مع ID حتمي لمنع التكرار
  Future<bool> addTransaction({
    required WalletTransactionModel transaction,
    required String driverId,
  }) async {
    final userRef = _db.collection(CollectionNames.users).doc(driverId);
    // استخدام ID حتمي إذا كان موجوداً (لمنع العمولة المزدوجة)
    final txRef = transaction.id != null
        ? _db.collection(CollectionNames.wallet).doc(transaction.id)
        : _db.collection(CollectionNames.wallet).doc();

    try {
      return await _db.runTransaction<bool>((tx) async {
        // التحقق من عدم وجود المعاملة مسبقاً (لمنع التكرار)
        if (transaction.id != null) {
          final existing = await tx.get(txRef);
          if (existing.exists) {
            AppLogger.warning(
              'Transaction ${transaction.id} already exists — skipped',
            );
            return false;
          }
        }

        // قراءة الرصيد الحالي
        final userSnap = await tx.get(userRef);
        if (!userSnap.exists) return false;

        final currentBalance =
            (userSnap.data()!['wallet_amount'] as num?)?.toDouble() ?? 0.0;
        final txAmount = transaction.amount ?? 0.0;

        final newBalance = (transaction.isTopup ?? false)
            ? currentBalance + txAmount
            : currentBalance - txAmount;

        // التحقق من عدم السلبية للسحب
        if (!(transaction.isTopup ?? false) && newBalance < 0) {
          throw Exception('رصيد المحفظة غير كافٍ');
        }

        // حفظ المعاملة
        final txData = {
          ...transaction.toJson(),
          'id': txRef.id,
          'user_id': driverId,
        };
        tx.set(txRef, txData);

        // تحديث رصيد المستخدم
        tx.update(userRef, {'wallet_amount': newBalance});

        return true;
      });
    } catch (e) {
      AppLogger.error('addTransaction failed', error: e);
      return false;
    }
  }

  /// إنشاء طلب سحب
  Future<bool> requestWithdrawal({
    required String driverId,
    required double amount,
    required String methodId,
    String? note,
  }) async {
    try {
      final payoutRef = _db.collection(CollectionNames.driverPayouts).doc();
      await payoutRef.set({
        'id': payoutRef.id,
        'driver_id': driverId,
        'driverID': driverId,
        'amount': amount,
        'method_id': methodId,
        'status': 'pending',
        'paymentStatus': 'pending',
        'note': note,
        'createdAt': Timestamp.now(),
      });
      return true;
    } catch (e) {
      AppLogger.error('requestWithdrawal failed', error: e);
      return false;
    }
  }

  Future<String?> uploadRechargeReceipt({
    required String driverId,
    required Uint8List bytes,
    required String fileName,
  }) async {
    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final safeFileName = fileName.replaceAll(RegExp(r'[^a-zA-Z0-9._-]'), '_');
      final ref = _storage.ref().child(
            'wallet_recharge_requests/$driverId/${timestamp}_$safeFileName',
          );

      final upload = await ref.putData(
        bytes,
        SettableMetadata(contentType: _contentTypeFromFileName(fileName)),
      );

      return upload.ref.getDownloadURL();
    } catch (e) {
      AppLogger.error('uploadRechargeReceipt failed', error: e);
      return null;
    }
  }

  Future<bool> requestRecharge({
    required String driverId,
    required String transactionNumber,
    required String receiptUrl,
    String? note,
  }) async {
    try {
      final ref = _db.collection(CollectionNames.walletRechargeRequests).doc();
      await ref.set({
        'id': ref.id,
        'driver_id': driverId,
        'transaction_number': transactionNumber,
        'receipt_url': receiptUrl,
        'status': 'pending',
        'note': note,
        'createdAt': Timestamp.now(),
      });
      return true;
    } catch (e) {
      AppLogger.error('requestRecharge failed', error: e);
      return false;
    }
  }

  String _contentTypeFromFileName(String fileName) {
    final lower = fileName.toLowerCase();
    if (lower.endsWith('.png')) return 'image/png';
    if (lower.endsWith('.webp')) return 'image/webp';
    return 'image/jpeg';
  }
}
