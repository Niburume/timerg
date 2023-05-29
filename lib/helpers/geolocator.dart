import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart';
import 'package:geolocator/geolocator.dart';

class GeoPosition {
  GeoPosition._privateConstructor();
  static final GeoPosition instance = GeoPosition._privateConstructor();

  Future<Position> determinePosition() async {
    bool serviceEnable;

    LocationPermission permission;
    serviceEnable = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnable) {
      return Future.error('Location services are disabled');
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permission denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are denied permamently');
    }

    Position position = await Geolocator.getCurrentPosition();
    return position;
  }

  Future<double> distanceBetween2Coord(LatLng point1, LatLng point2) async {
    var _distanceInMeters = await Geolocator.distanceBetween(
      point1.lat,
      point1.lng,
      point2.lat,
      point2.lng,
    );
    return _distanceInMeters;
  }
}
