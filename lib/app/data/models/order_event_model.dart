import 'package:cloud_firestore/cloud_firestore.dart';

/// نموذج أحداث الطلب — سجل كامل لكل تغيير
/// يُحفظ كـ subcollection داخل كل طلب
class OrderEventModel {
  const OrderEventModel({
    this.id,
    this.orderId,
    this.orderCollection,
    this.eventType,
    this.previousStatus,
    this.nextStatus,
    this.actorId,
    this.actorRole,
    this.note,
    this.createdAt,
    this.metadata,
  });

  factory OrderEventModel.fromJson(Map<String, dynamic> json) =>
      OrderEventModel(
        id: json['id'] as String?,
        orderId: json['order_id'] as String?,
        orderCollection: json['order_collection'] as String?,
        eventType: json['event_type'] as String?,
        previousStatus: json['previous_status'] as String?,
        nextStatus: json['next_status'] as String?,
        actorId: json['actor_id'] as String?,
        actorRole: json['actor_role'] as String?,
        note: json['note'] as String?,
        createdAt: json['created_at'] as Timestamp?,
        metadata: json['metadata'] != null
            ? Map<String, dynamic>.from(json['metadata'] as Map)
            : null,
      );

  final String? id;
  final String? orderId;
  final String? orderCollection;
  final String?
      eventType; // accepted, hidden, picked_up, status_changed, completed, cancelled
  final String? previousStatus;
  final String? nextStatus;
  final String? actorId; // ID السائق أو الإدارة
  final String? actorRole; // driver | admin
  final String? note;
  final Timestamp? createdAt;
  final Map<String, dynamic>? metadata;

  Map<String, dynamic> toJson() => {
        'id': id,
        'order_id': orderId,
        'order_collection': orderCollection,
        'event_type': eventType,
        'previous_status': previousStatus,
        'next_status': nextStatus,
        'actor_id': actorId,
        'actor_role': actorRole ?? 'driver',
        'note': note,
        'created_at': createdAt ?? Timestamp.now(),
        if (metadata != null) 'metadata': metadata,
      };
}
