import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../constants/padding.dart';
import '../../controllers/login_controller.dart';
import 'forgot_password.dart';
import 'keepme_logged_in.dart';

class KeepMeForgotButtons extends GetView<LoginController> {
  const KeepMeForgotButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Align(
        alignment: Alignment.centerLeft,
        child: Container(
          width: context.width,
          margin: const EdgeInsets.only(bottom: nPadding, left: 4),
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            runAlignment: WrapAlignment.end,
            crossAxisAlignment: WrapCrossAlignment.center,
            // vertical spacing
            runSpacing: xsPadding,
            children: const [
              KeepMeLogged(),
              ForgotPassword(),
            ],
          ),
        ),
      );
}
