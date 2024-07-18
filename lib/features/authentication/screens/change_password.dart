import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/widgets/kabbee_appbar.dart';
import '../../common/widgets/responsive.dart';
import '../controllers/change_password_controller.dart';
import '../widgets/auth_screens_wrapper.dart';
import '../widgets/change_password/change_password_form.dart';

class ChangePasswordPage extends StatelessWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      Get.put(ChangePasswordController());

      const Widget form = ChangePasswordForm();

      return Scaffold(
        appBar: KabbeeAppBar(context, isTransparent: true),
        extendBodyBehindAppBar: true,
        body: const Align(
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            child: Responsive(
              mobile: MobileView(
                authForm: form,
              ),
              tablet: DesktopView(
                authForm: form,
                horizPaddingPercent: 0.12,
              ),
              desktop: DesktopView(
                authForm: form,
              ),
            ),
          ),
        ),
      );
    });
  }
}

class DesktopView extends StatelessWidget {
  const DesktopView({
    Key? key,
    required this.authForm,
    this.horizPaddingPercent = 0.15,
  }) : super(key: key);

  final double horizPaddingPercent;

  final Widget authForm;

  @override
  Widget build(BuildContext context) {
    var horizPad = context.width * horizPaddingPercent;
    return Card(
      margin: EdgeInsets.only(
        top: 64,
        left: horizPad,
        right: horizPad,
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
            // maxHeight: cardFormHeight,
            // maxWidth: MediaQuery.of(context).size.width * horizPaddingPercent,
            ),
        child: authForm,
      ),
    );
  }
}
