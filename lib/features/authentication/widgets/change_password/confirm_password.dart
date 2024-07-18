import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/widgets/kabbee_textfield.dart';
import '../../controllers/change_password_controller.dart';
import 'change_password_form.dart';

class ConfirmPassword extends GetView<ChangePasswordController> {
  const ConfirmPassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 36),
        child: Obx(
          () => KpPasswordField(
              hideText: controller.hidePassword,
              label: 'confirm_password'.tr,
              hint: 'confirm_password_hint'.tr,
              validator: (cpassword) {
                String? usualValidation = passwordValidator(cpassword);
                if (usualValidation != null) {
                  return usualValidation;
                } else if (controller.password != controller.confirmPassword) {
                  return 'password_mismatched'.tr;
                }
                return null;
              },
              handleChange: (value) {
                controller.setConfirmPassword(value);
                controller.enableChangeButton(
                  ChangePasswordForm.formKey.currentState!.validate(),
                );
                ChangePasswordForm.shouldValidateGlobally = true;
              }),
        ),
      );
}
