import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/widgets/kabbee_textfield.dart';
import '../../controllers/change_password_controller.dart';
import 'change_password_form.dart';

class NewPassword extends GetView<ChangePasswordController> {
  const NewPassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 12.0),
        child: Obx(
          () => KpPasswordField(
              hideText: controller.hidePassword,
              label: 'new_password'.tr,
              hint: 'enter_new_password_hint'.tr,
              handleChange: (value) {
                controller.setPassword(value);
                if (ChangePasswordForm.shouldValidateGlobally) {
                  controller.enableChangeButton(
                      ChangePasswordForm.formKey.currentState!.validate());
                }
              }),
        ),
      );
}
