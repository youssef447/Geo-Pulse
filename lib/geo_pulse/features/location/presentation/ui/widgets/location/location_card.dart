import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../../core/extensions/extensions.dart';

import '../../../../../../core/constants/strings.dart';
import '../../../../../../core/helpers/date_time_helper.dart';
import '../../../../../../core/helpers/spacing_helper.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_text_styles.dart';
import '../../../controller/controller/location_controller.dart';

/// by :  Mohamed Ashraf

/// A widget displaying detailed information about a location, including its name, address, coordinates, Google Maps link, and geofencing perimeter.

class LocationCard extends StatelessWidget {
  final int modelIndex;

  const LocationCard({
    super.key,
    required this.modelIndex,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LocationController>(
        id: AppConstanst.location,
        builder: (controller) {
          return Container(
            padding: EdgeInsetsDirectional.only(
              start: 16.w,
              bottom: 14.h,
              end: 16.w,
              top: 14.h,
            ),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                color: AppColors.card),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.isArabic
                      ? controller.locationModels[modelIndex].locationNameArabic
                      : controller
                          .locationModels[modelIndex].locationNameEnglish,
                  style: AppTextStyles.font16BlackMediumCairo,
                ),
                verticalSpace(16),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                      text: 'Address'.tr,
                      style: AppTextStyles.font14SecondaryBlackCairo,
                      children: [
                        const TextSpan(
                          text: '  ',
                        ),
                        TextSpan(
                          text: Get.locale.toString().contains('en')
                              ? '${controller.locationModels[modelIndex].address.city}, ${controller.locationModels[modelIndex].address.country}'
                              : '${controller.locationModels[modelIndex].address.cityArabic}, ${controller.locationModels[modelIndex].address.countryArabic}',
                          style: AppTextStyles.font14BlackCairoMedium,
                        )
                      ]),
                ),
                verticalSpace(8),
                RichText(
                  textAlign: TextAlign.start,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                      text: 'Google Maps'.tr,
                      style: AppTextStyles.font14SecondaryBlackCairo,
                      children: [
                        const TextSpan(
                          text: '  ',
                        ),
                        TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              controller.launchLink(
                                controller
                                    .locationModels[modelIndex].googleMapsLink,
                              );
                            },
                          text: controller
                              .locationModels[modelIndex].googleMapsLink,
                          style: AppTextStyles.font14BlackCairoMedium
                              .copyWith(color: AppColors.blue),
                        ),
                      ]),
                ),
                verticalSpace(8),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                      text: 'Coordinates'.tr,
                      style: AppTextStyles.font14SecondaryBlackCairo,
                      children: [
                        const TextSpan(
                          text: '  ',
                        ),
                        TextSpan(
                          text:
                              '${DateTimeHelper.formatDouble(controller.locationModels[modelIndex].latitude)} , ${DateTimeHelper.formatDouble(controller.locationModels[modelIndex].longitude)}',
                          style: AppTextStyles.font14BlackCairoMedium,
                        )
                      ]),
                ),
                verticalSpace(8),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                      text: 'Geofencing'.tr,
                      style: AppTextStyles.font14SecondaryBlackCairo,
                      children: [
                        const TextSpan(
                          text: '  ',
                        ),
                        TextSpan(
                          text: DateTimeHelper.formatInt(controller
                              .locationModels[modelIndex].geoFencingPerimeter),
                          style: AppTextStyles.font14BlackCairoMedium,
                        )
                      ]),
                ),
              ],
            ),
          );
        });
  }
}
