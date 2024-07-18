import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kabbeeplus/features/common/widgets/kabbee_text.dart';
import 'package:kabbeeplus/features/core/extensions/spacing_extention.dart';
import 'package:kabbeeplus/features/core/extensions/theme_extension.dart';
import '../../providers/hide_email_field_provider.dart';

import 'apple_signin_button.dart';
import 'email_password_fields.dart';
import 'google_signin_button.dart';
import 'sign_in_with_email_button.dart';
import 'signing_help_modal.dart';

class DefaultAuthOptions extends ConsumerWidget {
  const DefaultAuthOptions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    var hideEmailField = ref.watch(hideEmailFieldProvider);

    if (!hideEmailField) return const EmailPasswordFields();

    return Container(
      constraints: const BoxConstraints(maxWidth: 324),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const GoogleSigninButton(),
          const SizedBox(height: 4),
          const AppleSigninButton(),
          const Or(),
          const ShowSignInWithEmail(),
          16.vertSpacing,
          const NeedHelpButton()
        ],
      ),
    );
  }
}

class Or extends StatelessWidget {
  const Or({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: KabbeeText.subtitle2('Or'),
    );
  }
}

class NeedHelpButton extends StatelessWidget {
  const NeedHelpButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          enableDrag: true,
          isDismissible: true,
          constraints: const BoxConstraints(maxWidth: 650),
          isScrollControlled: true,
          builder: (context) => const SigningHelpModal(),
        );
      },
      style: TextButton.styleFrom(
        foregroundColor: context.appColorScheme.onBackground,
      ),
      child: const Text('I need help signing in'),
    );
  }
}
