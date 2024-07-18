import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../widgets/registration_pages_wrapper.dart';
import '../../widgets/auth_form.dart';
import '../../../../routing/router.gr.dart';
import '../../../common/widgets/kabbee_button.dart';
import '../../../common/widgets/kabbee_textfield.dart';

import '../../controllers/registration_controller.dart';

class RegisterPasswordPage extends StatelessWidget {
  const RegisterPasswordPage({Key? key}) : super(key: key);

  static final formKey = GlobalKey<FormState>();

  static final RxBool enableNext = false.obs;

  static bool shouldValidateGlobally = false;

  @override
  Widget build(BuildContext context) => RegistrationPagesWrapper(
        authForm: AuthForm(
          formKey: formKey,
          title: 'create_account'.tr,
          subtitle: 'enter_your_password'.tr,
          formComponents: const [
            //Password
            PasswordField(),

            SizedBox(height: 16),

            // confirm password
            ConfirmPassword(),

            SizedBox(height: 36),

            //next button
            NextButton(),
          ],
        ),
      );
}

class PasswordField extends GetView<RegistrationController> {
  const PasswordField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => KpPasswordField(
        initialValue: controller.password,
        hint: 'password_hint'.tr,
        label: 'password'.tr,
        hideText: controller.hidePassword,
        handleChange: (value) {
          controller.setPassword(value);
          if (RegisterPasswordPage.shouldValidateGlobally) {
            RegisterPasswordPage.enableNext(
                RegisterPasswordPage.formKey.currentState!.validate());
          }
        },
      ),
    );
  }
}

class ConfirmPassword extends GetView<RegistrationController> {
  const ConfirmPassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // enable next button if the fields were already filled by user and are valid
    // this happens when user requested info, but had to return to previous pages,
    // and upon coming back to this page, since all fields might be given, the action button has to be enabled
    if (controller.confirmPassword != null &&
        controller.confirmPassword!.isNotEmpty) {
      1.delay().then((value) => RegisterPasswordPage.enableNext(
          RegisterPasswordPage.formKey.currentState!.validate()));
    }

    return Obx(
      () => KpPasswordField(
        initialValue: controller.confirmPassword,
        hint: 'password_hint'.tr,
        label: 'confirm_password'.tr,
        hideText: controller.hidePassword,
        validator: (cpassword) {
          String? usualValidation = passwordValidator(cpassword);
          if (usualValidation != null) {
            return usualValidation;
          } else if (controller.password != cpassword) {
            return 'password_mismatched'.tr;
          }
          return null;
        },
        handleChange: (value) {
          controller.setConfirmPassword(value);
          RegisterPasswordPage.enableNext(
              RegisterPasswordPage.formKey.currentState!.validate());

          RegisterPasswordPage.shouldValidateGlobally = true;
        },
      ),
    );
  }
}

class NextButton extends StatelessWidget {
  const NextButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Obx(
        () => KabbeeButton(
          onTap: () => context.navigateTo(const RegisterNameRoute()),
          label: 'next'.tr,
          enabled: RegisterPasswordPage.enableNext.value,
        ),
      ),
    );
  }
}
