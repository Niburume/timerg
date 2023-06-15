import 'dart:async';

import 'dart:math';

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:timerg/Models/project_model.dart';

class GeoController {
  static final GeoController instance = GeoController();
  // List<Project> projects = [];

  Future<Project?> checkDistanceOfProjectsToPosition(
      List<Project> projects) async {
    Project? foundProject;

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    projects.forEach((project) {
      var distance = calculateDistanceInMeters(
          LatLng(position.latitude, position.longitude),
          LatLng(project.latitude, project.longitude));
      // print('distanse between ${project.address} and here is $distance');
      if (distance <= project.radius) {
        foundProject = project;
        return;
      }
    });

    return foundProject;
  }

  // region CALCULATE DISTANCE BETWEEN 2 POS
  double calculateDistanceInMeters(
      LatLng firstPosition, LatLng secondPosition) {
    double nearestDistance = 0;
    const double earthRadius = 6371.0;
    // Convert coordinates to radians
    final double lat1 = firstPosition.latitude * (pi / 180.0);
    final double lon1 = firstPosition.longitude * (pi / 180.0);
    final double lat2 = secondPosition.latitude * (pi / 180.0);
    final double lon2 = secondPosition.longitude * (pi / 180.0);

    // Calculate the differences between the coordinates
    final double dLat = lat2 - lat1;
    final double dLon = lon2 - lon1;

    final double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1) * cos(lat2) * sin(dLon / 2) * sin(dLon / 2);
    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    final double distance = earthRadius * c;

    return (distance * 1000);
  }

  // endregion
}
