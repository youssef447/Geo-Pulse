import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import '../../../../../../core/extensions/extensions.dart';

import '../../../../../../core/constants/app_assets.dart';
import '../../../../../../core/helpers/haptic_feedback_helper.dart';
import '../../../../../../core/helpers/spacing_helper.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_text_styles.dart';
import '../../../../../../core/widgets/buttons/app_default_button.dart';
import '../../../controller/controller/edit_geofencing_controller.dart';

///Represents the Edit Geofencing screen.
class MapEditScreen extends StatelessWidget {
  const MapEditScreen({
    super.key,
    this.isGeofencing,
  });
  final isGeofencing;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EditGeofencingController>(
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
              Expanded(
                child: controller.isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : GoogleMap(
                        mapType: MapType.normal,
                        initialCameraPosition: isGeofencing
                            ? controller.currentCameraPositionGeofencing!
                            : controller.currentCameraPosition!,
                        polygons: isGeofencing ? controller.polygons : {},
                        markers: isGeofencing
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
                      print(controller.polygonPoints);
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
