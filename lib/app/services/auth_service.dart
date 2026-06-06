import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver/app/data/models/user_model.dart';
import 'package:driver/core/constants/collection_names.dart';
import 'package:driver/core/utils/app_logger.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

/// خدمة المصادقة وإدارة جلسة المندوب
/// GetxService = يعيش طوال عمر التطبيق
class AuthService extends GetxService {
  static AuthService get to => Get.find();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  final Completer<void> _initialAuthCompleter = Completer<void>();
  final Rxn<UserModel> _user = Rxn<UserModel>();

  // ── Public Getters ────────────────────────────────────────
  UserModel? get user => _user.value;
  bool get isAuthenticated => _user.value != null;
  String? get userId => _user.value?.id;
  Future<void> get initialAuthReady => _initialAuthCompleter.future;

  // ── Lifecycle ─────────────────────────────────────────────
  @override
  void onInit() {
    super.onInit();
    // الاستماع لتغييرات حالة المصادقة
    _auth.authStateChanges().listen(_onAuthStateChanged);
  }

  Future<void> _onAuthStateChanged(User? firebaseUser) async {
    try {
      if (firebaseUser == null) {
        _user.value = null;
        AppLogger.info('User signed out');
        return;
      }

      final profile = await _fetchUserProfile(firebaseUser.uid);
      _user.value = profile;
      AppLogger.info('User loaded: ${profile?.fullName}');
    } catch (e) {
      AppLogger.error('Failed to load user profile', error: e);
      _user.value = null;
    } finally {
      if (!_initialAuthCompleter.isCompleted) {
        _initialAuthCompleter.complete();
      }
    }
  }

  Future<void> waitForInitialAuthState({
    Duration timeout = const Duration(seconds: 5),
  }) async {
    await initialAuthReady.timeout(
      timeout,
      onTimeout: () {
        AppLogger.warning('Initial auth state timed out');
      },
    );
  }

  Future<UserModel?> _fetchUserProfile(String uid) async {
    final doc = await _db
        .collection(CollectionNames.users)
        .doc(uid)
        .get()
        .timeout(const Duration(seconds: 12));
    if (doc.exists && doc.data() != null) {
      return UserModel.fromJson({'id': doc.id, ...doc.data()!});
    }
    return null;
  }

  Future<UserModel?> refreshCurrentUser() async {
    final firebaseUser = _auth.currentUser;
    if (firebaseUser == null) {
      _user.value = null;
      return null;
    }

    final profile = await _fetchUserProfile(firebaseUser.uid);
    _user.value = profile;
    return profile;
  }

  // ── Online Status ─────────────────────────────────────────

  /// تحديث حالة الاتصال (Online/Offline)
  Future<void> setOnlineStatus(bool isOnline) async {
    if (userId == null) return;
    try {
      await _db.collection(CollectionNames.users).doc(userId).update({
        'active': isOnline,
        'isActive': isOnline,
      });
      if (_user.value != null) {
        _user.value!.active = isOnline;
        _user.refresh();
      }
      AppLogger.info('Driver status: ${isOnline ? "Online" : "Offline"}');
    } catch (e) {
      AppLogger.error('setOnlineStatus failed', error: e);
    }
  }

  // ── Token ─────────────────────────────────────────────────

  /// تحديث FCM Token
  Future<void> updateFcmToken(String token) async {
    if (userId == null) return;
    try {
      await _db.collection(CollectionNames.users).doc(userId).update({
        'fcmToken': token,
      });
    } catch (e) {
      AppLogger.error('updateFcmToken failed', error: e);
    }
  }

  // ── Local Update ──────────────────────────────────────────

  /// تحديث بيانات المستخدم محلياً (بعد تعديل الملف الشخصي)
  void updateUserLocally(UserModel updatedUser) {
    _user.value = updatedUser;
  }

  // ── Sign Out ──────────────────────────────────────────────
  Future<void> signOut() async {
    try {
      await setOnlineStatus(false);
      await _auth.signOut();
      _user.value = null;
    } catch (e) {
      AppLogger.error('signOut failed', error: e);
    }
  }
}
