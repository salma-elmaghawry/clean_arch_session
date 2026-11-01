import 'package:geolocator/geolocator.dart';

enum LocationFailure implements Exception {
  serviceDisabled('Turn on location services to use your current location'),
  denied('Location permission is needed to get your location'),
  deniedForever(
    'Location permission is blocked, allow it from the app settings',
  ),
  unavailable('Could not get your location, please try again');

  final String message;

  const LocationFailure(this.message);
}

class LocationHelper {
  // throws a LocationFailure when the location can't be read
  static Future<Position> getCurrentPosition() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      throw LocationFailure.serviceDisabled;
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied) {
      throw LocationFailure.denied;
    }
    // iOS shows the permission popup only once, and Android stops showing it
    // after the second "Don't allow", so only the settings page can fix it now
    if (permission == LocationPermission.deniedForever) {
      throw LocationFailure.deniedForever;
    }
    try {
      return await Geolocator.getCurrentPosition();
    } catch (_) {
      throw LocationFailure.unavailable;
    }
  }
}
