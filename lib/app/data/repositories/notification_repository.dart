import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver/app/data/models/notification_model.dart';
import 'package:driver/core/constants/collection_names.dart';
import 'package:driver/core/utils/app_logger.dart';

class NotificationRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<NotificationModel>> listenDriverNotifications(String driverId) {
    return _db
        .collection(CollectionNames.notifications)
        .where('user_id', isEqualTo: driverId)
        .orderBy('createdAt', descending: true)
        .limit(100)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => NotificationModel.fromJson(doc.data()))
              .toList(),
        );
  }

  Future<void> markAsRead(String notificationId) async {
    try {
      await _db
          .collection(CollectionNames.notifications)
          .doc(notificationId)
          .update({'isRead': true});
    } catch (e) {
      AppLogger.error('markAsRead failed for $notificationId', error: e);
    }
  }
}
