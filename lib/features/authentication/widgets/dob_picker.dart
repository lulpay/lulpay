import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common/utility/kabbee_icons.dart';
import '../../common/utility/utility_methods.dart';

import '../../common/widgets/kabbee_textfield.dart';

class DatePicker extends StatelessWidget {
  const DatePicker({
    Key? key,
    required this.textController,
    required this.onChange,
    required this.dateUpperLimit,
    this.label,
    this.focusNode,
  }) : super(key: key);

  final FocusNode? focusNode;

  final TextEditingController textController;

  final VoidCallback onChange;
  final String? label;

  final DateTime dateUpperLimit;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: GestureDetector(
        onTap: () async => await _selectDate(context),
        // using stack to make clickable overlay above TextFormField
        child: Stack(
          children: [
            KabbeeTextField(
              focusNode: focusNode,
              readOnly: true,
              controller: textController,
              label: label,
              suffixWidget: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: KabbeeIcons.calendar(size: 24),
              ),
            ),
            Positioned.fill(
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future _selectDate(BuildContext context) async {
    String currentValue = textController.text;
    if (!GetUtils.isDateTime(currentValue)) {
      currentValue = dateFormatter(date: dateUpperLimit);
    }

    final DateTime currentDate = DateTime.parse(currentValue);

    DateTime? newSelectedDate;

    if (!GetPlatform.isIOS) {
      newSelectedDate = await showDatePicker(
          context: context,
          initialDate: currentDate,
          firstDate: DateTime(1930),
          lastDate: dateUpperLimit,
          builder: (context, child) {
            return SingleChildScrollView(child: child);
          });
    } else {
      await showCupertinoModalPopup<void>(
        context: context,
        builder: (context) {
          return CupertinoTheme(
            data: CupertinoTheme.of(context).copyWith(
              textTheme: CupertinoTextThemeData(
                dateTimePickerTextStyle: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            child: Container(
              height: 216,
              padding: const EdgeInsets.only(top: 6),
              margin: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              color: CupertinoColors.systemBackground.resolveFrom(context),
              child: DefaultTextStyle(
                style: CupertinoTheme.of(context).textTheme.textStyle,
                child: GestureDetector(
                  onTap: () {},
                  child: SafeArea(
                    top: false,
                    child: CupertinoDatePicker(
                      backgroundColor:
                          CupertinoColors.systemBackground.resolveFrom(context),
                      mode: CupertinoDatePickerMode.date,
                      initialDateTime: currentDate,
                      maximumYear: dateUpperLimit.year,
                      minimumYear: 1930,
                      onDateTimeChanged: (value) {
                        newSelectedDate = value;
                      },
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      );
    }

    if (newSelectedDate != null) {
      textController.text = dateFormatter(date: newSelectedDate!);

      onChange.call();
    }
  }
}
