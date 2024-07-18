
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../routing/router.gr.dart';

import '../../../common/widgets/kabbee_button.dart';
import '../../../common/widgets/kabbee_textfield.dart';
import '../../../common/widgets/kabbee_snackbars.dart';
import '../../controllers/reset_confirmation_controller.dart';
import '../../widgets/auth_form.dart';
import '../../widgets/auth_screens_wrapper.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({Key? key, required this.arguments})
      : super(key: key);
  final Map<String, String> arguments;

  static final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  static bool shouldValidateGlobally = false;

  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final controller = Get.put(ResetConfirmationController());

  @override
  void initState() {
    super.initState();

    // setting reset token and user ID values from argument
    controller.resetToken = widget.arguments['token'];

    controller.userId = widget.arguments['id'];
    // log('token == ${controller.resetToken}');

    // log('id =${controller.userId}');
  }

  @override
  Widget build(BuildContext context) {
    return AuthScreenWrapper(
      authForm: AuthForm(
        formKey: ResetPasswordPage.formKey,
        title: 'reset_password'.tr,
        subtitle: 'enter_new_password'.tr,
        formComponents: const [
          // New Password input field
          NewPasswordField(),

          // Confirm password input field
          ConfirmPasswordField(),

          // change password buttons
          ChangeButton(),
        ],
      ),
    );
  }
}

class NewPasswordField extends GetView<ResetConfirmationController> {
  const NewPasswordField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 12.0),
        child: Obx(
          () => KpPasswordField(
            hideText: controller.hidePassword,
            label: 'password'.tr,
            hint: 'enter new password here',
            handleChange: (value) {
              controller.setPassword(value);

              if (ResetPasswordPage.shouldValidateGlobally) {
                controller.changeButtonEnabled(
                    ResetPasswordPage.formKey.currentState!.validate());
              }
            },
          ),
        ),
      );
}

class ConfirmPasswordField extends GetView<ResetConfirmationController> {
  const ConfirmPasswordField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 36.0),
        child: Obx(
          () => KpPasswordField(
            hideText: controller.hidePassword,
            label: 'confirm_password'.tr,
            hint: 'confirm_password_hint'.tr,
            validator: (cpassword) {
              String? lenIssue = passwordValidator(cpassword);
              if (lenIssue != null) {
                return lenIssue;
              } else if (controller.password != cpassword) {
                return 'password_mismatched'.tr;
              }
              return null;
            },
            handleChange: (value) {
              controller.setConfirmPassword(value);
              controller.changeButtonEnabled(
                  ResetPasswordPage.formKey.currentState!.validate());
              ResetPasswordPage.shouldValidateGlobally = true;
            },
          ),
        ),
      );
}

class ChangeButton extends GetView<ResetConfirmationController> {
  const ChangeButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Obx(
        () => KabbeeButton(
          label: 'change_password'.tr,
          onTap: () => changePassword(context),
          enabled: controller.changeButtonEnabled.isTrue &&
              controller.isProcessing.isFalse,
          hasProcess: true,
          isProcessing: controller.isProcessing.value,
        ),
      );

  Future changePassword(BuildContext context) async {
    bool success = await controller.reset();

    kabbeeSnackBar(
      controller.serverMessage,
      isSuccessMsg: success,
    );

    // if password changed successfully, navigate to login page
    if (success) {
      ResetPasswordPage.formKey.currentState?.reset();
      controller.changeButtonEnabled(false);
      3.delay().then((_) => context.navigateTo(const LoginRoute()));
    }
  }
}
