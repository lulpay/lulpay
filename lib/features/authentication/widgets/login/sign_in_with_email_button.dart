import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../core/extensions/theme_extension.dart';

import '../../providers/hide_email_field_provider.dart';

class ShowSignInWithEmail extends ConsumerWidget {
  const ShowSignInWithEmail({
    super.key,
  });

  @override
  Widget build(BuildContext context, ref) {
    var hideEmailField = ref.watch(hideEmailFieldProvider);

    if (!hideEmailField) return const SizedBox.shrink();

    return OutlinedButton(
      onPressed: () {
        ref.read(hideEmailFieldProvider.notifier).state = false;
      },
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(324, 45),
        textStyle: context.appTextTheme.titleMedium,
        foregroundColor: context.appColorScheme.onBackground,
      ),
      child: const Text('Sign in with Email'),
    );
  }
}

