import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geo_pulse/geo_pulse/core/extensions/extensions.dart';
import 'package:geo_pulse/geo_pulse/core/helpers/toast_helper.dart';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geocode/geocode.dart' as geo;

import 'package:latlong2/latlong.dart' as latLng;
import '../../../../../features/home/domain/checkIn_repo.dart';

import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/constants/enums.dart';
import '../../../../../core/constants/strings.dart';
import '../../../../../core/helpers/date_time_helper.dart';
import '../../../../../core/helpers/get_dialog_helper.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/dialog/default_dialog.dart';
import '../../../../attendance/presentation/controller/controller/attendance_controller.dart';
import '../../../../attendance/data/models/attendance_data_model.dart';

import '../../../../users/logic/add_employee_controller.dart';
import '../../../../location/presentation/controller/controller/location_controller.dart';
import '../../../data/models/tracking_model.dart';
import '../../ui/widgets/dialogs/check_in/check_in_dialog.dart';

/// This class is the controller for the CheckIn Card Which is in home page.
class CheckInController extends GetxController
    with GetTickerProviderStateMixin {
  final CheckInRepo checkInRepo;

  CheckInController({required this.checkInRepo});

  // ********** Current Location **********
  late final currentLocationAddress =
      TextEditingController(text: 'Your current location'.tr);

  late final GlobalKey<FormState> formKeyCurrentLocation =
      GlobalKey<FormState>();

  // ****** Should get it from backend where is the current company location ******
  late final companyLocationAddress =
      TextEditingController(text: '12 Nasr City, Cairo, Egypt'.tr);

  /// Checks if the current location is within the company location polygon
  /// using the even-odd rule algorithm.
  ///
  /// The algorithm checks if the current location is on an edge of the polygon
  /// or if it intersects with any edge of the polygon. If the number of
  /// intersections is odd, then the point is inside the polygon.
  ///
  /// The algorithm uses the company location polygon points from the
  /// [LocationController] and the current location from the
  /// [CurrentLocationController].
  ///
  /// Returns true if the current location is within the company location
  /// polygon, false otherwise.
  bool checkIfValidLocation() {
    int intersections = 0;

    List<LatLng> polygon =
        Get.find<LocationController>().locationModels[0].polygonPoints;
    LatLng point =
        LatLng(currentLocation!.latitude, currentLocation!.longitude);

    int vertexCount = polygon.length;
    double tolerance = 1e-6; // Tolerance for edge check

    for (int i = 0; i < vertexCount; i++) {
      LatLng vertex1 = polygon[i];
      LatLng vertex2 = polygon[(i + 1) % vertexCount];

      // Check if the point is exactly on a vertex
      if ((point.latitude - vertex1.latitude).abs() < tolerance &&
          (point.longitude - vertex1.longitude).abs() < tolerance) {
        return true;
      }

      // Check if point is on the edge between two vertices
      if (isPointOnLineSegment(point, vertex1, vertex2, tolerance)) {
        return true;
      }

      // Ray-casting algorithm for inside-polygon check
      bool isWithinLatitudes = (point.latitude > vertex1.latitude) !=
          (point.latitude > vertex2.latitude);
      double slope = (vertex2.longitude - vertex1.longitude) *
              (point.latitude - vertex1.latitude) /
              (vertex2.latitude - vertex1.latitude) +
          vertex1.longitude;

      if (isWithinLatitudes && point.longitude < slope) {
        intersections++;
      }
    }

    return (intersections % 2) ==
        1; // Odd number of intersections means inside polygon
  }

  /// Checks if the given point is on the line segment defined by the start and end points.
  ///
  /// This method uses the cross product and dot product to determine if the point is
  /// on the line segment. If the cross product is not zero, the point is not on the
  /// line. If the dot product is less than zero, the point is before the start point.
  /// If the dot product is greater than the squared length of the line segment, the
  /// point is after the end point.
  ///
  /// The tolerance parameter is used to determine if the point is close enough to the
  /// line segment to be considered on it.
  ///
  /// Returns true if the point is on the line segment, false otherwise.
  bool isPointOnLineSegment(
      LatLng point, LatLng start, LatLng end, double tolerance) {
    double crossProduct = (point.latitude - start.latitude) *
            (end.longitude - start.longitude) -
        (point.longitude - start.longitude) * (end.latitude - start.latitude);

    if (crossProduct.abs() > tolerance) {
      return false;
    }

    double dotProduct = (point.latitude - start.latitude) *
            (end.latitude - start.latitude) +
        (point.longitude - start.longitude) * (end.longitude - start.longitude);

    if (dotProduct < 0) {
      return false;
    }

    double squaredLengthBA = pow(end.latitude - start.latitude, 2) +
        pow(end.longitude - start.longitude, 2).toDouble();
    if (dotProduct > squaredLengthBA) {
      return false;
    }

    return true;
  }

  /// Submits the current location to check if it matches the company location.
  ///
  /// First, it checks if the current location is not empty and valid.
  /// If valid, it then checks if the current location is the same as the
  /// company location using the [checkIfValidLocation] method.
  ///
  /// If the current location does not match the company location, it shows
  /// a dialog with the city, state, and country of the company location
  /// and asks the user to check in at that location.
  ///
  /// If the current location matches the company location, it shows a
  /// success dialog and then checks in and starts the stopwatch using
  /// the [toggleCheckIn] and [startStopwatch] methods.
  void submitCurrentLocation(BuildContext context) {
    Navigator.of(context).pop();
    checkInTime = Timestamp.now();
    // check if current location not empty first
    //if (formKeyCurrentLocation.currentState!.validate()) {
    // then check if the current location is the same as the company location
    var valid = checkIfValidLocation();

    // if not valid show dialog

    if (valid) {
      // if valid show success dialog
      GetDialogHelper.generalDialog(
        barrierDismissible: false,
        child: DefaultDialog(
          autoClose: true,
          width: context.isTablett ? 411.w : 343.w,
          lottieAsset: AppAssets.successful,
          title: 'Confirmed'.tr,
          subTitle: 'Your location matches the company\'s location.'.tr,
        ),
        context: context,
      );

      // then check in and start stopwatch
      toggleCheckIn();
      startStopwatch();
    } else {
      String city = !context.isArabic
          ? Get.find<LocationController>().locationModels[0].address.city
          : Get.find<LocationController>().locationModels[0].address.cityArabic;
      String state = !context.isArabic
          ? Get.find<LocationController>()
              .locationModels[0]
              .address
              .stateOrProvince
          : Get.find<LocationController>()
              .locationModels[0]
              .address
              .stateOrProvinceArabic;
      String country = !context.isArabic
          ? Get.find<LocationController>().locationModels[0].address.country
          : Get.find<LocationController>()
              .locationModels[0]
              .address
              .countryArabic;

      GetDialogHelper.generalDialog(
        barrierDismissible: true,
        child: DefaultDialog(
            autoClose: false,
            width: context.isTablett ? 411.w : 343.w,
            lottieAsset: AppAssets.location,
            title: 'Wrong Location'.tr,
            subTitle:
                '${'Your determined location is'.tr} $city, $state, $country. \n${'Please check in at this location and make sure to be there precisely.'.tr}'),
        context: context,
      );
    }
  }

  /// Retrieves the address for a given geographical point.

  Future<String> getAddress(latLng.LatLng point) async {
    try {
      if (!Get.context!.isArabic) {
        await setLocaleIdentifier('en');
      } else {
        await setLocaleIdentifier('ar');
      }
      List<Placemark> placeMark = await placemarkFromCoordinates(
        point.latitude,
        point.longitude,
      );

      String country = placeMark[0].country!;
      String state = placeMark[0].administrativeArea!;
      String city = placeMark[0].locality!;

      return "$city, $state, $country";
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> getWindowsAddress(latLng.LatLng point) async {
    try {
      final address = await geo.GeoCode().reverseGeocoding(
        latitude: point.latitude,
        longitude: point.longitude,
      );

      String country = address.countryName!;
      String state = address.streetAddress!;
      String city = address.city!;

      return "$city, $state, $country";
    } catch (e) {
      return e.toString();
    }
  }

  Position? currentLocation;

  getCurrentLocation(context) async {
    bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!isLocationServiceEnabled) {
      FlutterToastHelper.showToast(
        msg: 'Please enable location services!'.tr,
        backgroundColor: AppColors.secondaryPrimary,
      );

      return;
    }

    final permission = await Permission.location.request();

    if (permission.isGranted) {
      currentLocation = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(accuracy: LocationAccuracy.high),
      );

      if (currentLocation != null) {
        late String address;
        if (Platform.isAndroid || Platform.isIOS) {
          address = await getAddress(
            latLng.LatLng(
              currentLocation!.latitude,
              currentLocation!.longitude,
            ),
          );
        } else {
          address = await getWindowsAddress(
            latLng.LatLng(
              currentLocation!.latitude,
              currentLocation!.longitude,
            ),
          );
        }

        currentLocationAddress.text = address;

        GetDialogHelper.generalDialog(
          child: const CheckInDialog(),
          context: context,
        );
      }
    } else {
      FlutterToastHelper.showToast(
        msg:
            'Please enable location to check in with your current location!'.tr,
        backgroundColor: AppColors.secondaryPrimary,
      );
    }
  }

  /// Resets the current location address to an empty string and updates the AppConstanst.checkInDialog section of the UI.
  void eraseCurrentLocation() {
    currentLocationAddress.text = '';
    update([AppConstanst.checkInDialog]);
  }

  // ************************************* Check IN header *************************************
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Timer? timer;

  // Variables
  var showHeader = true;
  var checkIn = false;
  var tookBreak = false;

  var isRunning = false.obs;
  var isPaused = false.obs;
  var isCheckOut = false.obs;
  var currentDuration = 0.obs;

  Timestamp checkInTime = Timestamp.now();
  late DateTime checkOutTime;
  DateTime? lastPausedTime;
  int totalPausedDuration = 0;

  TimeOfDay eightThirtyAM = const TimeOfDay(hour: 8, minute: 30);

  /// Toggles the state of the `tookBreak` variable.
  ///
  /// This function switches the `tookBreak` variable between true and false, effectively indicating whether a break was taken.
  /// It updates the Firestore document for the current employee with the new break status.
  /// Additionally, it triggers an update for the 'checkOutDialog' UI component.
  Future<void> toggleTookBreak() async {
    tookBreak = !tookBreak;
    await checkInRepo.toggleTookBreak(
        Get.find<UserController>().employee!.email, tookBreak);

    update([AppConstanst.checkOutDialog]);
  }

  /// Toggles the state of the `showHeader` variable.

  void toggleShowHeader() {
    showHeader = !showHeader;
    update();
  }

  /// Toggles the state of the `checkIn` variable.

  void toggleCheckIn() {
    checkIn = !checkIn;
    update();
  }

  /// Updates the check-in status of the user and triggers a UI update.

  void updateChecking(value) {
    checkIn = value;
    update();
  }

  /// Loads the state of the user from Firestore.
  ///
  /// This function checks if there is a Firestore document for the current employee,
  /// and if so, loads the state from the document.
  /// If there is no document, it creates a new one with the default values.
  /// It also checks if the timer was running and if so, updates the current duration.
  /// If the timer was paused, it updates the total paused duration.
  Future<void> loadState() async {
    final response = await checkInRepo.loadState(
      "youssef.ashraf380@gmail.com",
    );
    response.fold((failure) {
      print(failure.message);
    }, (trackModel) {
      if (trackModel?.checkIn != null) {
        // Load the state from the document

        checkIn = trackModel?.checkIn ?? false;
        updateChecking(checkIn);
        tookBreak = trackModel?.tookBreak ?? false;
        isRunning.value = trackModel?.isRunning ?? false;
        isPaused.value = trackModel?.isPaused ?? false;
        currentDuration.value = trackModel?.currentDuration ?? 0;
        totalPausedDuration = trackModel?.totalPausedDuration ?? 0;

        if (trackModel?.checkInTime != null) {
          checkInTime = trackModel!.checkInTime!;
        } else {
          checkInTime = Timestamp.now();
        }

        // Check if the timer was running
        if (isRunning.value) {
          Duration elapsed = DateTime.now().difference(checkInTime.toDate());
          currentDuration.value = elapsed.inSeconds - totalPausedDuration;
          _startTimer();
        }
      } else {
        // Create a new document with the default values

        checkInTime = Timestamp.now();
        TrackingModel trackingModel = TrackingModel(
          checkIn: false,
          tookBreak: false,
          isRunning: false,
          isPaused: false,
          currentDuration: 0,
        );

        checkInRepo.startStopwatch(
            Get.find<UserController>().employee!.email, trackingModel);
      }
    });
  }

  /// Starts the stopwatch for tracking time.
  ///
  /// This function records the current time as the check-in time and resets
  /// the total paused duration. It updates the Firestore database with the
  /// check-in time and other related status flags. The timer is then started,
  /// and the `isRunning` and `isPaused` states are updated accordingly.
  void startStopwatch() {
    checkInTime = Timestamp.now();
    totalPausedDuration = 0; // Reset paused duration when starting

    TrackingModel trackingModel = TrackingModel(
      checkIn: checkIn,
      tookBreak: tookBreak,
      isRunning: true,
      isPaused: false,
      currentDuration: currentDuration.value,
      checkInTime: checkInTime,
      totalPausedDuration: totalPausedDuration,
    );
    checkInRepo.startStopwatch(
        Get.find<UserController>().employee!.email, trackingModel);

    _startTimer();
    isRunning.value = true;
    isPaused.value = false;
  }

  /// Periodically updates the Firestore database with the current duration
  /// since the timer was started. The update happens every 10 seconds to
  /// reduce I/O operations. The timer also increments the `currentDuration`
  /// variable by 1 second every second.
  void _startTimer() {
    int writeCounter = 0;
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      currentDuration.value++;
      writeCounter++;

      // Write to Firestore every 10 seconds to reduce I/O operations
      if (writeCounter >= 60) {
        checkInRepo.startTimer(
          Get.find<UserController>().employee!.email,
          currentDuration.value,
        );

        writeCounter = 0;
      }
    });
  }

  /// Pauses the stopwatch and updates the Firestore document with the pause time.
  ///
  /// This method is called when the user clicks the pause button. It stops the
  /// timer and updates the Firestore document with the pause time and the total
  /// paused duration. The `isRunning` and `isPaused` variables are also
  /// updated.
  ///
  /// If the stopwatch is not running, this method does nothing.
  Future<void> pauseStopwatch() async {
    if (isRunning.value) {
      timer?.cancel();
      isPaused.value = true;
      isRunning.value = false;
      lastPausedTime = DateTime.now(); // Capture the pause time
      await checkInRepo.pauseStopwatch(
          Get.find<UserController>().employee!.email,
          lastPausedTime!,
          totalPausedDuration);
    }
  }

  /// Resumes the stopwatch after a pause.
  ///
  /// If the stopwatch is paused, this method will resume it by calculating the
  /// paused duration and adding it to the total paused duration. It will then
  /// start the timer and update the Firestore document with the new state.
  /// The `isRunning` and `isPaused` states are updated accordingly. If the
  /// stopwatch is not paused, this method does nothing.
  Future<void> resumeStopwatch() async {
    if (isPaused.value) {
      // Calculate paused duration and add to totalPausedDuration
      if (lastPausedTime != null) {
        totalPausedDuration +=
            DateTime.now().difference(lastPausedTime!).inSeconds;
      }

      _startTimer();
      isRunning.value = true;
      isPaused.value = false;
      await checkInRepo.resumeStopwatch(
        Get.find<UserController>().employee!.email,
        totalPausedDuration,
      );
    }
  }

  /// Checks out of the attendance tracking system and records the attendance data.
  ///
  /// This method is called when the user clicks the check out button. It stops the
  /// timer and records the attendance data to the Firestore database. The
  /// data includes the date, status (late or present), oncoming time, leaving
  /// time, break time, and total time. The `isCheckOut` state is updated and the
  /// Firestore document is updated with the new values.
  Future<void> checkOut() async {
    timer?.cancel();
    checkOutTime = DateTime.now();
    isCheckOut.value = !isCheckOut.value;

    // Record attendance data t
    await Get.find<TrackingAttendanceController>().addAttendance(
      AttendanceDataModel(
        date: DateTime.now(),
        status: (checkInTime.toDate().hour > eightThirtyAM.hour ||
                (checkInTime.toDate().hour == eightThirtyAM.hour &&
                    checkInTime.toDate().minute >= eightThirtyAM.minute))
            ? AttendanceStatus.late
            : AttendanceStatus.present,
        oncomingTime: TimeOfDay(
          hour: checkInTime.toDate().hour,
          minute: checkInTime.toDate().minute,
        ),
        leavingTime: TimeOfDay(
          hour: checkOutTime.hour,
          minute: checkOutTime.minute,
        ),
        breakTime: tookBreak ? const Duration(minutes: 30) : Duration.zero,
        totalTime: Duration(
          seconds: currentDuration.value,
        ),
        attachments: [],
      ),
    );

    currentDuration.value = 0;
    isRunning.value = false;
    isPaused.value = false;
    final res = await checkInRepo.checkOut(
      Get.find<UserController>().employee!.email,
    );
    res.fold((l) {
      GetDialogHelper.generalDialog(
        child: DefaultDialog(
            lottieAsset: AppAssets.trash,
            title: 'Error',
            subTitle: 'Error in check out, please contact the support'),
        context: Get.context!,
      );
    }, (_) {
      GetDialogHelper.generalDialog(
        child: DefaultDialog(
          lottieAsset: AppAssets.successful,
          autoClose: true,
          title: 'Success',
          subTitle:
              'Your Shift Has Ended Successfully, Coming Time : ${DateTimeHelper.formatTime(checkInTime.toDate())} \n Leaving Time : ${DateTimeHelper.formatTime(checkOutTime)}',
        ),
        context: Get.context!,
      );
    });
  }

  RxBool formatTimer = false.obs;
  formatTime() {
    formatTimer.value = !formatTimer.value;
  }
}
