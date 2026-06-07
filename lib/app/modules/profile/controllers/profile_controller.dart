import 'dart:async';
import 'package:driver/app/data/models/user_model.dart';
import 'package:driver/app/data/models/notification_model.dart';
import 'package:driver/app/data/repositories/user_repository.dart';
import 'package:driver/app/data/repositories/notification_repository.dart';
import 'package:driver/app/services/auth_service.dart';
import 'package:driver/app/services/theme_service.dart';
import 'package:driver/core/utils/app_logger.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProfileController extends GetxController {
  final AuthService auth = AuthService.to;
  final NotificationRepository _notificationRepository =
      NotificationRepository();
  final UserRepository _userRepository = UserRepository();
  final FirebaseStorage _storage = FirebaseStorage.instance;

  final RxBool isOnline = false.obs;
  final RxInt unreadNotificationsCount = 0.obs;
  final RxBool isDark = false.obs;
  final RxBool isUpdatingProfile = false.obs;
  StreamSubscription<List<NotificationModel>>? _notificationsSub;

  @override
  void onInit() {
    super.onInit();
    isOnline.value = auth.user?.isOnline ?? false;
    isDark.value = ThemeService.to.isDark;
    _listenNotifications();
  }

  void _listenNotifications() {
    final userId = auth.userId;
    if (userId == null) return;

    _notificationsSub =
        _notificationRepository.listenDriverNotifications(userId).listen(
      (items) {
        unreadNotificationsCount.value =
            items.where((n) => n.isRead != true).length;
      },
      onError: (Object e) {
        AppLogger.error('notifications stream error in profile', error: e);
      },
    );
  }

  Future<void> toggleOnlineStatus() async {
    await auth.setOnlineStatus(!isOnline.value);
    isOnline.value = !isOnline.value;
    update();
  }

  void toggleTheme(bool val) {
    if (val) {
      ThemeService.to.setDark();
    } else {
      ThemeService.to.setLight();
    }
    isDark.value = val;
  }

  Future<bool> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null || user.email == null) return false;

      final cred = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );
      await user.reauthenticateWithCredential(cred);
      await user.updatePassword(newPassword);
      return true;
    } catch (e) {
      AppLogger.error('Failed to change password', error: e);
      return false;
    }
  }

  Future<void> signOut() => auth.signOut();

  Future<bool> updateProfileDetails({
    required String firstName,
    required String lastName,
    required String vehicleType,
    required String carName,
    required String carNumber,
    XFile? profileImage,
    XFile? vehicleImage,
  }) async {
    final currentUser = auth.user;
    final userId = auth.userId;
    if (currentUser == null || userId == null) return false;

    isUpdatingProfile.value = true;
    try {
      final profileUrl = profileImage == null
          ? currentUser.profilePictureURL
          : await _uploadDriverImage(
              userId: userId,
              image: profileImage,
              folder: 'profile',
            );
      final vehicleUrl = vehicleImage == null
          ? currentUser.carPictureURL
          : await _uploadDriverImage(
              userId: userId,
              image: vehicleImage,
              folder: 'vehicle',
            );

      final updatedUser = _copyUserWith(
        currentUser,
        firstName: firstName,
        lastName: lastName,
        vehicleType: vehicleType,
        carName: carName,
        carNumber: carNumber,
        profilePictureURL: profileUrl,
        carPictureURL: vehicleUrl,
      );

      final saved = await _userRepository.saveUser(updatedUser);
      if (!saved) return false;

      auth.updateUserLocally(updatedUser);
      return true;
    } catch (e) {
      AppLogger.error('updateProfileDetails failed', error: e);
      return false;
    } finally {
      isUpdatingProfile.value = false;
    }
  }

  Future<String> _uploadDriverImage({
    required String userId,
    required XFile image,
    required String folder,
  }) async {
    final extension = image.name.split('.').last.toLowerCase();
    final contentType = switch (extension) {
      'png' => 'image/png',
      'webp' => 'image/webp',
      _ => 'image/jpeg',
    };
    final ref = _storage.ref().child(
          'drivers/$userId/$folder/${DateTime.now().millisecondsSinceEpoch}_${image.name}',
        );

    await ref.putData(
      await image.readAsBytes(),
      SettableMetadata(contentType: contentType),
    );
    return ref.getDownloadURL();
  }

  UserModel _copyUserWith(
    UserModel user, {
    required String firstName,
    required String lastName,
    required String vehicleType,
    required String carName,
    required String carNumber,
    String? profilePictureURL,
    String? carPictureURL,
  }) {
    return UserModel(
      id: user.id,
      firstName: firstName,
      lastName: lastName,
      email: user.email,
      profilePictureURL: profilePictureURL,
      fcmToken: user.fcmToken,
      countryCode: user.countryCode,
      phoneNumber: user.phoneNumber,
      walletAmount: user.walletAmount,
      active: user.active,
      isActive: user.isActive,
      isDocumentVerify: user.isDocumentVerify,
      createdAt: user.createdAt,
      role: user.role,
      location: user.location,
      userBankDetails: user.userBankDetails,
      carName: carName,
      carNumber: carNumber,
      carPictureURL: carPictureURL,
      vehicleType: vehicleType,
      inProgressOrderID: user.inProgressOrderID,
      orderRequestData: user.orderRequestData,
      reviewsCount: user.reviewsCount,
      reviewsSum: user.reviewsSum,
      totalOrders: user.totalOrders,
      acceptedOrders: user.acceptedOrders,
      cancelledOrders: user.cancelledOrders,
      acceptanceRateValue: user.acceptanceRateValue,
      cancellationRateValue: user.cancellationRateValue,
      driverLicenseNumber: user.driverLicenseNumber,
      vehicleLicenseNumber: user.vehicleLicenseNumber,
    );
  }

  @override
  void onClose() {
    unawaited(_notificationsSub?.cancel());
    super.onClose();
  }
}
