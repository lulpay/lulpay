import 'package:get/get.dart';

import '../services/auth_service.dart';
import '../../common/services/db_access.dart';

class ChangePasswordController extends GetxController {
  String? storedOldPassword;
  String? oldPassword;
  String? password;
  String? confirmPassword;

  final RxBool hidePassword = true.obs;
  final RxBool enableChangeButton = false.obs;

  RxBool isAuthenticating = false.obs;
  String? serverMessage = '';

  Map<String, dynamic>? decodedToken;
  String resetToken = '';
  String userId = '';

  RxBool checkLoginStatus = false.obs;

  @override
  void onInit() async {
    storedOldPassword = DbAccess.readData('user_password');
    super.onInit();
  }

  /// Sets old password field

  void setOldPassword(String value) => oldPassword = value;

  /// Sets password field

  void setPassword(String value) => password = value;

  /// Sets password confirmation field
  void setConfirmPassword(String value) => confirmPassword = value;

  Future<bool> changePassword() async {
    isAuthenticating(true);
    serverMessage = '';
    try {
      await AuthServices().changePassword(
        oldPassword,
        password,
      );
      serverMessage = 'password_changed_successfully'.tr;

      DbAccess.userDB.put('user_password', password);
      storedOldPassword = password;

      serverMessage = 'successfully_update'.tr;

      return true;
    } catch (e) {
      serverMessage = e.toString();
    } finally {
      isAuthenticating.value = false;
    }
    return false;
  }
}
