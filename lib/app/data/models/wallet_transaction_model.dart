import 'package:cloud_firestore/cloud_firestore.dart';

/// نموذج معاملات المحفظة
/// كل حركة مالية لها سجل مستقل مع ID حتمي لمنع التكرار
class WalletTransactionModel {
  const WalletTransactionModel({
    this.id,
    this.userId,
    this.amount,
    this.isTopup,
    this.orderId,
    this.paymentStatus,
    this.date,
    this.note,
    this.transactionType,
  });

  factory WalletTransactionModel.fromJson(Map<String, dynamic> json) =>
      WalletTransactionModel(
        id: json['id'] as String?,
        userId: json['user_id'] as String?,
        amount: double.tryParse('${json['amount'] ?? 0.0}') ?? 0.0,
        isTopup: (json['isTopUp'] as bool?) ?? false,
        orderId: json['order_id'] as String?,
        paymentStatus: json['payment_status'] as String?,
        date: json['date'] as Timestamp?,
        note: (json['note'] as String?) ?? '',
        transactionType: (json['transactionType'] as String?) ??
            ((json['isTopUp'] as bool?) == true ? 'topup' : 'withdrawal'),
      );

  /// Factory لإنشاء معاملة عمولة بـ ID حتمي لمنع التكرار
  factory WalletTransactionModel.commission({
    required String driverId,
    required String orderId,
    required double amount,
  }) =>
      WalletTransactionModel(
        id: 'commission_${orderId}_$driverId',
        userId: driverId,
        amount: amount,
        isTopup: false,
        orderId: orderId,
        paymentStatus: 'success',
        date: Timestamp.now(),
        note: 'عمولة الطلب #$orderId',
        transactionType: 'commission',
      );

  final String? id; // Deterministic ID لمنع الخصم مرتين
  final String? userId;
  final double? amount;
  final bool? isTopup; // إضافة أم خصم
  final String? orderId; // ربط بالطلب إن وجد
  final String? paymentStatus;
  final Timestamp? date;
  final String? note;
  final String?
      transactionType; // topup | withdrawal | commission | adjustment | refund

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'amount': amount,
        'isTopUp': isTopup,
        'order_id': orderId,
        'payment_status': paymentStatus ?? 'success',
        'date': date ?? Timestamp.now(),
        'note': note,
        'transactionType': transactionType,
      };
}
