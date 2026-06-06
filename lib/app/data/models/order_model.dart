import 'package:cloud_firestore/cloud_firestore.dart';
import 'user_model.dart';

/// نموذج بيانات طلب التوصيل
/// يشمل جميع حقول دورة حياة الطلب للمندوب
class OrderModel {
  OrderModel({
    this.id,
    this.status,
    this.vendorID,
    this.driverID,
    this.authorID,
    this.paymentMethod,
    this.createdAt,
    this.subTotal,
    this.deliveryCharge,
    this.adminCommission,
    this.adminCommissionType,
    this.tipAmount,
    this.discount,
    this.pickupAddress,
    this.dropAddress,
    this.notes,
    this.audioNote,
    this.attachments,
    this.pickupPhotoUrl,
    this.deliveryPhotoUrl,
    this.rejectedByDrivers,
    this.author,
    this.driver,
  });

  // ── JSON ──────────────────────────────────────────────────
  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
        id: json['id'] as String?,
        status: json['status'] as String?,
        vendorID: json['vendorID'] as String?,
        driverID: json['driverID'] as String?,
        authorID: json['authorID'] as String?,
        paymentMethod: json['payment_method'] as String?,
        createdAt: json['createdAt'] as Timestamp?,
        subTotal: (json['subTotal'] ?? '0.0').toString(),
        deliveryCharge: (json['deliveryCharge'] ?? '0.0').toString(),
        adminCommission: (json['adminCommission'] ?? '0').toString(),
        adminCommissionType: json['adminCommissionType'] as String?,
        tipAmount: (json['tip_amount'] ?? '0.0').toString(),
        discount: json['discount'] as num?,
        pickupAddress: json['address'] != null
            ? DeliveryAddress.fromJson(json['address'] as Map<String, dynamic>)
            : null,
        dropAddress: json['dropAddress'] != null
            ? DeliveryAddress.fromJson(
                json['dropAddress'] as Map<String, dynamic>,
              )
            : null,
        notes: json['notes'] as String?,
        audioNote: json['audio_note'] as String?,
        attachments: json['attachments'] as List<dynamic>?,
        pickupPhotoUrl:
            _stringFromAny(json['pickup_photo_url'] ?? json['pickupPhotoUrl']),
        deliveryPhotoUrl: _stringFromAny(
          json['delivery_photo_url'] ?? json['deliveryPhotoUrl'],
        ),
        rejectedByDrivers: json['rejectedByDrivers'] as List<dynamic>?,
        author: json['author'] != null
            ? UserModel.fromJson(json['author'] as Map<String, dynamic>)
            : null,
        driver: json['driver'] != null
            ? UserModel.fromJson(json['driver'] as Map<String, dynamic>)
            : null,
      );

  String? id;
  String? status;
  String? vendorID;
  String? driverID;
  String? authorID;
  String? paymentMethod;
  Timestamp? createdAt;

  // ── المبالغ المالية ───────────────────────────────────────
  String? subTotal;
  String? deliveryCharge;
  String? adminCommission;
  String? adminCommissionType;
  String? tipAmount;
  num? discount;

  // ── العناوين ──────────────────────────────────────────────
  DeliveryAddress? pickupAddress; // مكان الاستلام
  DeliveryAddress? dropAddress; // مكان التسليم

  // ── تفاصيل إضافية ────────────────────────────────────────
  String? notes;
  String? audioNote;
  List<dynamic>? attachments;
  String? pickupPhotoUrl;
  String? deliveryPhotoUrl;
  List<dynamic>? rejectedByDrivers;

  // ── البيانات المضمنة ──────────────────────────────────────
  UserModel? author; // بيانات العميل
  UserModel? driver; // بيانات المندوب

  // ── Computed Properties ───────────────────────────────────

  /// المبلغ الإجمالي للطلب
  double get totalAmount {
    final sub = double.tryParse(subTotal ?? '0') ?? 0.0;
    final delivery = double.tryParse(deliveryCharge ?? '0') ?? 0.0;
    final tip = double.tryParse(tipAmount ?? '0') ?? 0.0;
    final disc = (discount ?? 0).toDouble();
    return sub + delivery + tip - disc;
  }

  /// العمولة المستحقة للسائق
  double get driverEarnings {
    final total = totalAmount;
    final commission = double.tryParse(adminCommission ?? '0') ?? 0.0;
    if (adminCommissionType?.toLowerCase() == 'percentage') {
      return total - (total * commission / 100);
    }
    return total - commission;
  }

  bool get hasAudioNote => audioNote != null && audioNote!.isNotEmpty;

  bool get hasAttachments => attachments != null && attachments!.isNotEmpty;

  bool get hasPickupPhoto =>
      pickupPhotoUrl != null && pickupPhotoUrl!.trim().isNotEmpty;

  bool get hasDeliveryPhoto =>
      deliveryPhotoUrl != null && deliveryPhotoUrl!.trim().isNotEmpty;

  Map<String, dynamic> toJson() => {
        'id': id,
        'status': status,
        'vendorID': vendorID,
        'driverID': driverID,
        'authorID': authorID,
        'payment_method': paymentMethod,
        'createdAt': createdAt,
        'subTotal': subTotal,
        'deliveryCharge': deliveryCharge,
        'adminCommission': adminCommission,
        'adminCommissionType': adminCommissionType,
        'tip_amount': tipAmount,
        'discount': discount,
        if (pickupAddress != null) 'address': pickupAddress!.toJson(),
        if (dropAddress != null) 'dropAddress': dropAddress!.toJson(),
        'notes': notes,
        'audio_note': audioNote,
        'attachments': attachments ?? [],
        'pickup_photo_url': pickupPhotoUrl,
        'delivery_photo_url': deliveryPhotoUrl,
        'rejectedByDrivers': rejectedByDrivers ?? [],
        if (author != null) 'author': author!.toJson(),
        if (driver != null) 'driver': driver!.toJson(),
      };
}

String? _stringFromAny(dynamic value) {
  if (value == null) return null;
  final text = value.toString().trim();
  return text.isEmpty ? null : text;
}
