import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:showcaseview/showcaseview.dart';
import '../../providers/already_registered_emails_provider.dart';

import '../../../../routing/router.gr.dart';
import '../../../common/controllers/global_controller.dart';
import '../../../common/widgets/kabbee_button.dart';
import '../../../common/widgets/kabbee_textfield.dart';
import '../../controllers/registration_controller.dart';
import '../../widgets/auth_form.dart';
import '../../widgets/login_link.dart';
import '../../widgets/registration_pages_wrapper.dart';

class RegisterEmailPage extends StatefulWidget {
  const RegisterEmailPage({
    Key? key,
    this.email,
  }) : super(key: key);

  final String? email;

  @override
  State<RegisterEmailPage> createState() => _RegisterEmailPageState();
}

class _RegisterEmailPageState extends State<RegisterEmailPage> {
  static final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  static final RxBool enableNext = false.obs;

  @override
  void initState() {
    super.initState();
    Get.put(RegistrationController());
  }

  @override
  Widget build(BuildContext context) {
    Get.find<GlobalController>().globalContext = context;

    return ShowCaseWidget(
      enableAutoScroll: true,
      disableBarrierInteraction: true,
      builder: Builder(
        builder: (_) {
          return WillPopScope(
            onWillPop: () async {
              if (Get.find<RegistrationController>().email?.isEmpty ?? true) {
                return true;
              }
              await regExitWarning(context: context);

              return false;
            },
            child: RegistrationPagesWrapper(
              authForm: AuthForm(
                formKey: _RegisterEmailPageState.formKey,
                title: 'create_account'.tr,
                subtitle: 'enter_your_email'.tr,
                formComponents: [
                  EmailInputField(redirectedEmail: widget.email),
                  const SizedBox(height: 104),
                  NextButton(),
                ],
                // formFooter: RegistrationToolTip(
                //   email: widget.email,
                // ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class EmailInputField extends ConsumerWidget {
  EmailInputField({
    Key? key,
    this.redirectedEmail,
  }) : super(key: key);

  final String? redirectedEmail;

  final controller = Get.find<RegistrationController>();

  @override
  Widget build(BuildContext context, ref) {
    var alreadyRegisteredEmails = ref.watch(alreadyRegisteredEmailsProvider);
    if (redirectedEmail?.isNotEmpty ?? false) {
      Future(
        () {
          controller.setEmail(redirectedEmail!);
          _RegisterEmailPageState.enableNext(
              _RegisterEmailPageState.formKey.currentState!.validate());
        },
      );
    }

    return KpEmailField(
      label: 'email_address'.tr,
      initialValue: redirectedEmail,
      validator: (email) {
        String? isFormatValid = emailValidator(email);
        if (isFormatValid != null) {
          return isFormatValid;
        } else if (alreadyRegisteredEmails.contains(email)) {
          return '$email ${'err_code_405'.tr}';
        }
        return null;
      },
      handleChange: (value) {
        controller.setEmail(value);
        _RegisterEmailPageState.enableNext(
            _RegisterEmailPageState.formKey.currentState!.validate());
      },
    );
  }
}

class NextButton extends ConsumerWidget {
  NextButton({Key? key}) : super(key: key);

  final controller = Get.find<RegistrationController>();

  @override
  Widget build(BuildContext context, ref) {
    return Obx(
      () => KabbeeButton(
        onTap: () => Get.find<RegistrationController>().checkEmail().then(
          (alreadyRegistered) {
            if (alreadyRegistered) {
              _RegisterEmailPageState.enableNext(false);
              ref
                  .read(alreadyRegisteredEmailsProvider.notifier)
                  .state
                  .add(controller.email!);

              _RegisterEmailPageState.formKey.currentState?.validate();
              return;
            }

            context.navigateTo(const RegisterPasswordRoute());
          },
        ),
        label: 'next'.tr,
        enabled: _RegisterEmailPageState.enableNext.value &&
            controller.isProcessing.isFalse,
        hasProcess: true,
        isProcessing: controller.isProcessing.value,
      ),
    );
  }
}
