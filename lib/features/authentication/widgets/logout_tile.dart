import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../common/utility/kabbee_icons.dart';

import '../../common/controllers/global_controller.dart';
import '../../common/widgets/kabbee_dialog.dart';
import '../../quizzes/providers/user_info_provider.dart';
import '../../settings/widgets/menu_tile.dart';
import '../../settings/widgets/menu_container.dart';

class LogoutTile extends ConsumerWidget {
  const LogoutTile({
    Key? key,
    this.padding,
  }) : super(key: key);

  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context, ref) {
    return MenuContainer(
      padding: padding,
      children: [
        MenuTile(
          label: 'logout'.tr,
          leadingIconData: KabbeeIcons.logOutAsset,
          onPressed: () => showWarningDialog(
            context,
            title: 'are_you_sure'.tr,
            mainMessage: 'you_need_sign_again'.tr,
            onAffirm: () async {
              ref.invalidate(quizUserProvider);
              Get.find<GlobalController>().logOutUser();
            },
          ),
          showBtmDivider: false,
        ),
      ],
    );
  }
}
