import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../routing/router.gr.dart';
import '../../widgets/auth_form.dart';
import '../../../common/widgets/kabbee_button.dart';
import '../../controllers/registration_controller.dart';

import '../../../common/widgets/kabbee_textfield.dart';
import '../../../common/utility/utility_methods.dart';
import '../../widgets/registration_pages_wrapper.dart';

class RegisterNamePage extends StatelessWidget {
  const RegisterNamePage({Key? key}) : super(key: key);

  static final formKey = GlobalKey<FormState>();

  static final RxBool enableNext = false.obs;
  static bool shouldValidateGlobally = false;

  @override
  Widget build(BuildContext context) => RegistrationPagesWrapper(
        authForm: AuthForm(
          formKey: formKey,
          title: 'create_account'.tr,
          subtitle: 'tell_us_more'.tr,
          formComponents: const [
            FirstNameField(),

            SizedBox(height: 16),

            // Last name
            LastNameField(),

            SizedBox(height: 36),

            //next button
            NextButton(),
          ],
        ),
      );
}

class FirstNameField extends GetView<RegistrationController> {
  const FirstNameField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return KabbeeTextField(
      initialValue: controller.firstName,
      label: 'first_name'.tr,
      hint: 'enter_first_name'.tr,
      validator: (name) => nameValidator(name, nameType: 'first_name'),
      suffixWidget: const Icon(
        Icons.perm_identity_outlined,
        size: 18,
      ),
      handleChange: (value) {
        controller.setFirstName(value);
        if (RegisterNamePage.shouldValidateGlobally) {
          RegisterNamePage.enableNext(
              RegisterNamePage.formKey.currentState!.validate());
        }
      },
    );
  }
}

class LastNameField extends GetView<RegistrationController> {
  const LastNameField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // enable next button if the fields were already filled by user and are valid
    // this happens when user requested info, but had to return to previous pages,
    // and upon coming back to this page, since all fields might be given, the action button has to be enabled
    if (controller.lastName != null && controller.lastName!.isNotEmpty) {
      1.delay().then((value) => RegisterNamePage.enableNext(
          RegisterNamePage.formKey.currentState!.validate()));
    }

    return KabbeeTextField(
      initialValue: controller.lastName,
      label: 'last_name'.tr,
      hint: 'enter_last_name'.tr,
      suffixWidget: const Icon(
        Icons.perm_identity,
        size: 18,
      ),
      validator: (name) => nameValidator(name, nameType: 'last_name'),
      handleChange: (value) {
        controller.setLastName(value);
        RegisterNamePage.enableNext(
            RegisterNamePage.formKey.currentState!.validate());

        RegisterNamePage.shouldValidateGlobally = true;
      },
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
          onTap: () => context.pushRoute(const RegisterGenderCountryRoute()),
          label: 'next'.tr,
          enabled: RegisterNamePage.enableNext.value,
        ),
      ),
    );
  }
}
