import 'package:get/get.dart';

import '../services/auth_service.dart';

class ResetPasswordController extends GetxController {
  String? email;
  String serverMessage = '';
  RxBool isProcessing = false.obs;

  void setEmail(String valueText) => email = valueText.trim().toLowerCase();

  Future<bool> sendEmailForPasswordReset() async {
    isProcessing(true);

    try {
      // Calling auth service
      await AuthServices.resetPassword(email);
      // log('Back');

      serverMessage = 'password_reset_sent'.tr;

      return true;
    } catch (e, s) {
      serverMessage = e.toString();
      printError(info: 'Reset err: $s');
      return false;
    } finally {
      isProcessing(false);
    }
  }
}
