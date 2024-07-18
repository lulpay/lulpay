import 'package:get/get.dart';

import '../services/auth_service.dart';

class ResetConfirmationController extends GetxController {
  String? password;
  String? confirmPassword;
  final RxBool isProcessing = false.obs;
  final RxBool changeButtonEnabled = false.obs;
  final RxBool hidePassword = true.obs;

  String? resetToken;
  String? userId;
  String serverMessage = '';

  void setPassword(String value) => password = value.trim();

  void setConfirmPassword(String value) => confirmPassword = value;

  Future<bool> reset() async {
    isProcessing(true);
    serverMessage = '';
    try {
      await AuthServices.reset(userId ?? '', resetToken ?? '', password);

      serverMessage = 'password_changed_successfully'.tr;
      return true;
    } catch (e) {
      serverMessage = e.toString();
      return false;
    } finally {
      isProcessing.value = false;
    }
  }
}
