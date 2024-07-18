import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../constants/padding.dart';
import '../../../common/widgets/kabbee_text.dart';
import '../../controllers/login_controller.dart';

class KeepMeLogged extends GetView<LoginController> {
  const KeepMeLogged({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => controller.setRememberMe(!controller.isRemember.value),
      borderRadius: BorderRadius.circular(borderRadius),
      child: Ink(
        height: 48,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: xsPadding),
              constraints: const BoxConstraints(maxWidth: 18, maxHeight: 18),
              child: Obx(
                () => Checkbox(
                  value: controller.isRemember.value,
                  onChanged: controller.setRememberMe,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  splashRadius: 0.0,
                ),
              ),
            ),
            const SizedBox(width: xsPadding),
            KabbeeText.subtitle2(
              'remeber_me'.tr,
            ),
          ],
        ),
      ),
    );
  }
}
