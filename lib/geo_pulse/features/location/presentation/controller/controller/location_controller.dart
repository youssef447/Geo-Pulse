// Mohamed Ashraf , Youssef Ashraf
// location controller which is Specific to Manager and Hr
import 'dart:math';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/constants/enums.dart';
import '../../../../../core/constants/strings.dart';
import '../../../../../core/helpers/get_dialog_helper.dart';
import '../../../../../core/helpers/validation_helper.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/dialog/default_dialog.dart';
import '../../../../../core/widgets/loading/loading.dart';
import '../../../../request_type/presentation/controller/request_types_controller.dart';
import '../../../data/models/address_model.dart';
import '../../../data/models/location_model.dart';
import '../../../domain/location_repo.dart';
import 'edit_geofencing_controller.dart';

class LocationController extends GetxController {
  final LocationRepo locationRepo;
  LocationController({required this.locationRepo});

  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // late Stream<List<LocationModel>> locationStream;

  // void _initializeLocationStream() {
  //   locationStream = _firestore
  //       .collection('Company_Locations')
  //       .snapshots()
  //       .map((snapshot) {
  //     return snapshot.docs.map((doc) {
  //       print(doc.data());
  //       return LocationModel.fromMap(doc.data());
  //     }).toList();
  //   });
  // }

  List<LocationModel> locationModels = [];
  List<LocationModel> locationModelsWithoutFilter = [];
  final locationNameEnglishController = TextEditingController();
  final locationNameArabicController = TextEditingController();
  final googleMapsLinkController = TextEditingController();
  final latitudeController = TextEditingController();
  final longitudeController = TextEditingController();
  final geoFencingPerimeterController = TextEditingController();
  final geoFencingAreaController = TextEditingController();
  final countryController = TextEditingController();
  final stateOrProvinceController = TextEditingController();
  final cityController = TextEditingController();
  final countryArabicController = TextEditingController();
  final stateOrProvinceArabicController = TextEditingController();
  final cityArabicController = TextEditingController();
  final allowPeriodController = TextEditingController();
  final postalCodeController = TextEditingController();
  final LocationAccuracy2 locationAccuracy = LocationAccuracy2.medium;
  final geoFencingController = TextEditingController();
  final periodTimeNumber = TextEditingController();
  bool allowBreaksInAttendance = true;
  bool allowPause = true;
  bool allowGeofence = false;

  // set lat and long from current location
  void setLatAndLong(double lat, double long) {
    latitudeController.text = lat.toString();
    longitudeController.text = long.toString();
    googleMapsLinkController.text = "https://www.google.com/maps?q=$lat,$long";
    polygonPoints = generatePolygonAroundPoint(LatLng(lat, long), 100, 10);
    calculatePolygonAreaAndPerimeter(polygonPoints);
    update([AppConstanst.locationDialog]);
  }

  /// Gets the address of the location from the coordinates and sets the controllers
  /// for the country, state or province, city and postal code in both English and Arabic
  Future<void> getAddress(double lat, double long) async {
    try {
      List<Placemark> placeMarkEnglish = [];
      List<Placemark> placeMarkArabic = [];
      // Get the placemarks in English
      await setLocaleIdentifier('en');
      placeMarkEnglish = await placemarkFromCoordinates(lat, long);

      // Set the English address controllers
      countryController.text = placeMarkEnglish[0].country!;
      stateOrProvinceController.text = placeMarkEnglish[0].administrativeArea!;
      cityController.text = placeMarkEnglish[0].locality!;
      postalCodeController.text = placeMarkEnglish[0].postalCode!;
      // Get the placemarks in Arabic
      await setLocaleIdentifier('ar');
      placeMarkArabic = await placemarkFromCoordinates(lat, long);

      // Set the Arabic address controllers
      countryArabicController.text = placeMarkArabic[0].country!;
      stateOrProvinceArabicController.text =
          placeMarkArabic[0].administrativeArea!;
      cityArabicController.text = placeMarkArabic[0].locality!;
    } catch (e) {
      return Future.value([e.toString()]);
    }
  }

  List<LatLng> polygonPoints = [];
  final double earthRadius = 6371000; // Radius of Earth in meters

  /// Generates a regular polygon around a given center point with the given radius
  /// and number of points.
  List<LatLng> generatePolygonAroundPoint(
      LatLng center, double radiusMeters, int numPoints) {
    double radiusRadians = radiusMeters / earthRadius; // Radius in radians
    List<LatLng> polygonPoints = [];

    for (int i = 0; i < numPoints; i++) {
      double angle = (2 * pi * i) / numPoints;
      double latitudeOffset = asin(sin(center.latitude * pi / 180) *
              cos(radiusRadians) +
          cos(center.latitude * pi / 180) * sin(radiusRadians) * cos(angle));
      double longitudeOffset = center.longitude * pi / 180 +
          atan2(
              sin(angle) * sin(radiusRadians) * cos(center.latitude * pi / 180),
              cos(radiusRadians) -
                  sin(center.latitude * pi / 180) * sin(latitudeOffset));

      polygonPoints
          .add(LatLng(latitudeOffset * 180 / pi, longitudeOffset * 180 / pi));
    }
    return polygonPoints;
  }

  /// Calculates the area and perimeter of a polygon given its vertices.
  ///
  /// This method takes a list of [LatLng] points that define the vertices of the
  /// polygon. It calculates the total area using the spherical excess formula and
  /// the total perimeter using the Haversine formula. The calculated area and
  /// perimeter are then displayed in the `geoFencingController`.
  void calculatePolygonAreaAndPerimeter(List<LatLng> allPolygonPoints) {
    polygonPoints = allPolygonPoints;
    double totalArea = 0.0;
    double totalPerimeter = 0.0;

    for (int i = 0; i < allPolygonPoints.length; i++) {
      LatLng point1 = allPolygonPoints[i];
      LatLng point2 = allPolygonPoints[(i + 1) % allPolygonPoints.length];

      // Convert degrees to radians
      double lon1 = point1.longitude * pi / 180;
      double lat1 = point1.latitude * pi / 180;
      double lon2 = point2.longitude * pi / 180;
      double lat2 = point2.latitude * pi / 180;

      // Calculate area
      totalArea += (lon2 - lon1) * (2 + sin(lat1) + sin(lat2));

      // Calculate perimeter using Haversine formula
      double dLat = lat2 - lat1;
      double dLon = lon2 - lon1;
      double a =
          pow(sin(dLat / 2), 2) + cos(lat1) * cos(lat2) * pow(sin(dLon / 2), 2);
      double c = 2 * atan2(sqrt(a), sqrt(1 - a));
      double distance = earthRadius * c;
      totalPerimeter += distance;
    }

    double area = totalArea * earthRadius * earthRadius / 2.0;
    geoFencingController.text = "Area: ${area.abs().ceil()} m², "
        "Perimeter: ${totalPerimeter.ceil()} m";
    geoFencingPerimeterController.text = totalPerimeter.ceil().toString();
    geoFencingAreaController.text = area.abs().ceil().toString();
  }

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String? selectedPeriodType;
  selectedPeriodTypeToggle(String value) {
    selectedPeriodType = value;
    update([AppConstanst.locationDialog]);
    // update([AppConstanst.location]);
    update();
  }

  void resetData() {
    locationNameEnglishController.clear();
    locationNameArabicController.clear();
    googleMapsLinkController.clear();
    latitudeController.clear();
    longitudeController.clear();
    geoFencingPerimeterController.clear();
    geoFencingAreaController.clear();
    cityController.clear();
    countryController.clear();
    postalCodeController.clear();
    stateOrProvinceController.clear();
    allowBreaksInAttendance = true;
    allowPause = true;
    allowGeofence = false;
    cityArabicController.clear();
    stateOrProvinceArabicController.clear();
    countryArabicController.clear();
    allowPeriodController.clear();
    polygonPoints = [];
    editingLocationIndex = null;
    selectedPeriodType = null;
  }

  String dropDownArrow = AppAssets.down;
  String? selectedAccuracyType;
  toggleArrow(bool? opened) {
    dropDownArrow = opened ?? false ? AppAssets.down : AppAssets.down;
    update([AppConstanst.locationDialog]);
  }

  void selectAccuracyType(String value) {
    selectedAccuracyType = value;
    update([AppConstanst.locationDialog]);
  }

  /// Adds a new location to the Firestore database.
  /// The location is created with the information from the controllers
  /// and is then added to the database. If the location is successfully
  /// added, it is also added to the list of locations in the controller
  /// and the UI is updated.
  Future<void> addLocation(BuildContext context) async {
    showLoadingIndicator();
    String docId = DateTime.now().toString();

    // Check if the user has selected a period type and entered a value
    bool hasAllowPeriod = false;
    if (selectedPeriodType != null &&
        allowBreaksInAttendance == true &&
        allowPeriodController.text.isNotEmpty) {
      hasAllowPeriod = true;
    }

    // Create a new location model with the entered data
    LocationModel newLocationModel = LocationModel(
      id: docId,
      status: AppConstanst.active,
      // The polygon points are the geofencing points
      polygonPoints: polygonPoints,
      // The location name in English
      locationNameEnglish: locationNameEnglishController.text,
      // The location name in Arabic
      locationNameArabic: locationNameArabicController.text,
      // The Google Maps link
      googleMapsLink: googleMapsLinkController.text.isNotEmpty
          ? googleMapsLinkController.text
          : 'https://www.google.com/maps/search/?api=1&query=${double.parse(latitudeController.text)},${double.parse(latitudeController.text)}',
      // The latitude
      latitude: latitudeController.text.isNotEmpty
          ? double.parse(latitudeController.text)
          : 0.0,
      // The longitude
      longitude: longitudeController.text.isNotEmpty
          ? double.parse(longitudeController.text)
          : 0.0,
      // The geofencing perimeter
      geoFencingPerimeter: int.parse(geoFencingPerimeterController.text),
      // The geofencing area
      geoFencingArea: int.parse(geoFencingAreaController.text),
      // The breaks in attendance
      allowBreaksInAttendance: allowBreaksInAttendance,
      // The pause in attendance
      allowPause: allowPause,
      // The allow period time number
      allowPeriodTimeNumber:
          hasAllowPeriod ? int.tryParse(allowPeriodController.text) : null,
      // The location accuracy
      // locationAccuracy: selectedAccuracyType != null
      //     ? selectedAccuracyType == LocationAccuracy2.high.getName
      //         ? LocationAccuracy2.high
      //         : selectedAccuracyType == LocationAccuracy2.medium.getName
      //             ? LocationAccuracy2.medium
      //             : LocationAccuracy2.low
      //     : LocationAccuracy2.low,
      // The allow geofence
      allowGeofence: allowGeofence,
      // The allow period time
      allowPeriodTime: hasAllowPeriod
          ? selectedPeriodType! == AllowPeriodTime.mins.getName
              ? AllowPeriodTime.mins
              : AllowPeriodTime.hours
          : null,
      // The address
      address: Address(
        // The city
        city: cityController.text,
        // The country
        country: countryController.text,
        // The state or province
        stateOrProvince: stateOrProvinceController.text,
        // The postal code
        postalCode: postalCodeController.text,
        // The city in Arabic
        cityArabic: cityArabicController.text,
        // The country in Arabic
        countryArabic: countryArabicController.text,
        // The state or province in Arabic
        stateOrProvinceArabic: stateOrProvinceArabicController.text,
      ),
    );

    // Add the location to the database

    final response = await locationRepo.addLocation(newLocationModel);
    response.fold((faliure) {
      print(faliure.message);
    }, (_) {
      locationModels.add(newLocationModel);
      // Update the UI
      Get.find<RequestTypeController>()
          .setLocationAvalibalityFromLocationController();

      // Add the location to the list of locations without filter
      locationModelsWithoutFilter.add(newLocationModel);
    });

    // Hide the loading indicator
    hideLoadingIndicator();

    // Show a dialog with a success message
    GetDialogHelper.generalDialog(
        barrierDismissible: false,
        context: context,
        child: DefaultDialog(
          width: 343.w,
          lottieAsset: AppAssets.successful,
          title: 'Successful'.tr,
          subTitle: 'You Successfully Added Location!'.tr,
        ));

    // Reset the data
    resetLocationDetails();
    // Update the UI
    update([AppConstanst.location]);
  }

  launchLink(String link) async {
    if (await canLaunchUrl(Uri.parse(link))) {
      await launchUrl(Uri.parse(link), mode: LaunchMode.externalApplication);
    } else {
      Fluttertoast.showToast(
        msg: 'Could not open the map.'.tr,
        backgroundColor: AppColors.primary,
        textColor: AppColors.textButton,
      );
    }
  }

  /// Toggles the geofence allowance for a specific location or globally.
  void updateAllowenceGeofence([int? index]) {
    if (index != null) {
      locationModels[index].allowGeofence =
          !locationModels[index].allowGeofence;
      update([AppConstanst.location]);
    } else {
      allowGeofence = !allowGeofence;
      if (!allowGeofence) {
        // geoFencingAreaController.text = '0';
        // geoFencingPerimeterController.text = '0';
      }
      update([AppConstanst.locationDialog]);
    }
  }

  /// Toggles the pause allowance for a specific location or globally.
  void updateAllowPause([int? index]) async {
    if (index != null) {
      locationModels[index].allowPause = !locationModels[index].allowPause;

      final response = await locationRepo.editLocation(locationModels[index]);
      response.fold((faliure) {
        print(faliure.message);
      }, (_) {});
    } else {
      allowPause = !allowPause;
    }
    update([AppConstanst.locationDialog]);
    update([AppConstanst.location]);

    update();
  }

  /// Toggles the breaks allowance in attendance for a specific location or globally.
  ///
  /// If an [index] is provided, it will toggle the `allowBreaksInAttendance`
  /// property for the specified location in the [locationModels] list and
  /// update the Firestore database with the new state. The UI is then
  /// updated to reflect this change.
  ///
  /// If no [index] is provided, it toggles the global `allowBreaksInAttendance`
  /// state. If breaks are disallowed globally, it resets the `allowPeriodController`
  /// to '0'. The UI is updated to reflect the global change.
  void updateAllowBreaks([int? index]) async {
    if (index != null) {
      locationModels[index].allowBreaksInAttendance =
          !locationModels[index].allowBreaksInAttendance;

      final response = await locationRepo.editLocation(locationModels[index]);
      response.fold((faliure) {
        print(faliure.message);
      }, (_) {});
    } else {
      allowBreaksInAttendance = !allowBreaksInAttendance;
      if (!allowBreaksInAttendance) {
        allowPeriodController.text = '0';
      }
    }
    update([AppConstanst.locationDialog]);
    update([AppConstanst.location]);

    update();
  }

  /// Deletes a location by marking its status as "deleted" and removing it from the list.
  Future<void> deleteLocation(int index) async {
    showLoadingIndicator();
    Get.until(
      (route) => route.isFirst,
    );
    locationModels[index].status = AppConstanst.deleted;

    final response = await locationRepo.editLocation(locationModels[index]);
    response.fold((faliure) {
      print(faliure.message);
    }, (_) {
      locationModels.removeAt(index);
      Get.find<RequestTypeController>()
          .setLocationAvalibalityFromLocationController();
    });
    hideLoadingIndicator();
    update([AppConstanst.location]);
  }

  int? editingLocationIndex;

  /// Checks if all the required fields are filled in and valid.
  bool isValid() {
    if (googleMapsLinkController.text.isEmpty ||
        (locationNameEnglishController.text.isEmpty ||
            ValidationHelper.isEnglish(locationNameEnglishController.text) !=
                null) ||
        (locationNameArabicController.text.isEmpty ||
            ValidationHelper.isArabic(locationNameArabicController.text) !=
                null) ||
        latitudeController.text.isEmpty ||
        longitudeController.text.isEmpty ||
        stateOrProvinceController.text.isEmpty ||
        countryController.text.isEmpty ||
        postalCodeController.text.isEmpty ||
        cityController.text.isEmpty ||
        (allowBreaksInAttendance && allowPeriodController.text.isEmpty) ||
        (allowGeofence &&
            (geoFencingAreaController.text.isEmpty ||
                geoFencingPerimeterController.text.isEmpty))) {
      return false;
    }
    return true;
  }

  /// Edits an existing location in the Firestore database.
  /// This method updates the location details using the information
  /// from the controllers and saves the changes to the database.
  /// It also updates the list of locations in the controller and
  /// refreshes the UI.
  Future<void> editLocation(int index) async {
    if (index != -1) {
      editingLocationIndex = index;
    }
    showLoadingIndicator();

    // Determine if the allow period is applicable
    bool hasAllowPeriod = false;
    if (selectedPeriodType != null &&
        allowBreaksInAttendance == true &&
        allowPeriodController.text.isNotEmpty) {
      hasAllowPeriod = true;
    }

    // Create a new location model with updated data
    LocationModel newLocationModel = LocationModel(
      // Address details
      address: Address(
        city: cityController.text,
        country: countryController.text,
        postalCode: postalCodeController.text,
        stateOrProvince: stateOrProvinceController.text,
        cityArabic: cityArabicController.text,
        stateOrProvinceArabic: stateOrProvinceArabicController.text,
        countryArabic: countryArabicController.text,
      ),
      // Unique identifier
      id: locationModels[editingLocationIndex!].id,
      // Location names
      locationNameEnglish: locationNameEnglishController.text,
      locationNameArabic: locationNameArabicController.text,
      // Geofencing allowance
      allowGeofence: allowGeofence,
      // Google Maps link
      googleMapsLink: googleMapsLinkController.text.isNotEmpty
          ? googleMapsLinkController.text
          : 'https://www.google.com/maps/search/?api=1&query=${double.tryParse(latitudeController.text)},${double.tryParse(latitudeController.text)}',
      // Geographic coordinates
      latitude: double.tryParse(latitudeController.text) ?? 30.0500,
      longitude: double.tryParse(longitudeController.text) ?? 31.2333,
      // Geofencing dimensions
      geoFencingPerimeter:
          int.tryParse(geoFencingPerimeterController.text) ?? 150,
      geoFencingArea: int.tryParse(geoFencingAreaController.text) ?? 150,
      // Location accuracy
      // locationAccuracy: selectedAccuracyType != null
      //     ? selectedAccuracyType == LocationAccuracy2.high.getName
      //         ? LocationAccuracy2.high
      //         : selectedAccuracyType == LocationAccuracy2.medium.getName
      //             ? LocationAccuracy2.medium
      //             : LocationAccuracy2.low
      //     : LocationAccuracy2.low,
      // Attendance allowances
      allowBreaksInAttendance: allowBreaksInAttendance,
      allowPause: allowPause,
      // Geofencing points
      polygonPoints: polygonPoints,
      // Allow period time settings
      allowPeriodTime: hasAllowPeriod
          ? selectedPeriodType! == AllowPeriodTime.mins.getName
              ? AllowPeriodTime.mins
              : AllowPeriodTime.hours
          : null,
      allowPeriodTimeNumber:
          hasAllowPeriod ? int.tryParse(allowPeriodController.text) : null,
      // Current status
      status: locationModels[editingLocationIndex!].status,
    );

    // Update the Firestore database with new location data
    final response = await locationRepo.editLocation(newLocationModel);
    response.fold((faliure) {
      print(faliure.message);
    }, (_) {
      // Update location list and related controller
      locationModels[editingLocationIndex!] = newLocationModel;
      Get.find<RequestTypeController>()
          .setLocationAvalibalityFromLocationController();
      editingLocationIndex = null;
    });

    hideLoadingIndicator();
    update([AppConstanst.location]); // Refresh the UI
  }

  /// Sets the edit location data from the given index in the location list
  void setEditLocationData(int index) {
    editingLocationIndex = index;
    allowGeofence = locationModels[index].allowGeofence;
    allowPause = locationModels[index].allowPause;
    allowBreaksInAttendance = locationModels[index].allowBreaksInAttendance;

    geoFencingPerimeterController.text =
        locationModels[index].geoFencingPerimeter.toString();

    geoFencingAreaController.text =
        locationModels[index].geoFencingArea.toString();
    latitudeController.text = locationModels[index].latitude.toString();
    longitudeController.text = locationModels[index].longitude.toString();
    googleMapsLinkController.text = locationModels[index].googleMapsLink;
    cityController.text = locationModels[index].address.city;
    countryController.text = locationModels[index].address.country;
    stateOrProvinceController.text =
        locationModels[index].address.stateOrProvince;
    cityArabicController.text = locationModels[index].address.cityArabic;
    stateOrProvinceArabicController.text =
        locationModels[index].address.stateOrProvinceArabic;
    countryArabicController.text = locationModels[index].address.countryArabic;
    postalCodeController.text = locationModels[index].address.postalCode;

    locationNameEnglishController.text =
        locationModels[index].locationNameEnglish;
    locationNameArabicController.text =
        locationModels[index].locationNameArabic;
    allowPeriodController.text =
        locationModels[index].allowPeriodTimeNumber != null
            ? locationModels[index].allowPeriodTimeNumber.toString()
            : '';
    selectedPeriodType = locationModels[index].allowPeriodTime != null
        ? locationModels[index].allowPeriodTime == AllowPeriodTime.mins
            ? AllowPeriodTime.mins.getName
            : AllowPeriodTime.hours.getName
        : null;
    polygonPoints = locationModels[index].polygonPoints;

    // selectedAccuracyType = locationModels[index].locationAccuracy.getName;
    Get.find<EditGeofencingController>().editGeofencingMarker(
        locationModels[index].polygonPoints,
        locationModels[index].latitude,
        locationModels[index].longitude);
  }

  void resetLocationDetails() {
    locationNameEnglishController.clear();
    locationNameArabicController.clear();

    googleMapsLinkController.clear();
    latitudeController.clear();
    longitudeController.clear();
    countryController.clear();
    geoFencingPerimeterController.clear();
    geoFencingAreaController.clear();
    postalCodeController.clear();
    cityController.clear();
    stateOrProvinceController.clear();
    allowPeriodController.clear();
    cityArabicController.clear();
    stateOrProvinceArabicController.clear();
    countryArabicController.clear();
    allowBreaksInAttendance = true;
    allowPause = true;
    allowGeofence = false;
    // allowPeriod = false;
  }

  bool isGettingLocations = false;

  /// GET All Locations
  Future<void> getAllLocations() async {
    isGettingLocations = true;
    final response = await locationRepo.getAllLocations();
    response.fold((faliure) {
      isGettingLocations = false;
      print(faliure.message);
    }, (dataList) {
      isGettingLocations = false;
      locationModelsWithoutFilter = dataList;
      locationModels = dataList;
      Get.find<RequestTypeController>()
          .setLocationAvalibalityFromLocationController();
      update([AppConstanst.location]);
    });
  }

  /// Search Location
  void searchLocation(String query) {
    locationModels = locationModelsWithoutFilter.where((element) {
      return element.locationNameEnglish
              .toLowerCase()
              .contains(query.toLowerCase()) ||
          element.locationNameArabic
              .toLowerCase()
              .contains(query.toLowerCase());
    }).toList();
    update([AppConstanst.location]);
  }

  @override
  void onInit() {
    super.onInit();
    // _initializeLocationStream();

    getAllLocations().then((_) {
      print("vvvvv");
    });

    locationNameEnglishController.addListener(() {
      update([AppConstanst.locationDialog]);
    });
    googleMapsLinkController.addListener(() {
      update([AppConstanst.locationDialog]);
    });
    locationNameArabicController.addListener(() {
      update([AppConstanst.locationDialog]);
    });
    geoFencingPerimeterController.addListener(() {
      update([AppConstanst.locationDialog]);
    });
    latitudeController.addListener(() {
      update([AppConstanst.locationDialog]);
    });
    longitudeController.addListener(() {
      update([AppConstanst.locationDialog]);
    });
    postalCodeController.addListener(() {
      update([AppConstanst.locationDialog]);
    });
    cityController.addListener(() {
      update([AppConstanst.locationDialog]);
    });
    countryController.addListener(() {
      update([AppConstanst.locationDialog]);
    });
    stateOrProvinceController.addListener(() {
      update([AppConstanst.locationDialog]);
    });
    geoFencingAreaController.addListener(() {
      update([AppConstanst.locationDialog]);
    });
    allowPeriodController.addListener(() {
      update([AppConstanst.locationDialog]);
    });
  }
}
