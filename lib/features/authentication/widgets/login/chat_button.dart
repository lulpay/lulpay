import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../theme/colors_utility.dart';
import '../../../common/utility/kabbee_icons.dart';
import '../../controllers/login_controller.dart';

class ChatButton extends GetView<LoginController> {
  const ChatButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (GetPlatform.isMobile) {
      return FloatingActionButton(
        onPressed: () => controller.goToChatPage(context),
        child: KabbeeIcons.supportChat(color: onPrimary(context)),
        // label: KabbeeText('customer_service'.tr),
      );
    }
    return const SizedBox.shrink();
  }
}
