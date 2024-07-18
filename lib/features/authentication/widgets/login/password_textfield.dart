import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:get/get_utils/get_utils.dart';

import '../../../common/widgets/kabbee_textfield.dart';
import '../../controllers/login_controller.dart';

class PasswordInputField extends GetView<LoginController> {
  PasswordInputField({Key? key}) : super(key: key);

  final RxBool _hidePassword = true.obs;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Obx(
        () => KpPasswordField(
          hint: 'password_hint'.tr,
          label: 'password'.tr,
          validator: (String? password) {
            if (password == null || password.isEmpty) {
              return 'enter_valid_password'.tr;
            }
            return null;
          },
          hideText: _hidePassword,
          handleChange: controller.setPassword,
        ),
      ),
    );
  }
}
