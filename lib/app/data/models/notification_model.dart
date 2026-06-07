import 'package:cloud_firestore/cloud_firestore.dart';

/// نموذج الإشعارات
class NotificationModel {
  const NotificationModel({
    this.id,
    this.title,
    this.message,
    this.type,
    this.orderId,
    this.userId,
    this.isRead,
    this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        id: _stringFromAny(
          json['notificationId'] ??
              json['notification_id'] ??
              json['docId'] ??
              json['id'],
        ),
        title: _stringFromAny(json['title'] ?? json['subject']),
        message: _stringFromAny(json['message'] ?? json['body']),
        type: _stringFromAny(json['type'] ?? json['notificationType']),
        orderId: _stringFromAny(
          json['order_id'] ?? json['orderId'] ?? json['orderID'],
        ),
        userId: _stringFromAny(
          json['user_id'] ?? json['userId'] ?? json['driverId'] ?? json['id'],
        ),
        isRead: _boolFromAny(json['isRead'] ?? json['is_read'] ?? json['read']),
        createdAt: _timestampFromAny(
          json['createdAt'] ?? json['created_at'] ?? json['date'],
        ),
      );

  final String? id;
  final String? title;
  final String? message;
  final String? type; // new_order_placed | driver_accepted | driver_completed
  final String? orderId;
  final String? userId;
  final bool? isRead;
  final Timestamp? createdAt;

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'message': message,
        'type': type,
        'order_id': orderId,
        'user_id': userId,
        'isRead': isRead ?? false,
        'createdAt': createdAt ?? Timestamp.now(),
      };
}

String? _stringFromAny(dynamic value) {
  if (value == null) return null;
  final text = value.toString().trim();
  return text.isEmpty ? null : text;
}

Timestamp? _timestampFromAny(dynamic value) {
  if (value == null) return null;
  if (value is Timestamp) return value;
  if (value is DateTime) return Timestamp.fromDate(value);
  if (value is int) {
    return Timestamp.fromMillisecondsSinceEpoch(value);
  }
  return null;
}

bool _boolFromAny(dynamic value) {
  if (value is bool) return value;
  if (value is num) return value != 0;
  if (value is String) {
    final normalized = value.trim().toLowerCase();
    return normalized == 'true' || normalized == '1' || normalized == 'yes';
  }
  return false;
}
