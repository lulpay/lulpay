import 'package:flutter/material.dart';
import '../../../constants/padding.dart';
import '../../common/widgets/kabbee_text.dart';

class AuthScreenTitle extends StatelessWidget {
  const AuthScreenTitle({
    Key? key,
    required this.title,
    this.subTitle,
  }) : super(key: key);

  final String title;
  final String? subTitle;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          KabbeeText.headline3(title),
          if (subTitle != null)
            Padding(
              padding: const EdgeInsets.only(
                top: 6.0,
              ),
              child: KabbeeText(subTitle!),
            ),
          const SizedBox(
            height: nPadding,
          )
        ],
      ),
    );
  }
}
