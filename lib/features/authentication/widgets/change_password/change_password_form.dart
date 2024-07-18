import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../constants/padding.dart';
import '../../../common/widgets/responsive.dart';
import '../auth_screen_title.dart';
import 'change_button.dart';
import 'confirm_password.dart';
import 'new_password.dart';
import 'old_password_field.dart';

class ChangePasswordForm extends StatelessWidget {
  const ChangePasswordForm({Key? key}) : super(key: key);

  static final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  static bool shouldValidateGlobally = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
            mPadding, Responsive.isOnMobileView ? 128 : 72, 28, 0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              AuthScreenTitle(
                title: 'change_password'.tr,
                subTitle: 'enter_new_password'.tr,
              ),
              // old Password input field
              const OldPasswordField(),

              const NewPassword(),

              // Password input field
              const ConfirmPassword(),

              // change button
              const ChangeButton(),
            ],
          ),
        ),
      ),
    );
  }
}
