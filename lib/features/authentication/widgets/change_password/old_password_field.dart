import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/widgets/kabbee_textfield.dart';
import '../../controllers/change_password_controller.dart';
import 'change_password_form.dart';

class OldPasswordField extends GetView<ChangePasswordController> {
  const OldPasswordField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 12.0),
        child: Obx(
          () => KpPasswordField(
              hideText: controller.hidePassword,
              label: 'old_password'.tr,
              hint: 'enter_old_password'.tr,
              validator: (cpassword) {
                String? usualValidation = passwordValidator(cpassword);
                if (usualValidation != null) {
                  return usualValidation;
                } else if (controller.storedOldPassword !=
                    controller.oldPassword) {
                  return 'incorrect_password'.tr;
                }
                return null;
              },
              handleChange: (value) {
                controller.setOldPassword(value);

                if (ChangePasswordForm.shouldValidateGlobally) {
                  controller.enableChangeButton(
                      ChangePasswordForm.formKey.currentState!.validate());
                }
              }),
        ),
      );
}
