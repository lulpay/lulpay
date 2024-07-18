import 'package:geolocator/geolocator.dart';

class GeolocationService {
  /// Determine the current position of the device.
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  Future<Position> determinePosition() async {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    LocationPermission permission = await Geolocator.checkPermission();
    if ([LocationPermission.denied, LocationPermission.deniedForever]
        .contains(permission)) {
      permission = await Geolocator.requestPermission();
      if (![LocationPermission.whileInUse, LocationPermission.always]
          .contains(permission)) {
        if ([LocationPermission.deniedForever].contains(permission)) {
          return Future.error(
              'Location permission is denied, please go to settings and allow permission to continue.');
        }
        return Future.error(
            'Location permission is denied, please allow permission to continue.');
      }
    }

    return await Geolocator.getCurrentPosition();
  }
}
