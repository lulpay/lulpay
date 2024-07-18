import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../routing/router.gr.dart';

import '../../../common/widgets/kabbee_button.dart';
import '../../widgets/auth_form.dart';
import '../../widgets/auth_screens_wrapper.dart';

class PasswordResetRequestConfirmationPage extends StatelessWidget {
  const PasswordResetRequestConfirmationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AuthScreenWrapper(
      authForm: AuthForm(
        title: 'reset_password'.tr,
        subtitle: 'reset_done_msg'.tr,
        formComponents: const [
          SizedBox(height: 48),
          ReturnToLogin(),
        ],
        // registration link
        // formFooter: const RegisterLink(),
      ),
    );
  }
}

class ReturnToLogin extends StatelessWidget {
  const ReturnToLogin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return KabbeeButton(
      label: 'return_to_login'.tr,
      onTap: () => context.router.root.navigate(const LoginRoute()),
    );
  }
}
