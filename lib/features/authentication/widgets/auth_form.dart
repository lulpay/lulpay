import 'package:flutter/material.dart';

import '../../common/widgets/responsive.dart';
import 'auth_screen_title.dart';

class AuthForm extends StatelessWidget {
  const AuthForm({
    Key? key,
    required this.title,
    this.formKey,
    this.formComponents,
    this.formFooter,
    this.floatingActionButton,
    this.subtitle,
  }) : super(key: key);

  final GlobalKey<FormState>? formKey;
  final List<Widget>? formComponents;
  final Widget? formFooter;
  final Widget? floatingActionButton;

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                28, Responsive.isOnMobileView ? 128 : 72, 28, 0),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  AuthScreenTitle(
                    title: title,
                    subTitle: subtitle,
                  ),
                  ...?formComponents
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: SizedBox(
          height: formFooter == null ? 0 : 45,
          width: MediaQuery.of(context).size.width,
          child: formFooter,
        ),
        floatingActionButton: floatingActionButton,
      );
}
