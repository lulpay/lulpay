import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../common/controllers/global_controller.dart';
import '../../common/widgets/kabbee_appbar.dart';

import '../controllers/login_controller.dart';
import '../widgets/auth_form.dart';
import '../widgets/auth_screens_wrapper.dart';
import '../widgets/login/chat_button.dart';
import '../widgets/login/default_auth_options.dart';
import '../widgets/login/terms_of_use.dart';
import '../widgets/server_option.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    Get.put(LoginController());

    Get.find<GlobalController>()
      ..globalContext = context
      ..globalScaffoldKey.currentState?.removeCurrentMaterialBanner();

    return AuthScreenWrapper(
      appBar: KabbeeAppBar(context, isTransparent: true, hasLeading: false),
      authForm: AuthForm(
        formKey: Get.find<LoginController>().loginFormKey,
        title: 'login'.tr,
        // subtitle: 'login_to_continue'.tr,
        subtitle:
            'Please chose one of the following  sign in methods to continue with Kabbee+'
                .tr,
        formComponents: const [
          DefaultAuthOptions(),
          ServerOption(),
        ],
        formFooter: const TermsOfUseLink(),
        floatingActionButton: const ChatButton(),
      ),
    );
  }
}
