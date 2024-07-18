import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../constants/padding.dart';
import '../../../common/widgets/kabbee_button.dart';
import '../../../common/widgets/kabbee_snackbars.dart';
import '../../controllers/change_password_controller.dart';
import 'change_password_form.dart';

class ChangeButton extends GetView<ChangePasswordController> {
  const ChangeButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: xlPadding),
        child: Obx(
          () => KabbeeButton(
            label: 'change'.tr,
            onTap: () async {
              await controller.changePassword().then(
                (success) {
                  kabbeeSnackBar(
                    controller.serverMessage!,
                    isSuccessMsg: success,
                  );

                  if (success) {
                    ChangePasswordForm.formKey.currentState!.reset();
                    controller.enableChangeButton(false);
                  }
                },
              );
            },
            enabled: controller.enableChangeButton.isTrue &&
                controller.isAuthenticating.isFalse,
            hasProcess: true,
            isProcessing: controller.isAuthenticating.value,
          ),
        ),
      );
}
