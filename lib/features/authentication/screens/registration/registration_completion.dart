import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/widgets/kabbee_text.dart';
import '../../widgets/auth_form.dart';
import '../../widgets/auth_screens_wrapper.dart';

class RegistrationCompletePage extends StatelessWidget {
  const RegistrationCompletePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => AuthScreenWrapper(
        authForm: AuthForm(
          title: 'registration_done'.tr,
          formComponents: [
            KabbeeText.headline6(
              'registration_done_message'.tr,
            )
          ],
        ),
      );
}
