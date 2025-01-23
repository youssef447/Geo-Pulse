import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../../../../core/extensions/extensions.dart';

import '../../../../../../../../core/constants/strings.dart';
import '../../../../../../../../core/helpers/date_time_helper.dart';
import '../../../../../../../../core/theme/app_colors.dart';
import '../../../../../../../../core/theme/app_text_styles.dart';
import '../../../../../controller/controller/location_controller.dart';

class TabletLocDescription extends GetView<LocationController> {
  final int index;
  const TabletLocDescription({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LocationController>(
        id: AppConstanst.location,
        builder: (controller) {
          return Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: 267.h,
              decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(8.r)),
              padding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 16.h,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LabelDescriptionInfo(
                    label: '${'Location Name'.tr}  ',
                    value: context.isArabic
                        ? controller.locationModels[index].locationNameArabic
                        : controller.locationModels[index].locationNameEnglish,
                  ),
                  LabelDescriptionInfo(
                    label: '${'Address of the location'.tr}  ',
                    value: Get.locale.toString().contains('en')
                        ? '${controller.locationModels[index].address.city}, ${controller.locationModels[index].address.country}'
                        : '${controller.locationModels[index].address.cityArabic}, ${controller.locationModels[index].address.countryArabic}',
                  ),
                  LabelDescriptionInfo(
                    label: '${'Location at Google Maps'.tr}  ',
                    value: controller.locationModels[index].googleMapsLink,
                    valueColor: AppColors.blue,
                  ),
                  LabelDescriptionInfo(
                    label: '${'Coordinates'.tr}  ',
                    value:
                        '${DateTimeHelper.formatDouble(controller.locationModels[index].latitude)} , ${DateTimeHelper.formatDouble(controller.locationModels[index].longitude)}',
                  ),
                  Row(
                    children: [
                      LabelDescriptionInfo(
                        label: '${'Geofencing Perimeter'.tr}  ',
                        value:
                            '${DateTimeHelper.formatInt(controller.locationModels[index].geoFencingPerimeter)} ${'M'.tr}',
                      ),
                      const Spacer(),
                      LabelDescriptionInfo(
                        label: '${'Geofencing Area'.tr}  ',
                        value:
                            '${DateTimeHelper.formatInt(controller.locationModels[index].geoFencingArea)} ${'M'.tr}',
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }
}

class LabelDescriptionInfo extends GetView<LocationController> {
  const LabelDescriptionInfo({
    super.key,
    required this.label,
    required this.value,
    this.valueColor,
  });

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (valueColor != null) {
          controller.launchLink(value);
        }
      },
      child: RichText(
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        text: TextSpan(
            text: label,
            style: AppTextStyles.font18SecondaryBlackRegularCairo,
            children: [
              TextSpan(
                text: value,
                style: AppTextStyles.font18BlackCairoRegular.copyWith(
                  color: valueColor,
                ),
              ),
            ]),
      ),
    );
  }
}
