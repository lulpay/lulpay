
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routing/router.gr.dart';
import '../../common/widgets/kabbee_dialog.dart';
import '../../../theme/colors.dart';
import '../controllers/registration_controller.dart';

class LoginLink extends StatelessWidget {
  const LoginLink({
    Key? key,
    this.showWarning = true,
  }) : super(key: key);

  final bool showWarning;

  @override
  Widget build(BuildContext context) => Align(
        alignment: Alignment.topCenter,
        child: GestureDetector(
          onTap: () => regExitWarning(
            context: context,
            showWarning: showWarning,
          ),
          child: SizedBox(
            height: 48,
            child: RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: '${'have_account'.tr} ',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Theme.of(context).textTheme.displayLarge!.color),
                  ),
                  TextSpan(
                    text: 'login'.tr,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: PrimaryColorTones.mainColor,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}

Future regExitWarning({
  required BuildContext context,
  bool showWarning = true,
}) async {
  if (!showWarning ||
      (Get.find<RegistrationController>().initialized &&
          (Get.find<RegistrationController>().email?.isEmpty ?? true))) {
    context.replaceRoute(const LoginRoute());

    return;
  }

  showWarningDialog(
    context,
    title: 'quit_registration'.tr,
    mainMessage: 'are_you_sure_to_quit'.tr,
    onAffirm: () async => context.router
      ..popUntilRoot()
      ..navigate(const LoginRoute()),
  );
}
