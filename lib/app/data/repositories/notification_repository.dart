import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver/app/data/models/notification_model.dart';
import 'package:driver/core/constants/collection_names.dart';
import 'package:driver/core/utils/app_logger.dart';

class NotificationRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<NotificationModel>> listenDriverNotifications(String driverId) {
    // ignore: close_sinks - the returned stream owns this controller lifecycle.
    final controller = StreamController<List<NotificationModel>>();
    final snapshotsByField = <String, QuerySnapshot<Map<String, dynamic>>>{};
    final subscriptions =
        <StreamSubscription<QuerySnapshot<Map<String, dynamic>>>>[];
    final collection = _db.collection(CollectionNames.notifications);
    const recipientFields = ['user_id', 'userId', 'driverId', 'id'];

    void emitMergedNotifications() {
      final docsById = <String, QueryDocumentSnapshot<Map<String, dynamic>>>{};

      for (final snapshot in snapshotsByField.values) {
        for (final doc in snapshot.docs) {
          docsById[doc.id] = doc;
        }
      }

      final items = docsById.values
          .map(
            (doc) => NotificationModel.fromJson(
              {
                ...doc.data(),
                'notificationId': doc.id,
              },
            ),
          )
          .toList()
        ..sort((a, b) {
          final first = a.createdAt?.millisecondsSinceEpoch ?? 0;
          final second = b.createdAt?.millisecondsSinceEpoch ?? 0;
          return second.compareTo(first);
        });

      if (!controller.isClosed) controller.add(items.take(100).toList());
    }

    for (final field in recipientFields) {
      final sub =
          collection.where(field, isEqualTo: driverId).snapshots().listen(
        (snapshot) {
          snapshotsByField[field] = snapshot;
          emitMergedNotifications();
        },
        onError: (Object e) {
          AppLogger.error(
            'notifications stream error for field $field',
            error: e,
          );
          emitMergedNotifications();
        },
      );
      subscriptions.add(sub);
    }

    controller.onCancel = () async {
      for (final sub in subscriptions) {
        await sub.cancel();
      }
    };

    return controller.stream;
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

  Future<void> markAllAsRead(List<String> notificationIds) async {
    if (notificationIds.isEmpty) return;

    try {
      WriteBatch batch = _db.batch();
      var operations = 0;

      for (final id in notificationIds) {
        batch.update(
          _db.collection(CollectionNames.notifications).doc(id),
          {'isRead': true},
        );
        operations++;

        if (operations == 450) {
          await batch.commit();
          batch = _db.batch();
          operations = 0;
        }
      }

      if (operations > 0) await batch.commit();
    } catch (e) {
      AppLogger.error('markAllAsRead failed', error: e);
    }
  }
}
