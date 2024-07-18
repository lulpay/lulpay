import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routing/router.gr.dart';
import '../controllers/registration_controller.dart';
import 'auth_screens_wrapper.dart';

class RegistrationPagesWrapper extends GetView<RegistrationController> {
  const RegistrationPagesWrapper({Key? key, required this.authForm})
      : super(key: key);

  final Widget authForm;
  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<RegistrationController>()) {
      context.router.replaceAll([RegisterEmailRoute()]);
    }

    return AuthScreenWrapper(
      authForm: authForm,
    );
  }
}
