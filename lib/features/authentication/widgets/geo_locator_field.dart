import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import '../../common/widgets/kabbee_dialog.dart';
import '../services/geolocation_service.dart';
import '../../common/controllers/global_controller.dart';
import '../../common/widgets/kabbee_button.dart';
import '../../common/widgets/kabbee_textfield.dart';
import '../../common/widgets/kabbee_snackbars.dart';

class GeolocatorField extends GetView<GlobalController> {
  GeolocatorField({
    Key? key,
    required this.initialValue,
    required this.onAddressDetermined,
  }) : super(key: key);
  final TextEditingController _countryCtrl = TextEditingController();
  final RxBool isSearching = false.obs;

  final String initialValue;
  final Function(String) onAddressDetermined;

  @override
  Widget build(BuildContext context) {
    _countryCtrl.text = initialValue;

    return KabbeeTextField(
      controller: _countryCtrl,
      readOnly: true,
      label: 'country'.tr,
      validator: (country) {
        if (country == null) return null;

        country = country.trim();

        if (country.contains('Your country') || country.isEmpty) {
          return 'Search your country here'.tr;
        }

        return null;
      },
      suffixWidget: Padding(
        padding: const EdgeInsets.only(right: 4.0),
        child: Obx(
          () => KabbeeButton(
            onTap: () async {
              isSearching(true);

              try {
                Position position =
                    await GeolocationService().determinePosition();

                if (kIsWeb) {
                  _countryCtrl.text = (await controller.reverseGeoCoding(
                    position.latitude,
                    position.longitude,
                  ))!;
                } else {
                  await placemarkFromCoordinates(
                    position.latitude,
                    position.longitude,
                    localeIdentifier: 'en_US',
                  ).then(
                    (placeMark) {
                      _countryCtrl.text = '${placeMark[0].country}';
                    },
                  );
                }
                onAddressDetermined(_countryCtrl.text);
              } catch (e) {
                if (e.toString().contains('settings')) {
                  showWarningDialog(context,
                      title: 'allow_permission'.tr,
                      mainMessage: 'want_to_allow'.tr, onAffirm: () {
                    Geolocator.openAppSettings();
                  });
                }
                printError(info: e.toString());
                kabbeeSnackBar(
                  e.toString(),
                  isSuccessMsg: false,
                );
              } finally {
                isSearching(false);
              }
            },
            label: 'locate_me'.tr,
            hasProcess: true,
            isProcessing: isSearching.isTrue,
            enabled: isSearching.isFalse,
            width: 150,
            height: 44,
          ),
        ),
      ),
    );
  }
}
