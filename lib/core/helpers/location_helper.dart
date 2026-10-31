import 'package:dartz/dartz.dart';
import 'package:geolocator/geolocator.dart';

class LocationHelper {
  static Future<Either<String, Position>> getCurrentPosition() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      return const Left('Please turn on location services');
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return const Left('Location permission is needed to get your location');
    }

    try {
      return Right(await Geolocator.getCurrentPosition());
    } catch (_) {
      return const Left('Could not get your location, please try again');
    }
  }
}
