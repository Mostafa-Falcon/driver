import 'package:driver/app/services/auth_service.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  final AuthService auth = AuthService.to;

  Future<void> signOut() => auth.signOut();
}
