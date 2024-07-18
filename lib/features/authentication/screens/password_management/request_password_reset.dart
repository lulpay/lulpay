import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/reset_password_controller.dart';
import '../../../common/widgets/kabbee_button.dart';
import '../../../common/widgets/kabbee_textfield.dart';
import '../../../common/widgets/kabbee_snackbars.dart';
import '../../../../routing/router.gr.dart';
import '../../widgets/auth_form.dart';
import '../../widgets/auth_screens_wrapper.dart';

class PasswordResetRequestPage extends StatelessWidget {
  PasswordResetRequestPage({Key? key}) : super(key: key);

  final _resetController = Get.put(ResetPasswordController());

  final _formKey = GlobalKey<FormState>();
  final _resetButtonEnabled = false.obs;

  @override
  Widget build(BuildContext context) {
    return AuthScreenWrapper(
      authForm: AuthForm(
        title: 'reset_password'.tr,
        subtitle: 'reset_msg'.tr,
        formKey: _formKey,
        formComponents: [
          // Email input field
          KpEmailField(
            label: 'email_address'.tr,
            hint: 'email_hint'.tr,
            handleChange: (value) {
              _resetController.setEmail(value);
              _resetButtonEnabled(_formKey.currentState!.validate());
            },
          ),

          const SizedBox(height: 36),

          ResetButton(isButtonEnabled: _resetButtonEnabled),
        ],
        // formFooter: const LoginLink(showWarning: false),
      ),
    );
  }
}

class ResetButton extends StatelessWidget {
  ResetButton({
    Key? key,
    required RxBool isButtonEnabled,
  })  : _isButtonEnabled = isButtonEnabled,
        super(key: key);

  final ResetPasswordController _resetController = Get.find();
  final RxBool _isButtonEnabled;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => KabbeeButton(
        height: 55,
        width: 230,
        label: 'reset'.tr,
        onTap: () async => await handleReset(context),
        enabled:
            _isButtonEnabled.isTrue && _resetController.isProcessing.isFalse,
        hasProcess: true,
        isProcessing: _resetController.isProcessing.value,
      ),
    );
  }

  Future handleReset(BuildContext context) async {
    await _resetController.sendEmailForPasswordReset().then((hasSendEmail) {
      // log('$hasSendEmail');
      if (hasSendEmail) {
        context.pushRoute(const PasswordResetRequestConfirmationRoute());
      } else {
        kabbeeSnackBar(
          _resetController.serverMessage,
          isSuccessMsg: false,
        );
      }
    });
  }
}
