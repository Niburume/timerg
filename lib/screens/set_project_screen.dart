import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:provider/provider.dart';
import 'package:timerg/Models/pin_position_model.dart';
import 'package:timerg/Models/project_model.dart';
import 'package:timerg/helpers/geo_controller.dart';
import 'package:timerg/helpers/geolocator.dart';
import 'package:timerg/providers/data_provider.dart';
import 'package:timerg/widgets/confimation.dart';
import 'package:geocoder2/geocoder2.dart';

import '../constants/constants.dart';
import '../helpers/db_helper.dart';

class SetProjectScreen extends StatefulWidget {
  static const routeName = 'set_object_screen';

  @override
  State<SetProjectScreen> createState() => _SetProjectScreenState();
}

final homeScaffoldKey = GlobalKey<ScaffoldState>();

List<Project> allProjects = [];

Position? _position;
PinPosition pinPosition = PinPosition(
    latitude: 56.1,
    longitude: 34.1,
    radius: _desiredRadius,
    address: '',
    projectName: 'Project');
CameraPosition? _initialCameraPosition;
Circle? _circle;
double _currentZoom = 14.0;
double _desiredRadius = 100.0;
Set<Circle> _circles = {};
CircleId currentCircleId = CircleId('currentCircleId');
MarkerId currentMarkerId = MarkerId('currentMarkerId');
Set<Marker> markersSet = {};
double maxRadiusForCurrentMarker = 100;
TextEditingController nameController = TextEditingController();
TextEditingController noteController = TextEditingController();
TextEditingController addressController = TextEditingController();

class _SetProjectScreenState extends State<SetProjectScreen> {
  late GoogleMapController googleMapController;

  final Mode _mode = Mode.overlay;

  @override
  void didChangeDependencies() {
    getExistingProjects();
    jumpToCurrentLocation();
    setState(() {});
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    if (allProjects.isEmpty) {
      getExistingProjects();
    }

    if (_position?.latitude != null && _position?.longitude != null) {
      var latLng = LatLng(_position!.latitude, _position!.longitude);

      _initialCameraPosition = CameraPosition(target: latLng);
    } else {
      _initialCameraPosition = CameraPosition(
          target: const LatLng(50.42, -122.08), zoom: _currentZoom);
    }
// region UI
    return Scaffold(
      key: homeScaffoldKey,
      appBar: AppBar(
        title: Text('SearchScreen'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          GoogleMap(
            circles: _circles,
            myLocationButtonEnabled: false,
            initialCameraPosition: _initialCameraPosition!,
            markers: markersSet,
            onMapCreated: (GoogleMapController controller) {
              googleMapController = controller;
            },
            onTap: (LatLng latLng) {
              jumpToNewLocation(latLng);
            },
            onCameraMove: (CameraPosition position) {
              setState(() {
                _currentZoom = position.zoom;
              });
            },
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                child: Row(
                  children: [
                    Expanded(
                      child: Slider(
                        value: _desiredRadius,
                        min: 1,
                        max: 1000,
                        divisions: 1000,
                        onChanged: (double value) {
                          setState(() {
                            _desiredRadius = value;
                            updateCircleRadius();
                          });
                        },
                      ),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          jumpToCurrentLocation();
                        },
                        child: const Icon(Icons.my_location)),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                child: Container(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: _handlePressButton,
                      child: const Text('Search Places')),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                child: Container(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () {
                        addProject(pinPosition);
                      },
                      child: const Text('Add Project')),
                ),
              ),
              const SizedBox(
                height: 30,
              )
            ],
          )
        ],
      ),
    );
    // endregion
  }

  Future<void> jumpToNewLocation(LatLng latLng) async {
    googleMapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: latLng, zoom: _currentZoom)));

    updatePinPositionData(latLng);
    setMarker(latLng);
    setState(() {});
  }

  void jumpToCurrentLocation() async {
    _position = await GeoPosition.instance.determinePosition();

    LatLng latLng;
    if (_position?.latitude != null && _position?.longitude != null) {
      latLng = LatLng(_position!.latitude, _position!.longitude);
      updatePinPositionData(latLng);
      setState(() {});
      googleMapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: latLng, zoom: _currentZoom),
        ),
      );
      setMarker(latLng);
    }
  }

  void getExistingProjects() async {
    await Provider.of<DataProvider>(context, listen: false).queryAllProjects();
    allProjects = Provider.of<DataProvider>(context, listen: false).projects;
    if (allProjects.isEmpty) return;
    markersSet.clear();
    _circles.clear();

    allProjects.forEach((project) {
      LatLng latLng = LatLng(project.latitude, project.longitude);
      markersSet
          .add(Marker(markerId: MarkerId(project.address), position: latLng));

      _circle = Circle(
        circleId: CircleId(latLng.toString()),
        center: latLng,
        radius: project.radius,
        strokeWidth: 2,
        strokeColor: Colors.grey,
        fillColor: Colors.grey.withOpacity(0.2),
      );

      _circles.add(_circle!);
    });
    setState(() {});
  }

  void setMarker(LatLng latLng) {
    if (!determineMaxRadius(latLng)) return;

    markersSet.removeWhere((element) => element.markerId == currentMarkerId);

    _circles.removeWhere((element) => element.circleId == currentCircleId);

    markersSet.add(
      Marker(
        markerId: currentMarkerId,
        position: latLng,
      ),
    );
    _circles.add(Circle(
      circleId: currentCircleId,
      center: latLng,
      radius: _desiredRadius,
      strokeWidth: 2,
      strokeColor: Colors.blue,
      fillColor: Colors.blue.withOpacity(0.2),
    ));

    print(_circles.length);
    pinPosition.radius = _desiredRadius;
    pinPosition.latitude = latLng.latitude;
    pinPosition.longitude = latLng.longitude;
  }

  void updateCircleRadius() {
    LatLng latLng = LatLng(pinPosition.latitude, pinPosition.longitude);
    determineMaxRadius(latLng);

    _circles = _circles.map((circle) {
      if (circle.circleId == currentCircleId) {
        return circle.copyWith(radiusParam: _desiredRadius);
      }

      return circle.copyWith();
    }).toSet();

    pinPosition.radius = _desiredRadius;
    setState(() {});
  }

  // region DETERMINE MAX RADIUS
  bool determineMaxRadius(LatLng latLng) {
    double nearestDistance = 0;
    allProjects.forEach((project) async {
      final distance = GeoController.instance.calculateDistanceInMeters(
          latLng, LatLng(project.latitude, project.longitude));

      nearestDistance == 0 ? nearestDistance = distance : nearestDistance;
      nearestDistance = nearestDistance < distance ? nearestDistance : distance;

      maxRadiusForCurrentMarker = nearestDistance - project.radius;
      print(maxRadiusForCurrentMarker);
    });
    if (maxRadiusForCurrentMarker <= 1) {
      return false;
    }
    if (_desiredRadius > maxRadiusForCurrentMarker) {
      _desiredRadius = maxRadiusForCurrentMarker;
    }
    return true;
  }
// endregion

  Future<void> updatePinPositionData(LatLng latLng) async {
    var address = await Geocoder2.getDataFromCoordinates(
      latitude: latLng.latitude,
      longitude: latLng.longitude,
      googleMapApiKey: kGoogleApiKey,
    );

    var fullAddress = address.address;
    int commaIndex = fullAddress.lastIndexOf(',');
    if (commaIndex != -1) {
      fullAddress =
          fullAddress.substring(0, commaIndex); // Output: Remove, this, is, the
    }

    pinPosition = PinPosition(
        latitude: latLng.latitude,
        longitude: latLng.longitude,
        radius: _desiredRadius,
        address: fullAddress,
        projectName: fullAddress);
  }

  Future<void> _handlePressButton() async {
    Prediction? p = await PlacesAutocomplete.show(
        context: context,
        apiKey: kGoogleApiKey,
        onError: onError,
        mode: _mode,
        language: 'sv',
        strictbounds: false,
        types: [''],
        decoration: InputDecoration(
            hintText: 'Search',
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(color: Colors.white))),
        components: [Component(Component.country, 'SE')]);
    if (p != null) {
      displayPrediction(p, homeScaffoldKey.currentState);
    }
    //jumpToNewLocation();
  }

  // region ADD PROJECT
  void addProject(PinPosition pinPosition) {
    addressController.text = pinPosition.address;
    showGeneralDialog(
        context: context,
        pageBuilder: (_, __, ___) {
          return ConfirmationDialog(
            dataList: [
              {'latitude': pinPosition.latitude.toString()},
              {'longitude': pinPosition.longitude.toString()},
              {'radius': pinPosition.radius.toString()},
            ],
            onOkTap: addProjectToDatabase,
            okTitle: 'Add project',
            showTopTextField: true,
            topTextFieldHint: 'Name the porject',
            showAddressTextField: true,
            topTextFieldController: nameController,
            noteTextFieldController: noteController,
            noteHint: 'Add port code, floor etc here...',
            addressTextFieldController: addressController,
          );
        });
  }

  Future<void> addProjectToDatabase() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    await DBHelper.instance
        .createProject(Project(
            latitude: pinPosition.latitude,
            longitude: pinPosition.longitude,
            projectName: nameController.text,
            address: pinPosition.address,
            radius: pinPosition.radius,
            note: noteController.text.isEmpty ? '' : noteController.text,
            users: [userId!]))
        .then((value) => {
              CoolAlert.show(
                  title: 'The Project has been added',
                  closeOnConfirmBtnTap: true,
                  onConfirmBtnTap: () {
                    Navigator.pop(context);
                    getExistingProjects();
                  },

                  // autoCloseDuration: const Duration(milliseconds: 3000),
                  animType: CoolAlertAnimType.slideInRight,
                  context: context,
                  type: CoolAlertType.success)
              // Navigator.pop(context)
            });
  }
// endregion

// region error handling
  void onError(PlacesAutocompleteResponse response) {
    homeScaffoldKey.currentState!.showBottomSheet((context) => SnackBarAction(
          label: 'Some error...',
          onPressed: () {
            setState(() {});
          },
        ));
  }

  // endregion
// region geo and search methods
  Future<void> displayPrediction(
      Prediction p, ScaffoldState? currentState) async {
    GoogleMapsPlaces places = GoogleMapsPlaces(
        apiKey: kGoogleApiKey,
        apiHeaders: await const GoogleApiHeaders().getHeaders());
    PlacesDetailsResponse detail = await places.getDetailsByPlaceId(p.placeId!);

    LatLng latLng = LatLng(detail.result.geometry!.location.lat,
        detail.result.geometry!.location.lng);

    // markersList.clear();
    getExistingProjects();
    markersSet.add(Marker(
        markerId: const MarkerId('0'),
        position: latLng,
        infoWindow: InfoWindow(title: detail.result.name)));

    pinPosition.latitude = latLng.latitude;
    pinPosition.longitude = latLng.longitude;
    pinPosition.radius = _desiredRadius;
    pinPosition.projectName = detail.result.name;
    jumpToNewLocation(latLng);
  }

  // endregion
}
