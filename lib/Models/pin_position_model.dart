class PinPosition {
  double latitude;
  double longitude;
  double radius;
  String projectName;
  String address;

  PinPosition(
      {required this.latitude,
      required this.longitude,
      required this.radius,
      required this.address,
      this.projectName = 'Project name'});
}

class Positions {
  List<PinPosition> positions = [];
}
