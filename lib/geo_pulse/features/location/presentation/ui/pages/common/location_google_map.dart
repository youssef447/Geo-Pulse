import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../../../core/extensions/extensions.dart';

import '../../../../../../core/constants/app_assets.dart';
import '../../../../../../core/helpers/haptic_feedback_helper.dart';
import '../../../../../../core/helpers/spacing_helper.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_text_styles.dart';
import '../../../../../../core/widgets/buttons/app_default_button.dart';
import '../../../controller/controller/geofencing_controller.dart';

///A widget that displays a Google map and allows the user to select a location on the map.
class MapScreen extends StatelessWidget {
  const MapScreen({
    super.key,
    required this.isGeofencing,
  });

  final bool isGeofencing;

  //  final TextEditingController _controller = TextEditingController();
  // List<dynamic> _predictions = [];
  // Future<void> _onSearchChanged(String query) async {
  //   if (query.isNotEmpty) {
  //     final response = await http.get(
  //       Uri.parse(
  //           'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$query&key=AIzaSyC41Ny94YpIDfxvgq26EOXTbYmZrNXu5c0'),
  //     );
  //     final data = json.decode(response.body);
  //     setState(() {
  //       _predictions = data['predictions'];
  //     });
  //     _predictions.forEach( (element) {
  //       print("00000000000000");
  //       print(element['description']);
  //     });
  //   } else {
  //     setState(() {
  //       _predictions = [];
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    //Get.put(GeofencingController());
    return GetBuilder<GeofencingController>(
      builder: (controller) => Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      HapticFeedbackHelper.triggerHapticFeedback(
                        vibration: VibrateType.mediumImpact,
                        hapticFeedback: HapticFeedback.mediumImpact,
                      );
                      Navigator.of(context).pop();
                    },
                    child: SvgPicture.asset(
                      context.isArabic
                          ? AppAssets.arrowForward
                          : AppAssets.arrowBack,
                      color: AppColors.text,
                      width: 24.w,
                      height: 24.h,
                    ),
                  ),
                  horizontalSpace(8),
                  Text(
                    'Select Location'.tr,
                    style: AppTextStyles.font26BlackSemiBoldCairo,
                  ),
                  Spacer(),
                  IconButton(
                    onPressed: () {
                      controller.goToCurrentLocation();
                    },
                    icon: const Icon(
                      Icons.my_location,
                      color: Colors.black,
                      size: 26,
                    ),
                    splashRadius: 26,
                  ),
                ],
              ),
              // TextField(
              //   controller: _controller,
              //   decoration: InputDecoration(hintText: 'Search for a place'),
              //   onChanged: _onSearchChanged,
              // ),
              // Expanded(
              //   flex: 1,
              //   child: ListView.builder(
              //     itemCount: _predictions.length,
              //     itemBuilder: (context, index) {
              //       return ListTile(
              //         title: Text(_predictions[index]['description']),
              //         onTap: () {
              //           // Use place data for map or location update
              //         },
              //       );
              //     },
              //   ),
              // ),
              Expanded(
                //flex: 5,
                child: controller.isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : GoogleMap(
                        mapType: MapType.normal,
                        initialCameraPosition: isGeofencing
                            ? controller.currentCameraPositionGeofencing ??
                                controller.currentCameraPosition!
                            : controller.currentCameraPosition!,
                        polygons: isGeofencing ? controller.polygons : {},
                        markers: isGeofencing
                            ? controller.geofencingMarkers.isNotEmpty
                                ? controller.geofencingMarkers
                                : controller.loacationMarkers.isNotEmpty
                                    ? controller.loacationMarkers
                                    : {
                                        Marker(
                                          markerId: const MarkerId("999"),
                                          position: LatLng(
                                            controller.lat,
                                            controller.long,
                                          ),
                                        ),
                                      }
                            : controller.loacationMarkers.isNotEmpty
                                ? controller.loacationMarkers
                                : {
                                    Marker(
                                      markerId: const MarkerId("999"),
                                      position: LatLng(
                                        controller.lat,
                                        controller.long,
                                      ),
                                    ),
                                  },
                        onMapCreated:
                            (GoogleMapController googleMapcontroller) {
                          if (!controller.controller.isCompleted) {
                            controller.controller.complete(googleMapcontroller);
                          }
                        },
                        onTap: (latLng) {
                          if (isGeofencing) {
                            controller.setGeofencingMarker(latLng);
                          }
                          {
                            controller.addMarkers(latLng);
                          }
                        },
                      ),
              ),
              verticalSpace(16),
              AppDefaultButton(
                color: isGeofencing
                    ? controller.polygonPoints.length >= 3
                        ? AppColors.primary
                        : AppColors.whiteShadow
                    : AppColors.primary,
                text: 'Next'.tr,
                height: 40.h,
                width: double.infinity,
                style: AppTextStyles.font14BlackCairoMedium
                    .copyWith(color: AppColors.textButton),
                onPressed: () {
                  if (isGeofencing) {
                    if (controller.polygonPoints.length >= 3) {
                      controller.setGeofencingToFormFields(context);
                      Navigator.of(context).pop();
                    }
                  } else {
                    controller.setLatAndLongToFormFields();
                    Navigator.of(context).pop();
                  }
                },
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
