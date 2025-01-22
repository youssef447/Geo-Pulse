import 'dart:async';
import 'dart:math' as math;
import 'dart:ui';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/flutter_svg.dart' as fsvg;
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

import '../../../../../core/theme/app_colors.dart';
import 'location_controller.dart';

class GeofencingController extends GetxController {
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

  /// adds a marker to the google map at the given position
  /// and reset the previous marker if exists
  void addMarkers(LatLng latLng) async {
    BitmapDescriptor? icon;
    try {
      icon = await BitmapDescriptorHelper.svgToBitmapFromUrl(
        "https://cdn.prod.website-files.com/654366841809b5be271c8358/659efd7c0732620f1ac6a1d6_why_flutter_is_the_future_of_app_development%20(1).webp",
        size: const Size(100, 100),
      );
    } catch (e) {
      icon = await BitmapDescriptorHelper.getBitmapDescriptorFromSvgAsset(
        "'assets/vectors/knowticed_logo.svg'",
      );
    }

    loacationMarkers.clear();
    loacationMarkers.add(
      Marker(
        onTap: () {
          print("tap on the marker");
        },
        markerId: const MarkerId("999"),
        position: latLng,
        icon: icon,
      ),
    );
    currentCameraPositionGeofencing = CameraPosition(
      target: LatLng(latLng.latitude, latLng.longitude),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414,
      bearing: 192.8334901395799,
    );
    lat = latLng.latitude;
    long = latLng.longitude;
    update();
  }

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
    int markerId = math.Random().nextInt(10000);

    geofencingMarkers.add(
      Marker(
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
        position: latlng,
      ),
    );
    polygonPoints.add(latlng);
    polygons.clear();
    polygons.add(Polygon(
      polygonId: PolygonId(markerId.toString()),
      points: polygonPoints,
      fillColor: AppColors.primary,
      strokeColor: AppColors.secondaryPrimary,
      strokeWidth: 2,
    ));

    update();
  }

  /// Gets the current position of the device.
  ///
  /// First, it checks if the location service is enabled.
  /// If it is not, it shows a dialog with a message.
  ///
  /// Then, it checks the location permission.
  /// If the permission is denied, it requests the permission.
  /// If the permission is granted, it calls [getLatAndLong].
  ///
  /// The [getLatAndLong] method is called only if the location permission
  /// is granted.
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

  /// Checks the location permission status.
  ///
  /// This method checks if the location permission is granted, denied, or permanently denied.
  /// If the permission is granted, it prints "Granted".
  /// If the permission is denied, it requests the permission and prints "Granted" if the request is successful, otherwise prints "Denied".
  /// If the permission is permanently denied, it opens the app settings.
  Future<bool> _checkPermission() async {
    var status = await Permission.location.status;

    if (status.isGranted) {
      print(" Granted");
    } else if (status.isDenied) {
      // Request permission
      if (await Permission.location.request().isGranted) {
        print(" Granted");
      } else {
        print(" Denied");
      }
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
    return status.isGranted;
  }

  bool isLoading = false;

  /// Gets the current latitude and longitude of the device.
  ///
  /// If the location is not set and the user is not editing a location,
  /// it gets the current position of the device using the Geolocator package.
  ///
  /// Then, it sets the camera position to the current location and updates the UI.
  ///
  Future<void> getLatAndLong() async {
    isLoading = true;
    bool status = await _checkPermission();
    bool service = await Geolocator.isLocationServiceEnabled();
    if (status) {
      if (service) {
        currentLocation = await Geolocator.getCurrentPosition();
        lat = currentLocation!.latitude;
        long = currentLocation!.longitude;
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
  }

  /// Goes to the current location of the device on the map.
  Future<void> goToCurrentLocation() async {
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
  ///
  /// This method checks the number of points in `polygonPoints`. If there are
  /// fewer than 3 points, it displays a dialog indicating an invalid location
  /// and requests the user to select at least 3 points. If there are 3 or more
  /// points, it calculates the polygon area using the `LocationController` and
  /// then closes the current dialog.
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

class BitmapDescriptorHelper {
  /// Converts an SVG image from a given URL into a `BitmapDescriptor` suitable for
  /// use as a map marker icon. The SVG is fetched from the network, rendered to a
  /// bitmap image with a specified size, and converted to PNG format.
  static Future<BitmapDescriptor> svgToBitmapFromUrl(String url,
      {Size size = const Size(100, 100)}) async {
    // Fetch SVG data from the URL
    final response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) {
      throw Exception('Failed to load SVG from network');
    }

    // Use the SVG data as a string for loading
    final svgString = response.body;
    final fsvg.PictureInfo pictureInfo =
        await fsvg.vg.loadPicture(fsvg.SvgStringLoader(svgString), null);

    // Calculate scale to fit the desired size
    final double width = size.width;
    final double height = size.height;
    final double originalWidth = pictureInfo.size.width;
    final double originalHeight = pictureInfo.size.height;
    final double scaleX = width / originalWidth;
    final double scaleY = height / originalHeight;
    final double scale = math.min(scaleX, scaleY); // Maintain aspect ratio

    // Render the SVG to an image with scaling
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);

    canvas.scale(scale); // Apply scale to fit desired width and height
    canvas.drawPicture(pictureInfo.picture);

    final ui.Image image = await pictureRecorder
        .endRecording()
        .toImage(width.toInt(), height.toInt());
    final ByteData? byteData =
        await image.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List uint8list = byteData!.buffer.asUint8List();

    return BitmapDescriptor.bytes(uint8list);
  }

  /// Converts an SVG asset from the flutter assets bundle into a `BitmapDescriptor`
  /// suitable for use as a map marker icon. The SVG is rendered to a bitmap image
  /// with a specified size, and converted to PNG format.
  static Future<BitmapDescriptor> getBitmapDescriptorFromSvgAsset(
    String assetName, [
    Size size = const Size(48, 48),
  ]) async {
    final pictureInfo = await vg.loadPicture(SvgAssetLoader(assetName), null);

    double devicePixelRatio = ui.window.devicePixelRatio;
    int width = (size.width * devicePixelRatio).toInt();
    int height = (size.height * devicePixelRatio).toInt();

    final scaleFactor = math.min(
      width / pictureInfo.size.width,
      height / pictureInfo.size.height,
    );

    final recorder = ui.PictureRecorder();

    ui.Canvas(recorder)
      ..scale(scaleFactor)
      ..drawPicture(pictureInfo.picture);

    final rasterPicture = recorder.endRecording();

    final image = rasterPicture.toImageSync(width, height);
    final bytes = (await image.toByteData(format: ui.ImageByteFormat.png))!;

    return BitmapDescriptor.bytes(bytes.buffer.asUint8List());
  }
}
