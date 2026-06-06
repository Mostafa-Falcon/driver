import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver/app/data/models/order_event_model.dart';
import 'package:driver/app/data/models/order_model.dart';
import 'package:driver/app/data/models/user_model.dart';
import 'package:driver/core/constants/app_constants.dart';
import 'package:driver/core/constants/collection_names.dart';
import 'package:driver/core/utils/app_logger.dart';

/// Repository للعمليات المتعلقة بالطلبات
/// يستخدم Firestore Transactions للعمليات الحساسة
class OrderRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

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

  // ── Transactions ──────────────────────────────────────────

  /// قبول الطلب بشكل آمن باستخدام Firestore Transaction
  /// يمنع قبول نفس الطلب من مندوبَين في نفس الوقت
  Future<bool> acceptOrder({
    required String orderId,
    required UserModel driver,
  }) async {
    final orderRef = _db.collection(CollectionNames.vendorOrders).doc(orderId);
    final driverRef = _db.collection(CollectionNames.users).doc(driver.id);

    try {
      return await _db.runTransaction<bool>((transaction) async {
        // 1. قراءة الطلب الحالي
        final orderSnap = await transaction.get(orderRef);
        if (!orderSnap.exists) {
          throw Exception('الطلب غير موجود');
        }

        final data = orderSnap.data()!;
        final existingDriverId = data['driverID'];

        // 2. التحقق من عدم الحجز المسبق
        if (existingDriverId != null && existingDriverId != driver.id) {
          throw Exception('تم قبول الطلب من مندوب آخر');
        }

        // 3. التحقق من صلاحية الحالة
        final currentStatus = data['status'] as String?;
        if (currentStatus != AppConstants.statusOrderPlaced &&
            currentStatus != AppConstants.statusOffered) {
          throw Exception('الطلب لم يعد متاحاً');
        }

        // 4. تحديث الطلب
        transaction.update(orderRef, {
          'status': AppConstants.statusDriverAccepted,
          'driverID': driver.id,
          'driver': driver.toJson(),
        });

        // 5. تسجيل الحدث
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
            actorId: driver.id,
            actorRole: 'driver',
            createdAt: Timestamp.now(),
          ).toJson(),
        );

        // 6. تحديث حالة السائق
        transaction.update(driverRef, {
          'inProgressOrderID': FieldValue.arrayUnion([orderId]),
          'orderRequestData': FieldValue.arrayRemove([orderId]),
        });

        return true;
      });
    } catch (e) {
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
        transaction.update(orderRef, {'status': nextStatus});

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
}
