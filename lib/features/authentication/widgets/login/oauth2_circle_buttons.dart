import 'package:flutter/material.dart';

import 'apple_signin_button.dart';
import 'google_signin_button.dart';

class OAuth2CircleButtons extends StatelessWidget {
  const OAuth2CircleButtons({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 32),
      child: Wrap(
        children: const [
          GoogleSigninButton(isTypeIcon: true),
          SizedBox(width: 32),
          AppleSigninButton(isTypeIcon: true),
        ],
      ),
    );
  }
}
