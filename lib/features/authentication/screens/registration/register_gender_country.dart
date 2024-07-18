import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/widgets/kabbee_snackbars.dart';
import '../../widgets/geo_locator_field.dart';
import '../../widgets/auth_form.dart';
import '../../widgets/gender_selector.dart';
import '../../../common/widgets/kabbee_button.dart';
import '../../../../routing/router.gr.dart';
import '../../controllers/registration_controller.dart';
import '../../widgets/registration_pages_wrapper.dart';

class RegisterGenderCountryPage extends GetView<RegistrationController> {
  const RegisterGenderCountryPage({Key? key}) : super(key: key);

  static final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) => RegistrationPagesWrapper(
        authForm: AuthForm(
          formKey: formKey,
          title: 'create_account'.tr,
          subtitle: 'tell_us_more'.tr,
          formComponents: [
            //Gender
            GenderSelector(
              initialGenderIndex: controller.genderIndex.value,
              onGenderSelected: (int index) {
                controller.setGender(index);
              },
            ),
            const SizedBox(
              height: 20,
            ),

            const CountryField(),

            const SizedBox(height: 36),

            const RegisterButton(),
          ],
        ),
      );
}

class CountryField extends GetView<RegistrationController> {
  const CountryField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GeolocatorField(
      onAddressDetermined: (country) {
        controller.setCountry(country);
        controller.enableRegisterButton(
            RegisterGenderCountryPage.formKey.currentState!.validate());
      },
      initialValue: controller.country ?? 'country'.tr,
    );
  }
}

class RegisterButton extends GetView<RegistrationController> {
  const RegisterButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Obx(
        () => KabbeeButton(
          label: 'create_account'.tr,
          onTap: () async => await handleReg(context),
          enabled: controller.enableRegisterButton.isTrue &&
              controller.isProcessing.isFalse,
          hasProcess: true,
          isProcessing: controller.isProcessing.value,
        ),
      ),
    );
  }

  Future handleReg(BuildContext context) async {
    bool userRegistered = await controller.registerUser();

    if (userRegistered) {
      context.router.root
        ..popUntilRoot()
        ..navigate(const RegistrationCompleteRoute());
    } else {
      kabbeeSnackBar(
        controller.serverMessage,
        isSuccessMsg: userRegistered,
      );
    }
  }
}
