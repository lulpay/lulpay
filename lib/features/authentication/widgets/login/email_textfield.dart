import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:get/get_utils/get_utils.dart';

import '../../../common/widgets/kabbee_textfield.dart';
import '../../controllers/login_controller.dart';

class EmailInputField extends GetView<LoginController> {
  const EmailInputField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: KpEmailField(
        label: 'email_address'.tr,
        hint: 'email_hint'.tr,
        initialValue: controller.email,
        handleChange: controller.setEmail,
      ),
    );
  }
}
