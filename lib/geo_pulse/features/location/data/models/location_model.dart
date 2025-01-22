// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/constants/enums.dart';
import 'package:geo_pulse/geo_pulse/features/users/models/user_model.dart';
import 'address_model.dart';

class LocationModel {
  // Static constants for field keys
  static const String fieldId = 'Id';
  static const String fieldAddress = 'Address';
  static const String fieldLocationNameEnglish = 'Location_Name_English';
  static const String fieldLocationNameArabic = 'Location_Name_Arabic';
  static const String fieldGoogleMapsLink = 'Google_Maps_Link';
  static const String fieldLatitude = 'Latitude';
  static const String fieldLongitude = 'Longitude';
  static const String fieldLocationAccuracy = 'Location_Accuracy';
  static const String fieldAllowBreaksInAttendance =
      'Allow_Breaks_In_Attendance';
  static const String fieldAllowPause = 'Allow_Pause';
  static const String fieldAllowPeriodTimeNumber = 'Allow_Period_Time_Number';
  static const String fieldAllowPeriodTime = 'Allow_Period_Time';
  static const String fieldPolygonPoints = 'Polygon_Points';
  static const String fieldAllowGeofence = 'Allow_Geofence';
  static const String fieldGeoFencingArea = 'GeoFencing_Area';
  static const String fieldGeoFencingPerimeter = 'GeoFencing_Perimeter';
  static const String fieldStatus = 'Status';

  // Model fields
  String id;
  String locationNameEnglish;
  String locationNameArabic;
  String googleMapsLink;
  double latitude;
  double longitude;
  int geoFencingPerimeter;
  int geoFencingArea;
  // LocationAccuracy2 locationAccuracy;
  bool allowBreaksInAttendance;
  bool allowPause;
  bool allowGeofence;
  int? allowPeriodTimeNumber;
  AllowPeriodTime? allowPeriodTime;
  late List<UserModel> employees;
  Address address;
  List<LatLng> polygonPoints;
  String status;

  // Constructor
  LocationModel({
    required this.id,
    required this.locationNameEnglish,
    required this.locationNameArabic,
    required this.address,
    required this.googleMapsLink,
    required this.latitude,
    required this.longitude,
    required this.geoFencingPerimeter,
    required this.geoFencingArea,
    // required this.locationAccuracy,
    required this.allowBreaksInAttendance,
    required this.allowPause,
    required this.polygonPoints,
    required this.status,
    required this.allowGeofence,
    this.allowPeriodTimeNumber,
    this.allowPeriodTime,
  }) {
    employees = [];
  }

  // To Map
  Map<String, dynamic> toMap() {
    return {
      fieldId: id,
      fieldAddress: address.toMap(),
      fieldLocationNameEnglish: locationNameEnglish.toLowerCase(),
      fieldLocationNameArabic: locationNameArabic.toLowerCase(),
      fieldGoogleMapsLink: googleMapsLink,
      fieldLatitude: latitude,
      fieldLongitude: longitude,
      // fieldLocationAccuracy: locationAccuracy.getName.toLowerCase(),
      fieldAllowBreaksInAttendance: allowBreaksInAttendance,
      fieldAllowPause: allowPause,
      fieldAllowPeriodTimeNumber: allowPeriodTimeNumber,
      fieldAllowPeriodTime: allowPeriodTime?.getName.toLowerCase(),
      fieldPolygonPoints: polygonPoints
          .map((point) =>
              {fieldLatitude: point.latitude, fieldLongitude: point.longitude})
          .toList(),
      fieldAllowGeofence: allowGeofence,
      fieldGeoFencingArea: geoFencingArea,
      fieldGeoFencingPerimeter: geoFencingPerimeter,
      fieldStatus: status,
    };
  }

  // From Map
  factory LocationModel.fromMap(Map<String, dynamic> map) {
    return LocationModel(
      id: map[fieldId],
      address: Address.fromMap(map[fieldAddress]),
      locationNameEnglish: map[fieldLocationNameEnglish].toString().capitalize!,
      locationNameArabic: map[fieldLocationNameArabic].toString().capitalize!,
      googleMapsLink: map[fieldGoogleMapsLink],
      latitude: map[fieldLatitude],
      longitude: map[fieldLongitude],
      // locationAccuracy: LocationAccuracy2.values.firstWhere((element) =>
      //     element.getName.toLowerCase() == map[fieldLocationAccuracy]),
      allowBreaksInAttendance: map[fieldAllowBreaksInAttendance],
      allowPause: map[fieldAllowPause],
      allowPeriodTimeNumber: map[fieldAllowPeriodTimeNumber],
      allowPeriodTime: map[fieldAllowPeriodTime] != null
          ? AllowPeriodTime.values.firstWhere((element) =>
              element.getName.toLowerCase() == map[fieldAllowPeriodTime])
          : null,
      polygonPoints: (map[fieldPolygonPoints] as List)
          .map((e) => LatLng(e[fieldLatitude], e[fieldLongitude]))
          .toList(),
      allowGeofence: map[fieldAllowGeofence],
      geoFencingArea: map[fieldGeoFencingArea],
      geoFencingPerimeter: map[fieldGeoFencingPerimeter],
      status: map[fieldStatus],
    );
  }
}
