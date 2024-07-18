import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants/padding.dart';
import '../../common/widgets/unfocus.dart';

import '../../common/controllers/global_controller.dart';
import '../../common/widgets/kabbee_appbar.dart';
import '../../common/widgets/responsive.dart';
import '../../footer/widgets/footer_links.dart';
import '../../common/widgets/kabbee_logo.dart';

class AuthScreenWrapper extends StatelessWidget {
  const AuthScreenWrapper({
    Key? key,
    required this.authForm,
    this.appBar,
  }) : super(key: key);

  final PreferredSizeWidget? appBar;
  final Widget authForm;

  @override
  Widget build(context) {
    Get.find<GlobalController>().globalContext ??= context;

    return Unfocus(
      child: Scaffold(
        appBar: appBar ?? KabbeeAppBar(context, isTransparent: true),
        extendBodyBehindAppBar: !kIsWeb,
        body: Align(
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Responsive(
              mobile: MobileView(
                authForm: authForm,
              ),
              desktop: DesktopView(
                authForm: authForm,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MobileView extends StatelessWidget {
  const MobileView({
    Key? key,
    required this.authForm,
  }) : super(key: key);

  final Widget authForm;
  @override
  Widget build(BuildContext context) => SizedBox(
        height: context.height,
        child: authForm,
      );
}

class DesktopView extends StatelessWidget {
  const DesktopView({
    Key? key,
    required this.authForm,
  }) : super(key: key);

  final Widget authForm;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) {
          double cardFormHeight = 618;

          return Column(
            children: [
              Stack(
                alignment: Alignment.topCenter,
                children: [
                  DecoratedBox(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                          'assets/images/auth_bg.jpeg',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(
                      width: context.width,
                      height: min(constraints.maxHeight, 1024),
                      decoration: BoxDecoration(
                        gradient:
                            Theme.of(context).brightness == Brightness.dark
                                ? LinearGradient(
                                    colors: [
                                      Theme.of(context).scaffoldBackgroundColor,
                                      Theme.of(context)
                                          .scaffoldBackgroundColor
                                          .withOpacity(0.8),
                                      Colors.transparent,
                                    ],
                                    stops: const [0.0, 0.3, 1.0],
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.center,
                                  )
                                : null,
                      ),
                    ),
                  ),
                  Container(
                    constraints: const BoxConstraints(maxWidth: 520),
                    padding: const EdgeInsets.only(top: nPadding),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const KabbeeLogo(),
                        Card(
                          margin: const EdgeInsets.only(top: 28),
                          child: Container(
                            constraints: BoxConstraints(
                              maxHeight: cardFormHeight,
                            ),
                            child: authForm,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const FooterLinks(),
            ],
          );
        },
      );
}
