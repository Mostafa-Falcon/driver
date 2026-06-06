import 'package:cloud_firestore/cloud_firestore.dart';

class DriverPayoutModel {
  const DriverPayoutModel({
    this.id,
    this.driverId,
    this.amount,
    this.status,
    this.methodId,
    this.note,
    this.adminNote,
    this.createdAt,
    this.paidDate,
  });

  factory DriverPayoutModel.fromJson(Map<String, dynamic> json) {
    return DriverPayoutModel(
      id: json['id'] as String?,
      driverId: (json['driver_id'] as String?) ?? json['driverID'] as String?,
      amount: double.tryParse('${json['amount'] ?? 0}') ?? 0,
      status: (json['status'] as String?) ?? (json['paymentStatus'] as String?),
      methodId:
          (json['method_id'] as String?) ?? (json['withdrawMethod'] as String?),
      note: json['note'] as String?,
      adminNote: json['adminNote'] as String?,
      createdAt: json['createdAt'] as Timestamp?,
      paidDate: json['paidDate'] as Timestamp?,
    );
  }

  final String? id;
  final String? driverId;
  final double? amount;
  final String? status;
  final String? methodId;
  final String? note;
  final String? adminNote;
  final Timestamp? createdAt;
  final Timestamp? paidDate;

  Timestamp? get displayDate => createdAt ?? paidDate;
}
