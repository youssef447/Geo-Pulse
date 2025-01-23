import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../../../../core/extensions/extensions.dart';
import '../../../../../../../../core/constants/strings.dart';
import '../../../../../../../../core/helpers/date_time_helper.dart';
import '../../../../../../../../core/helpers/spacing_helper.dart';
import '../../../../../../../../core/theme/app_colors.dart';
import '../../../../../../../../core/theme/app_text_styles.dart';
import '../../../../../controller/controller/location_controller.dart';

///tabbar body of location description in mobile
class MobileLocDescription extends GetView<LocationController> {
  final int index;
  const MobileLocDescription({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: GetBuilder<LocationController>(
          id: AppConstanst.location,
          builder: (controller) {
            return Align(
              alignment: Alignment.topCenter,
              child: Container(
                decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(8.r)),
                padding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 16.h,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _BuildLocationDesctiptionInfo(
                      label: '${'Location Name'.tr} :  \n',
                      value: context.isArabic
                          ? controller.locationModels[index].locationNameArabic
                          : controller
                              .locationModels[index].locationNameEnglish,
                    ),
                    verticalSpace(8),
                    _BuildLocationDesctiptionInfo(
                      label: '${'Address of the location'.tr} :  \n',
                      value: Get.locale.toString().contains('en')
                          ? '${controller.locationModels[index].address.city}, ${controller.locationModels[index].address.country}'
                          : '${controller.locationModels[index].address.cityArabic}, ${controller.locationModels[index].address.countryArabic}',
                      textHeight: 1,
                    ),
                    verticalSpace(8),
                    _BuildLocationDesctiptionInfo(
                      label: '${'Location at Google Maps'.tr} :  \n',
                      value: controller.locationModels[index].googleMapsLink,
                      textHeight: 1,
                      valueColor: AppColors.blue,
                    ),
                    verticalSpace(8),
                    _BuildLocationDesctiptionInfo(
                      label: '${'Coordinates'.tr} :  \n',
                      value:
                          '${DateTimeHelper.formatDouble(controller.locationModels[index].latitude)} , ${DateTimeHelper.formatDouble(controller.locationModels[index].longitude)}',
                    ),
                    verticalSpace(8),
                    _BuildLocationDesctiptionInfo(
                      label: '${'Geofencing Perimeter'.tr} :  \n',
                      value:
                          '${DateTimeHelper.formatInt(controller.locationModels[index].geoFencingPerimeter)} ${'M'.tr}',
                    ),
                    verticalSpace(8),
                    _BuildLocationDesctiptionInfo(
                      label: '${'Geofencing Area'.tr} :  \n',
                      value:
                          '${DateTimeHelper.formatInt(controller.locationModels[index].geoFencingArea)} ${'M'.tr}',
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }
}

class _BuildLocationDesctiptionInfo extends GetView<LocationController> {
  const _BuildLocationDesctiptionInfo({
    required this.label,
    required this.value,
    this.valueColor,
    this.textHeight,
  });

  final String label;
  final String value;
  final double? textHeight;
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
        textAlign: TextAlign.start,
        overflow: TextOverflow.ellipsis,
        maxLines: 4,
        text: TextSpan(
            text: label,
            style: AppTextStyles.font14SecondaryBlackCairo,
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
