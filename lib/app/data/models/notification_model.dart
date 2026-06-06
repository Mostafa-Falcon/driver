import 'package:cloud_firestore/cloud_firestore.dart';

/// نموذج الإشعارات
class NotificationModel {
  const NotificationModel({
    this.id,
    this.title,
    this.message,
    this.type,
    this.orderId,
    this.isRead,
    this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        id: json['id'] as String?,
        title: json['title'] as String?,
        message: (json['message'] ?? json['body']) as String?,
        type: json['type'] as String?,
        orderId: json['order_id'] as String?,
        isRead: (json['isRead'] as bool?) ?? false,
        createdAt: json['createdAt'] as Timestamp?,
      );

  final String? id;
  final String? title;
  final String? message;
  final String? type; // new_order_placed | driver_accepted | driver_completed
  final String? orderId;
  final bool? isRead;
  final Timestamp? createdAt;

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'message': message,
        'type': type,
        'order_id': orderId,
        'isRead': isRead ?? false,
        'createdAt': createdAt ?? Timestamp.now(),
      };
}
