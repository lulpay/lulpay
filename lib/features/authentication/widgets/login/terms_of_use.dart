import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

import '../../../../constants/padding.dart';
import '../../../../routing/router.gr.dart';
import '../../../../theme/colors_utility.dart';
import '../../../footer/widgets/footer_links.dart';

class TermsOfUseLink extends StatelessWidget {
  const TermsOfUseLink({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var termLinkParts = 'accept_agreement'.tr.split('{}');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: sPadding),
      child: GestureDetector(
        onTap: () {
          if (kIsWeb) {
            loadEULA('EULA');
            return;
          }
          context.pushRoute(
            const TermsAgreementRoute(),
          );
        },
        child: RichText(
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
          text: TextSpan(
            children: <TextSpan>[
              TextSpan(
                text: termLinkParts.first,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              TextSpan(
                text: 'terms_of_use'.tr,
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: primaryColor(context),
                    ),
              ),
              if (termLinkParts.length > 1)
                TextSpan(
                  text: termLinkParts.last,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
