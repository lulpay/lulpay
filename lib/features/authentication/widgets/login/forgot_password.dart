import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';

import '../../../../routing/router.gr.dart';
import '../../../common/widgets/kabbee_text.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => TextButton(
        onPressed: () => context.navigateTo(
          ResetRouter(
            children: [PasswordResetRequestRoute()],
          ),
        ),
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          textStyle: const TextStyle(fontWeight: FontWeight.w500),
        ),
        child: KabbeeText('forgot_password'.tr),
      );
}
