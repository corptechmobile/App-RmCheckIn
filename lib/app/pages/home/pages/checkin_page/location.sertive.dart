import 'package:geolocator/geolocator.dart';

Future<Position> getUserLocation() async {
  try {
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  } catch (e) {
    print("Error getting location: $e");
    return Future.error("Failed to get location");
  }
}
