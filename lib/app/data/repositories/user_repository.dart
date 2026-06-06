import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver/app/data/models/user_model.dart';
import 'package:driver/core/constants/collection_names.dart';
import 'package:driver/core/utils/app_logger.dart';

class UserRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<UserModel?> getUser(String uid) async {
    final doc = await _db
        .collection(CollectionNames.users)
        .doc(uid)
        .get()
        .timeout(const Duration(seconds: 12));
    if (!doc.exists || doc.data() == null) return null;

    return UserModel.fromJson({'id': doc.id, ...doc.data()!});
  }

  Future<bool> saveUser(UserModel user) async {
    if (user.id == null || user.id!.isEmpty) return false;

    try {
      await _db
          .collection(CollectionNames.users)
          .doc(user.id)
          .set(user.toJson(), SetOptions(merge: true))
          .timeout(const Duration(seconds: 12));
      return true;
    } catch (e) {
      AppLogger.error('saveUser failed', error: e);
      return false;
    }
  }
}
