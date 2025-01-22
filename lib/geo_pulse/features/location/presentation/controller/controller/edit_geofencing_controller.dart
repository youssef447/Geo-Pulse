import 'dart:async';
import 'dart:math';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../../core/theme/app_colors.dart';
import 'geofencing_controller.dart';
import 'location_controller.dart';

class EditGeofencingController extends GetxController {
  Completer<GoogleMapController> controller = Completer<GoogleMapController>();
  CameraPosition kGooglePlex = const CameraPosition(
    target: LatLng(30.033333, 31.233334),
    zoom: 14.4746,
  );

  CameraPosition? currentCameraPosition;
  CameraPosition? currentCameraPositionGeofencing;
  Position? currentLocation;
  var lat;
  var long;
  Set<Marker> loacationMarkers = {};

  /// Resets all the data in the controller to the initial state.
  void resetData() {
    currentCameraPosition = null;
    currentCameraPositionGeofencing = null;
    currentLocation = null;
    loacationMarkers = {};
    selectedLatLng = null;
    polygons = {};
    polygonPoints = [];
    geofencingMarkers = {};
  }

  /// adds a marker to the google map at the given position
  /// and reset the previous marker if exists
  void addMarkers(LatLng latLng) async {
    BitmapDescriptor? markerIcon;
    try {
      markerIcon = await BitmapDescriptorHelper.svgToBitmapFromUrl(
        "https://cdn.prod.website-files.com/654366841809b5be271c8358/659efd7c0732620f1ac6a1d6_why_flutter_is_the_future_of_app_development%20(1).webp",
        size: const Size(50, 50),
      );
    } catch (e) {
      markerIcon = await BitmapDescriptorHelper.getBitmapDescriptorFromSvgAsset(
        "'assets/vectors/knowticed_logo.svg'",
      );
    }

    loacationMarkers.clear();
    loacationMarkers.add(
      Marker(
        markerId: const MarkerId("999"),
        position: latLng,
        icon: markerIcon,
      ),
    );
    lat = latLng.latitude;
    long = latLng.longitude;
    update();
  }

  Set<Marker> geofencingMarkers = {};
  LatLng? selectedLatLng;
  Set<Polygon> polygons = {};
  List<LatLng> polygonPoints = [];

  /// Adds a marker to the google map at the given position
  /// and adds the marker's position to the `polygonPoints` list
  /// and updates the `polygons` set with a new Polygon object
  /// with the new points from `polygonPoints`.
  /// When the marker is tapped, it is removed from the google map
  /// and the `polygonPoints` list and the `polygons` set is updated.
  void setGeofencingMarker(LatLng latlng) async {
    int markerId = Random().nextInt(10000);

    if (geofencingMarkers.isEmpty && polygonPoints.length > 1) {
      polygonPoints.clear();
      polygons.clear();
    }
    geofencingMarkers.add(Marker(
        onTap: () {
          Marker marker = geofencingMarkers
              .where((marker) => marker.markerId.value == markerId.toString())
              .first;
          geofencingMarkers.remove(marker);
          polygonPoints.remove(marker.position);
          polygons.add(Polygon(
            polygonId: PolygonId(markerId.toString()),
            points: polygonPoints,
            fillColor: AppColors.primary,
            strokeColor: AppColors.secondaryPrimary,
            strokeWidth: 2,
          ));
          update();
        },
        markerId: MarkerId(markerId.toString()),
        position: latlng));
    polygonPoints.add(latlng);
    polygons.clear();
    polygons.add(
      Polygon(
        polygonId: PolygonId(markerId.toString()),
        points: polygonPoints,
        fillColor: AppColors.primary,
        strokeColor: AppColors.secondaryPrimary,
        strokeWidth: 2,
      ),
    );

    update();
  }

  /// This method is used to edit the geofencing marker by adding a new set of points.
  /// It takes a list of LatLng points, the latitude and longitude of the selected
  /// location as parameters. It clears the old geofencing markers and adds new ones
  /// at the given points. It also clears the polygons and creates a new one with
  /// the given points. Finally, it updates the camera position to the first point
  /// in the list and updates the UI.
  void editGeofencingMarker(List<LatLng> locationolygonPoints, double latitude,
      double longitude) async {
    BitmapDescriptor? markerIcon;
    try {
      markerIcon = await BitmapDescriptorHelper.svgToBitmapFromUrl(
        "https://cdn.prod.website-files.com/654366841809b5be271c8358/659efd7c0732620f1ac6a1d6_why_flutter_is_the_future_of_app_development%20(1).webp",
        size: const Size(50, 50),
      );
    } catch (e) {
      markerIcon = await BitmapDescriptorHelper.getBitmapDescriptorFromSvgAsset(
        "'assets/vectors/knowticed_logo.svg'",
      );
    }

    for (int i = 0; i < locationolygonPoints.length; i++) {
      polygonPoints.add(locationolygonPoints[i]);
    }
    polygons.clear();
    polygons.add(Polygon(
      polygonId: PolygonId(Random().nextInt(10000).toString()),
      points: polygonPoints,
      fillColor: AppColors.primary,
      strokeColor: AppColors.secondaryPrimary,
      strokeWidth: 2,
    ));
    loacationMarkers.clear();
    loacationMarkers.add(
      Marker(
        markerId: const MarkerId("999"),
        position: LatLng(latitude, longitude),
        icon: markerIcon,
      ),
    );
    lat = latitude;
    long = longitude;
    currentCameraPosition = CameraPosition(
      target: LatLng(latitude, longitude),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414,
      bearing: 192.8334901395799,
    );
    currentCameraPositionGeofencing = CameraPosition(
      target:
          LatLng(polygonPoints.first.latitude, polygonPoints.first.longitude),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414,
      bearing: 192.8334901395799,
    );
    update();
  }

  /// Gets the current position of the device.
  Future getPosition() async {
    bool? service;
    LocationPermission locationPer;
    service = await Geolocator.isLocationServiceEnabled();
    if (!service) {
      Get.defaultDialog(
        title: "Services".tr,
        content: Text("Location service is not enabled".tr),
      );
    }

    locationPer = await Geolocator.checkPermission();

    if (locationPer == LocationPermission.denied) {
      locationPer = await Geolocator.requestPermission();
    }
    if (locationPer == LocationPermission.always) {
      getLatAndLong();
    }
  }

  bool isLoading = false;

  /// Gets the current latitude and longitude of the device.
  ///
  /// If the location is not set and the user is not editing a location,
  /// it gets the current position of the device using the Geolocator package.
  ///
  /// Then, it sets the camera position to the current location and updates the UI.
  Future<void> getLatAndLong() async {
    isLoading = true;
    if (lat != null || long != null) {
      currentCameraPosition = CameraPosition(
        target: LatLng(lat, long),
        tilt: 59.440717697143555,
        zoom: 19.151926040649414,
        bearing: 192.8334901395799,
      );
    }
    isLoading = false;
    update();
  }

  /// Goes to the current location of the device on the map.
  ///
  /// This method uses the Geolocator package to get the current position
  /// of the device, and then moves the camera to that position on the map.
  ///
  /// The camera is moved using the [animateCamera] method on the
  /// [GoogleMapController], which is obtained using the [controller]
  /// future. The [CameraPosition] is constructed with the current
  /// location, and then passed to the [animateCamera] method.
  Future<void> goToCurrentLocation() async {
    currentLocation =
        await Geolocator.getCurrentPosition().then((value) => value);
    currentCameraPosition = CameraPosition(
      target: LatLng(currentLocation!.latitude, currentLocation!.longitude),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414,
      bearing: 192.8334901395799,
    );

    final GoogleMapController mapController = await controller.future;
    mapController
        .animateCamera(CameraUpdate.newCameraPosition(currentCameraPosition!));
  }

  /// Sets the latitude and longitude values in the LocationController
  /// using the current lat and long values, then navigates back
  void setLatAndLongToFormFields() {
    Get.find<LocationController>().setLatAndLong(lat, long);
    Get.find<LocationController>().getAddress(lat, long);
  }

  /// Sets geofencing details to form fields.
  void setGeofencingToFormFields(context) {
    Get.find<LocationController>()
        .calculatePolygonAreaAndPerimeter(polygonPoints);
  }

  @override
  void onInit() {
    getPosition();
    getLatAndLong();
    super.onInit();
  }
}
