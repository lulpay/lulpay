import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import '../../../core/extensions/theme_extension.dart';

import '../../../../routing/router.gr.dart';

class RegisterButton extends StatelessWidget {
  const RegisterButton({super.key});

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS && !kIsWeb) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: OutlinedButton(
        onPressed: () => context.navigateTo(
          RegistrationRouter(children: [RegisterEmailRoute()]),
        ),
        style: OutlinedButton.styleFrom(
          textStyle: context.appTextTheme.titleMedium,
          minimumSize: const Size(324, 45),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusDirectional.circular(8.0),
          ),
        ),
        child: Text('create_new_account'.tr),
      ),
    );
  }
}
