import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:kabbeeplus/features/core/extensions/spacing_extention.dart';
import 'package:kabbeeplus/features/core/extensions/theme_extension.dart';

import '../../../../constants/padding.dart';
import '../../../common/widgets/kabbee_text.dart';

class SigningHelpModal extends StatelessWidget {
  const SigningHelpModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var instructions = [
      'Please create an account before attempting to login, if you don’t have one.',
      'Please use Gmail or Apple id account to login.',
      'If you need help using Gmail or Apple id, please refer to their support pages'
    ];
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: xsPadding),
        child: Container(
          padding: const EdgeInsets.all(sPadding),
          decoration: BoxDecoration(
            color: context.appColorScheme.background,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: context.appColorScheme.surface,
            ),
          ),
          child: Wrap(
            children: [
              const KabbeeText.headline6('Can\'t login?'),
              32.vertSpacing,
              for (final instruction in instructions)
                ListTile(
                  leading: const KabbeeText('˚'),
                  title: KabbeeText(instruction),
                  minLeadingWidth: 0,
                  contentPadding: EdgeInsets.zero,
                ),
              Container(
                width: double.maxFinite,
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    context.popRoute();
                  },
                  child: Text('cancel'.tr),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
