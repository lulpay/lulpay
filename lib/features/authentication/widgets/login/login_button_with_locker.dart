import 'package:auto_route/auto_route.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/widgets/kabbee_text.dart';
import '../../../../constants/padding.dart';
import '../../../common/controllers/global_controller.dart';

import '../../../../routing/router.gr.dart';
import '../../../../theme/colors_utility.dart';
import '../../../common/widgets/kabbee_button.dart';
import '../../controllers/login_controller.dart';

class LoginButtonWithLocker extends GetView<LoginController> {
  const LoginButtonWithLocker({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Visibility(
        replacement: CountdownTimer(
          durationInSec: controller.lockDuration,
        ),
        visible: controller.lockAccount.isFalse,
        child: const LoginButton(),
      ),
    );
  }
}

class LoginButton extends GetView<LoginController> {
  const LoginButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => KabbeeButton(
        onTap: () async {
          await controller.loginWithEmailPassword().then(
            (result) {
              if (result.keys.first) {
                context.router.replaceAll([const AuthenticatedRoutes()]);
              } else if (result.values.first > 2) {
                // close snack bar if it is open
                Get.find<GlobalController>()
                    .globalScaffoldKey
                    .currentState
                    ?.clearSnackBars();

                showModalBottomSheet(
                  context: context,
                  enableDrag: true,
                  isDismissible: true,
                  isScrollControlled: true,
                  constraints: const BoxConstraints(maxWidth: 650),
                  builder: (context) => SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(
                          xsPadding, 0, xsPadding, xsPadding),
                      child: Ink(
                        padding: const EdgeInsets.all(sPadding),
                        decoration: BoxDecoration(
                          color: backgroundColor(context),
                          borderRadius: BorderRadius.circular(borderRadius),
                          border: Border.all(
                            color: surfaceColor(context),
                          ),
                        ),
                        child: Wrap(
                          children: [
                            KabbeeText.bodyMedium(
                              'Dear User,',
                              customStyle:
                                  TextStyle(color: onBackground(context)),
                            ),
                            KabbeeText.bodyMedium(
                                '\nYou are not registered as ${controller.email}, in order to use kabbee+ click continue button to register, or correct your email address.'),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: () => context.router.pop(),
                                    child: Text('cancel'.tr,
                                        style: TextStyle(
                                            color: onBackground(context)),
                                        textAlign: TextAlign.end),
                                  ),
                                  KabbeeButton(
                                      width: 145,
                                      label: 'continue'.tr,
                                      onTap: (() => context.replaceRoute(
                                            RegistrationRouter(
                                              children: [
                                                RegisterEmailRoute(
                                                    email: controller.email),
                                              ],
                                            ),
                                          )))
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }
            },
          );
        },
        label: 'login'.tr,
        enabled: controller.enableLoginButton.isTrue &&
            controller.isAuthenticating.isFalse,
        hasProcess: true,
        isProcessing: controller.isAuthenticating.value,
        width: 324.0,
      ),
    );
  }
}

class CountdownTimer extends GetView<LoginController> {
  const CountdownTimer({
    Key? key,
    required this.durationInSec,
  }) : super(key: key);

  final int? durationInSec;

  @override
  Widget build(BuildContext context) {
    return CircularCountDownTimer(
      // lock down duration in seconds
      duration: durationInSec ?? 900,

      width: 45,
      height: 45,
      ringColor: secondaryColor(context),
      fillColor: primaryColor(context),
      backgroundColor: Theme.of(context).colorScheme.background,
      strokeWidth: 5.0,
      strokeCap: StrokeCap.butt,
      textStyle: Theme.of(context)
          .textTheme
          .titleSmall!
          .copyWith(fontWeight: FontWeight.bold),
      textFormat: CountdownTextFormat.MM_SS,
      isReverse: true,
      onStart: () => controller.lockAccount(true),
      onComplete: () => controller.lockAccount(false),
    );
  }
}
