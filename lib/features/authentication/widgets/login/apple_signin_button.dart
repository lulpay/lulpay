import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_oauth_apple/firebase_ui_oauth_apple.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../routing/router.gr.dart';
import '../../controllers/login_controller.dart';

class AppleSigninButton extends HookConsumerWidget {
  const AppleSigninButton({
    this.isTypeIcon = false,
    super.key,
  });

  final bool isTypeIcon;

  @override
  Widget build(BuildContext context, ref) {
    var isAuthenticating = useState(false);

    Future appleSignIn() async {
      if (isAuthenticating.value) return;

      isAuthenticating.value = true;

      try {
        final appleProvider = AppleAuthProvider()
          ..addScope('email')
          ..addScope('name');

        late UserCredential userCredential;

        if (kIsWeb) {
          userCredential =
              await FirebaseAuth.instance.signInWithPopup(appleProvider);
        } else {
          userCredential =
              await FirebaseAuth.instance.signInWithProvider(appleProvider);
        }

        await Get.find<LoginController>()
            .loginViaOAuth(userCredential.user!)
            .then(
          (userAuthenticated) {
            if (userAuthenticated) {
              context.router.replaceAll([const AuthenticatedRoutes()]);
            }
          },
        );

        // print(credential);
      } finally {
        isAuthenticating.value = false;
      }
    }

    if (isTypeIcon) {
      return AppleSignInIconButton(
        loadingIndicator: const CircularProgressIndicator.adaptive(
          backgroundColor: Colors.black,
        ),
        isLoading: isAuthenticating.value,
        onTap: appleSignIn,
        overrideDefaultTapAction: true,
      );
    }
    return AppleSignInButton(
      loadingIndicator: const CircularProgressIndicator.adaptive(
        backgroundColor: Colors.black,
      ),
      isLoading: isAuthenticating.value,
      onTap: appleSignIn,
      overrideDefaultTapAction: true,
    );
  }
}
