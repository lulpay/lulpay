import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../theme/colors_utility.dart';
import '../../common/widgets/kabbee_text.dart';

class GenderSelector extends StatelessWidget {
  GenderSelector({
    Key? key,
    required this.initialGenderIndex,
    required this.onGenderSelected,
  }) : super(key: key);

  final RxList<bool> isSelected = <bool>[false, false].obs;
  final int initialGenderIndex;
  final Function(int index) onGenderSelected;

  @override
  Widget build(BuildContext context) {
    isSelected[initialGenderIndex] = true;

    return Container(
      constraints: const BoxConstraints(maxWidth: 568, maxHeight: 56),
      padding: const EdgeInsets.only(left: 24.0),
      margin: const EdgeInsets.only(bottom: 16.0),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(4)),
        border: Border.all(color: Colors.grey),
        color: surfaceColor(context),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          KabbeeText(
            'gender'.tr,
            customStyle: Theme.of(context).inputDecorationTheme.labelStyle,
          ),
          Padding(
            padding: const EdgeInsets.all(6),
            child: Obx(
              () => ToggleButtons(
                isSelected: isSelected.toList(),
                borderRadius: BorderRadius.circular(4),
                textStyle: Theme.of(context).textTheme.titleSmall,
                fillColor: primaryColor(context),
                selectedColor: onPrimary(context),
                onPressed: (index) {
                  if (index == 0) {
                    isSelected[0] = true;
                    isSelected[1] = false;
                  } else {
                    isSelected[0] = false;
                    isSelected[1] = true;
                  }
                  onGenderSelected(index);
                },
                children: <Widget>[
                  ToggleButton(
                    label: 'male'.tr,
                  ),
                  ToggleButton(
                    label: 'female'.tr,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ToggleButton extends StatelessWidget {
  const ToggleButton({
    Key? key,
    required this.label,
  }) : super(key: key);
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      alignment: Alignment.center,
      child: KabbeeText(label),
    );
  }
}
