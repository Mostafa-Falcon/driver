import 'package:cloud_firestore/cloud_firestore.dart';

/// نموذج تذكرة الدعم الفني
class SupportTicketModel {
  const SupportTicketModel({
    this.id,
    this.driverId,
    this.reason,
    this.message,
    this.status,
    this.orderId,
    this.createdAt,
  });

  factory SupportTicketModel.fromJson(Map<String, dynamic> json) =>
      SupportTicketModel(
        id: json['id'] as String?,
        driverId: json['driver_id'] as String?,
        reason: json['reason'] as String?,
        message: json['message'] as String?,
        status: (json['status'] as String?) ?? 'open',
        orderId: json['order_id'] as String?,
        createdAt: json['createdAt'] as Timestamp?,
      );

  final String? id;
  final String? driverId;
  final String? reason;
  final String? message;
  final String? status; // open | closed | pending
  final String? orderId;
  final Timestamp? createdAt;

  Map<String, dynamic> toJson() => {
        'id': id,
        'driver_id': driverId,
        'reason': reason,
        'message': message,
        'status': status ?? 'open',
        'order_id': orderId,
        'createdAt': createdAt ?? Timestamp.now(),
      };
}
