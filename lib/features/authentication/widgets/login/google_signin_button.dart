import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../common/utility/debug_log.dart';
import '../../controllers/login_controller.dart';
import '../../providers/google_client_id_provider.dart';

import '../../../../routing/router.gr.dart';

class GoogleSigninButton extends HookConsumerWidget {
  const GoogleSigninButton({
    this.isTypeIcon = false,
    super.key,
  });

  final bool isTypeIcon;

  @override
  Widget build(BuildContext context, ref) {
    var googleClientId = ref.watch(googleClientIdProvider);

    var isAuthenticating = useState(false);

    Future googleSignIn() async {
      if (isAuthenticating.value) return;

      isAuthenticating.value = true;
      try {
        final googleUser = await GoogleSignIn.standard().signIn();
        if (googleUser == null) {
          throw Exception('Sign in with Google canceled');
        }
        final googleAuth = await googleUser.authentication;

        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        var userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);

        await Get.find<LoginController>()
            .loginViaOAuth(userCredential.user!)
            .then(
          (userAuthenticated) {
            if (userAuthenticated) {
              context.router.replaceAll([const AuthenticatedRoutes()]);
            }
          },
        );
      } catch (e, s) {
        safeLog('$e, $s');
      } finally {
        isAuthenticating.value = false;
      }
    }

    return googleClientId.when(
      data: (clientId) {
        if (isTypeIcon) {
          return GoogleSignInIconButton(
            clientId: clientId,
            isLoading: isAuthenticating.value,
            loadingIndicator: const CircularProgressIndicator.adaptive(
              backgroundColor: Colors.black,
            ),
            overrideDefaultTapAction: true,
            action: AuthAction.signIn,
            onTap: googleSignIn,
          );
        }

        return GoogleSignInButton(
          clientId: clientId,
          isLoading: isAuthenticating.value,
          loadingIndicator: const CircularProgressIndicator.adaptive(
            backgroundColor: Colors.black,
          ),
          overrideDefaultTapAction: true,
          action: AuthAction.signIn,
          onTap: googleSignIn,
        );
      },
      loading: () {
        return const SizedBox.shrink();
      },
      error: (_, __) {
        return const SizedBox.shrink();
      },
    );
  }
}
