import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver/app/data/models/support_ticket_model.dart';
import 'package:driver/core/constants/collection_names.dart';
import 'package:driver/core/utils/app_logger.dart';

class SupportRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  static const List<String> defaultReasons = [
    'مشكلة في الطلب',
    'مشكلة في التطبيق',
    'مشكلة في المحفظة',
    'طلب تعديل البيانات',
    'الإبلاغ عن عميل',
    'أخرى',
  ];

  Future<bool> createTicket(SupportTicketModel ticket) async {
    try {
      final ref = _db.collection(CollectionNames.supportTickets).doc();
      await ref.set({
        ...ticket.toJson(),
        'id': ref.id,
        'createdAt': Timestamp.now(),
      });
      return true;
    } catch (e) {
      AppLogger.error('createTicket failed', error: e);
      return false;
    }
  }

  Stream<List<SupportTicketModel>> listenDriverTickets(String driverId) {
    return _db
        .collection(CollectionNames.supportTickets)
        .where('driver_id', isEqualTo: driverId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => SupportTicketModel.fromJson(doc.data()))
              .toList(),
        );
  }
}
