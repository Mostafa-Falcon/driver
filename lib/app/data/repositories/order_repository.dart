import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver/app/data/models/order_event_model.dart';
import 'package:driver/app/data/models/order_model.dart';
import 'package:driver/app/data/models/user_model.dart';
import 'package:driver/app/data/models/wallet_transaction_model.dart';
import 'package:driver/core/constants/app_constants.dart';
import 'package:driver/core/constants/collection_names.dart';
import 'package:driver/core/utils/app_logger.dart';
import 'package:firebase_storage/firebase_storage.dart';

/// Repository للعمليات المتعلقة بالطلبات
/// يستخدم Firestore Transactions للعمليات الحساسة
class OrderRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  String? lastErrorMessage;

  // ── Queries ───────────────────────────────────────────────

  /// الاستماع للطلبات الجديدة المعروضة على المندوب
  Stream<List<OrderModel>> listenNewOrders(String driverId) {
    return _db
        .collection(CollectionNames.vendorOrders)
        .where('orderRequestData', arrayContains: driverId)
        .where('status', isEqualTo: AppConstants.statusOrderPlaced)
        .snapshots()
        .map(
          (snap) =>
              snap.docs.map((d) => OrderModel.fromJson(d.data())).toList(),
        );
  }

  /// الاستماع للطلبات النشطة للمندوب
  Stream<List<OrderModel>> listenActiveOrders(String driverId) {
    return _db
        .collection(CollectionNames.vendorOrders)
        .where('driverID', isEqualTo: driverId)
        .where(
          'status',
          whereIn: [
            AppConstants.statusDriverAccepted,
            AppConstants.statusOrderShipped,
            AppConstants.statusInTransit,
          ],
        )
        .snapshots()
        .map(
          (snap) =>
              snap.docs.map((d) => OrderModel.fromJson(d.data())).toList(),
        );
  }

  /// الاستماع للطلبات السابقة للمندوب
  Stream<List<OrderModel>> listenPreviousOrders(String driverId) {
    return _db
        .collection(CollectionNames.vendorOrders)
        .where('driverID', isEqualTo: driverId)
        .where(
          'status',
          whereIn: [
            AppConstants.statusOrderCompleted,
            AppConstants.statusOrderCancelled,
          ],
        )
        .orderBy('createdAt', descending: true)
        .limit(50)
        .snapshots()
        .map(
          (snap) =>
              snap.docs.map((d) => OrderModel.fromJson(d.data())).toList(),
        );
  }

  /// جلب طلب واحد بالـ ID
  Future<OrderModel?> getOrderById(String orderId) async {
    try {
      final doc =
          await _db.collection(CollectionNames.vendorOrders).doc(orderId).get();
      if (doc.exists && doc.data() != null) {
        return OrderModel.fromJson(doc.data()!);
      }
    } catch (e) {
      AppLogger.error('getOrderById failed for $orderId', error: e);
    }
    return null;
  }

  Future<String?> uploadOrderProofPhoto({
    required String orderId,
    required String driverId,
    required String proofType,
    required Uint8List bytes,
    required String fileName,
  }) async {
    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final safeFileName = fileName.replaceAll(RegExp(r'[^a-zA-Z0-9._-]'), '_');
      final ref = _storage.ref().child(
            'order_proofs/$orderId/$proofType/${driverId}_${timestamp}_$safeFileName',
          );

      final upload = await ref.putData(
        bytes,
        SettableMetadata(contentType: _contentTypeFromFileName(fileName)),
      );

      return upload.ref.getDownloadURL();
    } catch (e) {
      AppLogger.error('uploadOrderProofPhoto failed for $orderId', error: e);
      return null;
    }
  }

  // ── Transactions ──────────────────────────────────────────

  /// قبول الطلب بشكل آمن باستخدام Firestore Transaction
  /// يمنع قبول نفس الطلب من مندوبَين في نفس الوقت
  Future<bool> acceptOrder({
    required String orderId,
    required UserModel driver,
  }) async {
    final driverId = driver.id;
    if (driverId == null) {
      lastErrorMessage = 'بيانات السائق غير مكتملة';
      return false;
    }

    final orderRef = _db.collection(CollectionNames.vendorOrders).doc(orderId);
    final driverRef = _db.collection(CollectionNames.users).doc(driverId);
    lastErrorMessage = null;

    try {
      return await _db.runTransaction<bool>((transaction) async {
        final orderSnap = await transaction.get(orderRef);
        if (!orderSnap.exists) {
          throw Exception('الطلب غير موجود');
        }

        final data = orderSnap.data()!;
        final existingDriverId = data['driverID'];
        final commissionAmount = _resolveDriverAppCommission(data);
        final commissionRef = _db
            .collection(CollectionNames.wallet)
            .doc('commission_${orderId}_$driverId');
        final driverSnap = await transaction.get(driverRef);
        final commissionSnap =
            commissionAmount > 0 ? await transaction.get(commissionRef) : null;

        if (existingDriverId != null && existingDriverId != driverId) {
          throw Exception('تم قبول الطلب من مندوب آخر');
        }

        final currentStatus = data['status'] as String?;
        if (currentStatus != AppConstants.statusOrderPlaced &&
            currentStatus != AppConstants.statusOffered) {
          throw Exception('الطلب لم يعد متاحاً');
        }

        if (!driverSnap.exists) {
          throw Exception('بيانات السائق غير موجودة');
        }

        final currentBalance =
            (driverSnap.data()?['wallet_amount'] as num?)?.toDouble() ?? 0.0;
        if (commissionAmount > 0 && currentBalance < commissionAmount) {
          throw Exception('رصيد المحفظة غير كاف لقبول الطلب');
        }
        if (commissionSnap?.exists == true) {
          throw Exception('تم خصم عمولة هذا الطلب مسبقا');
        }

        transaction.update(orderRef, {
          'status': AppConstants.statusDriverAccepted,
          'driverID': driverId,
          'driver': driver.toJson(),
          'driver_app_commission_amount': commissionAmount,
          if (commissionAmount > 0) ...{
            'commission_wallet_transaction_id': commissionRef.id,
            'commission_deducted_at': Timestamp.now(),
          },
        });

        final eventRef =
            orderRef.collection(CollectionNames.orderEventsSubcollection).doc();
        transaction.set(
          eventRef,
          OrderEventModel(
            id: eventRef.id,
            orderId: orderId,
            orderCollection: CollectionNames.vendorOrders,
            eventType: AppConstants.eventAccepted,
            previousStatus: currentStatus,
            nextStatus: AppConstants.statusDriverAccepted,
            actorId: driverId,
            actorRole: 'driver',
            metadata: {
              'driver_app_commission_amount': commissionAmount,
              if (commissionAmount > 0)
                'wallet_transaction_id': commissionRef.id,
            },
            createdAt: Timestamp.now(),
          ).toJson(),
        );

        if (commissionAmount > 0) {
          final commission = WalletTransactionModel.commission(
            driverId: driverId,
            orderId: orderId,
            amount: commissionAmount,
          );
          transaction.set(commissionRef, {
            ...commission.toJson(),
            'id': commissionRef.id,
            'user_id': driverId,
          });
        }

        transaction.update(driverRef, {
          'inProgressOrderID': FieldValue.arrayUnion([orderId]),
          'orderRequestData': FieldValue.arrayRemove([orderId]),
          if (commissionAmount > 0)
            'wallet_amount': currentBalance - commissionAmount,
        });

        return true;
      });
    } catch (e) {
      lastErrorMessage = _friendlyOrderError(e);
      AppLogger.error('acceptOrder failed for $orderId', error: e);
      return false;
    }
  }

  /// إخفاء الطلب عن المندوب بدون تغيير حالته العالمية
  Future<bool> hideOrder({
    required String orderId,
    required String driverId,
  }) async {
    final orderRef = _db.collection(CollectionNames.vendorOrders).doc(orderId);
    final driverRef = _db.collection(CollectionNames.users).doc(driverId);

    try {
      return await _db.runTransaction<bool>((transaction) async {
        // 1. تسجيل الحدث
        final eventRef =
            orderRef.collection(CollectionNames.orderEventsSubcollection).doc();
        transaction.set(
          eventRef,
          OrderEventModel(
            id: eventRef.id,
            orderId: orderId,
            orderCollection: CollectionNames.vendorOrders,
            eventType: AppConstants.eventHidden,
            actorId: driverId,
            actorRole: 'driver',
            createdAt: Timestamp.now(),
          ).toJson(),
        );

        // 2. إزالة الطلب من قائمة المندوب فقط
        transaction.update(driverRef, {
          'orderRequestData': FieldValue.arrayRemove([orderId]),
        });

        return true;
      });
    } catch (e) {
      AppLogger.error('hideOrder failed for $orderId', error: e);
      return false;
    }
  }

  /// تحديث حالة الطلب مع التحقق الأمني
  /// [allowedCurrentStatuses]: الحالات المسموح بالانتقال منها
  Future<bool> updateOrderStatus({
    required String orderId,
    required String driverId,
    required String nextStatus,
    required List<String> allowedCurrentStatuses,
    required String eventType,
    String? note,
    Map<String, dynamic>? orderUpdates,
    Map<String, dynamic>? eventMetadata,
    bool clearFromActive = false,
  }) async {
    final orderRef = _db.collection(CollectionNames.vendorOrders).doc(orderId);
    final driverRef = _db.collection(CollectionNames.users).doc(driverId);

    try {
      return await _db.runTransaction<bool>((transaction) async {
        final orderSnap = await transaction.get(orderRef);
        if (!orderSnap.exists) return false;

        final data = orderSnap.data()!;
        final currentStatus = data['status'] as String?;
        final assignedDriverId = data['driverID'];

        // 1. التحقق الأمني: المندوب المخصص فقط
        if (assignedDriverId != driverId) {
          throw Exception('غير مصرح: الطلب غير مخصص لك');
        }

        // 2. التحقق من ترتيب الحالات
        if (!allowedCurrentStatuses.contains(currentStatus)) {
          throw Exception(
            'لا يمكن الانتقال من $currentStatus إلى $nextStatus',
          );
        }

        // 3. تحديث حالة الطلب
        transaction.update(orderRef, {
          'status': nextStatus,
          if (orderUpdates != null) ...orderUpdates,
        });

        // 4. تسجيل الحدث
        final eventRef =
            orderRef.collection(CollectionNames.orderEventsSubcollection).doc();
        transaction.set(
          eventRef,
          OrderEventModel(
            id: eventRef.id,
            orderId: orderId,
            orderCollection: CollectionNames.vendorOrders,
            eventType: eventType,
            previousStatus: currentStatus,
            nextStatus: nextStatus,
            actorId: driverId,
            actorRole: 'driver',
            note: note,
            metadata: eventMetadata,
            createdAt: Timestamp.now(),
          ).toJson(),
        );

        // 5. إزالة من الطلبات النشطة عند الانتهاء أو الإلغاء
        if (clearFromActive) {
          transaction.update(driverRef, {
            'inProgressOrderID': FieldValue.arrayRemove([orderId]),
          });
        }

        return true;
      });
    } catch (e) {
      AppLogger.error('updateOrderStatus failed for $orderId', error: e);
      return false;
    }
  }

  double _resolveDriverAppCommission(Map<String, dynamic> orderData) {
    final explicit = _firstPositiveNumber(orderData, const [
      'driver_app_commission',
      'driverAppCommission',
      'app_commission',
      'appCommission',
    ]);
    if (explicit != null) return explicit;

    final adminCommission =
        double.tryParse('${orderData['adminCommission'] ?? 0}') ?? 0.0;
    if (adminCommission <= 0) {
      return AppConstants.defaultDriverAppCommission;
    }

    final type = '${orderData['adminCommissionType'] ?? ''}'.toLowerCase();
    if (type == 'percentage') {
      final subtotal = double.tryParse('${orderData['subTotal'] ?? 0}') ?? 0.0;
      final discount = double.tryParse('${orderData['discount'] ?? 0}') ?? 0.0;
      final base = subtotal - discount;
      if (base <= 0) return 0;
      return base * adminCommission / 100;
    }

    return adminCommission;
  }

  double? _firstPositiveNumber(
    Map<String, dynamic> data,
    List<String> keys,
  ) {
    for (final key in keys) {
      final value = double.tryParse('${data[key] ?? ''}');
      if (value != null && value > 0) return value;
    }
    return null;
  }

  String _contentTypeFromFileName(String fileName) {
    final lower = fileName.toLowerCase();
    if (lower.endsWith('.png')) return 'image/png';
    if (lower.endsWith('.webp')) return 'image/webp';
    return 'image/jpeg';
  }

  String _friendlyOrderError(Object error) {
    final text = error.toString();
    if (text.contains('رصيد') || text.contains('wallet')) {
      return 'رصيد المحفظة غير كاف لقبول الطلب';
    }
    if (text.contains('عمولة') || text.contains('commission')) {
      return 'تم خصم عمولة هذا الطلب مسبقا';
    }
    if (text.contains('آخر')) {
      return 'تم قبول الطلب من سائق آخر';
    }
    if (text.contains('متاح')) {
      return 'الطلب لم يعد متاحا';
    }
    return 'تعذر قبول الطلب';
  }
}
