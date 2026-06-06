import 'package:cloud_firestore/cloud_firestore.dart';

/// نموذج بيانات السائق
class UserModel {
  UserModel({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.profilePictureURL,
    this.fcmToken,
    this.countryCode,
    this.phoneNumber,
    this.walletAmount,
    this.active,
    this.isActive,
    this.isDocumentVerify,
    this.createdAt,
    this.role,
    this.location,
    this.userBankDetails,
    this.carName,
    this.carNumber,
    this.carPictureURL,
    this.vehicleType,
    this.inProgressOrderID,
    this.orderRequestData,
    this.reviewsCount,
    this.reviewsSum,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'] as String?,
        email: json['email'] as String?,
        firstName: json['firstName'] as String?,
        lastName: json['lastName'] as String?,
        profilePictureURL: json['profilePictureURL'] as String?,
        fcmToken: json['fcmToken'] as String?,
        countryCode: json['countryCode'] as String?,
        phoneNumber: json['phoneNumber'] as String?,
        walletAmount: json['wallet_amount'] as num?,
        active: json['active'] as bool?,
        isActive: json['isActive'] as bool?,
        isDocumentVerify: (json['isDocumentVerify'] as bool?) ?? false,
        createdAt: json['createdAt'] as Timestamp?,
        role: (json['role'] as String?) ?? 'driver',
        location: json['location'] != null
            ? UserLocation.fromJson(
                Map<String, dynamic>.from(json['location'] as Map),
              )
            : null,
        userBankDetails: json['userBankDetails'] != null
            ? UserBankDetails.fromJson(
                Map<String, dynamic>.from(json['userBankDetails'] as Map),
              )
            : null,
        carName: json['carName'] as String?,
        carNumber: json['carNumber'] as String?,
        carPictureURL: json['carPictureURL'] as String?,
        vehicleType: json['vehicleType'] as String?,
        inProgressOrderID: (json['inProgressOrderID'] as List<dynamic>?) ?? [],
        orderRequestData: (json['orderRequestData'] as List<dynamic>?) ?? [],
        reviewsCount: ((json['reviewsCount']) ?? '0').toString(),
        reviewsSum: ((json['reviewsSum']) ?? '0').toString(),
      );

  String? id;
  String? firstName;
  String? lastName;
  String? email;
  String? profilePictureURL;
  String? fcmToken;
  String? countryCode;
  String? phoneNumber;
  num? walletAmount;
  bool? active;
  bool? isActive;
  bool? isDocumentVerify;
  Timestamp? createdAt;
  String? role;
  UserLocation? location;
  UserBankDetails? userBankDetails;

  // ── Driver-specific ───────────────────────────────────────
  String? carName;
  String? carNumber;
  String? carPictureURL;
  String? vehicleType;
  List<dynamic>? inProgressOrderID;
  List<dynamic>? orderRequestData;
  String? reviewsCount;
  String? reviewsSum;

  String get fullName => '${firstName ?? ''} ${lastName ?? ''}'.trim();
  bool get isOnline => active == true;
  double get averageRating {
    final double sum = double.tryParse(reviewsSum ?? '0') ?? 0.0;
    final double count = double.tryParse(reviewsCount ?? '0') ?? 0.0;
    if (count <= 0) return 0.0;
    return sum / count;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'firstName': firstName,
        'lastName': lastName,
        'profilePictureURL': profilePictureURL,
        'fcmToken': fcmToken,
        'countryCode': countryCode,
        'phoneNumber': phoneNumber,
        'wallet_amount': walletAmount ?? 0,
        'active': active,
        'isActive': isActive,
        'isDocumentVerify': isDocumentVerify,
        'createdAt': createdAt,
        'role': role,
        if (location != null) 'location': location!.toJson(),
        if (userBankDetails != null)
          'userBankDetails': userBankDetails!.toJson(),
        'carName': carName,
        'carNumber': carNumber,
        'carPictureURL': carPictureURL,
        'vehicleType': vehicleType,
        'inProgressOrderID': inProgressOrderID ?? [],
        'orderRequestData': orderRequestData ?? [],
        'reviewsCount': reviewsCount,
        'reviewsSum': reviewsSum,
      };
}

/// موقع المستخدم الجغرافي
class UserLocation {
  const UserLocation({this.latitude, this.longitude});

  factory UserLocation.fromJson(Map<String, dynamic> json) => UserLocation(
        latitude: (json['latitude'] as num?)?.toDouble(),
        longitude: (json['longitude'] as num?)?.toDouble(),
      );

  final double? latitude;
  final double? longitude;

  Map<String, dynamic> toJson() => {
        'latitude': latitude,
        'longitude': longitude,
      };
}

/// بيانات الحساب البنكي للسائق
class UserBankDetails {
  const UserBankDetails({
    this.bankName = '',
    this.branchName = '',
    this.holderName = '',
    this.accountNumber = '',
    this.otherDetails = '',
  });

  factory UserBankDetails.fromJson(Map<String, dynamic> json) =>
      UserBankDetails(
        bankName: (json['bankName'] as String?) ?? '',
        branchName: (json['branchName'] as String?) ?? '',
        holderName: (json['holderName'] as String?) ?? '',
        accountNumber: (json['accountNumber'] as String?) ?? '',
        otherDetails: (json['otherDetails'] as String?) ?? '',
      );

  final String bankName;
  final String branchName;
  final String holderName;
  final String accountNumber;
  final String otherDetails;

  Map<String, dynamic> toJson() => {
        'bankName': bankName,
        'branchName': branchName,
        'holderName': holderName,
        'accountNumber': accountNumber,
        'otherDetails': otherDetails,
      };
}

/// عنوان التوصيل
class DeliveryAddress {
  const DeliveryAddress({
    this.id,
    this.address,
    this.landmark,
    this.locality,
    this.location,
  });

  factory DeliveryAddress.fromJson(Map<String, dynamic> json) =>
      DeliveryAddress(
        id: json['id'] as String?,
        address: json['address'] as String?,
        landmark: json['landmark'] as String?,
        locality: json['locality'] as String?,
        location: json['location'] != null
            ? UserLocation.fromJson(
                Map<String, dynamic>.from(json['location'] as Map),
              )
            : null,
      );

  final String? id;
  final String? address;
  final String? landmark;
  final String? locality;
  final UserLocation? location;

  Map<String, dynamic> toJson() => {
        'id': id,
        'address': address,
        'landmark': landmark,
        'locality': locality,
        if (location != null) 'location': location!.toJson(),
      };

  String get fullAddress => [address, locality, landmark]
      .where((e) => e != null && e.isNotEmpty)
      .join(' ');
}
