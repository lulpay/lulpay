import 'package:flutter/material.dart';

import 'email_textfield.dart';
import 'forgot_pass_n_keep_me.dart';
import 'login_button_with_locker.dart';
import 'oauth2_circle_buttons.dart';
import 'password_textfield.dart';
import 'register_button.dart';

class EmailPasswordFields extends StatelessWidget {
  const EmailPasswordFields({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const EmailInputField(),

        PasswordInputField(),

        const KeepMeForgotButtons(),

        // log in buttons or lock timer
        const LoginButtonWithLocker(),

        const RegisterButton(),

        const OAuth2CircleButtons(),
      ],
    );
  }
}
