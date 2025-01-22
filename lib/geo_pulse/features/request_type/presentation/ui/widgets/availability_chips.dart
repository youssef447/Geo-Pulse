import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../core/extensions/extensions.dart';

import '../../../../../core/constants/strings.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../location/presentation/controller/controller/location_controller.dart';
import '../../controller/request_types_controller.dart';

/// Objectives: This file is responsible for providing the availability chips widget used when adding or editing a request type.
class AvailabilityChips extends GetView<RequestTypeController> {
  const AvailabilityChips({
    super.key,
    required this.isAddingNewRequestType,
  });

  final bool isAddingNewRequestType;

  @override
  Widget build(BuildContext context) {
    var isTablet = context.isTablett;

    return controller.selectedRequestType!.availability.isNotEmpty
        ? controller.selectedRequestType!.availability
                .contains(AppConstanst.all)
            ? SizedBox(
                height: 40.h,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount:
                      Get.find<LocationController>().locationModels.length,
                  itemBuilder: (context, index) {
                    final item =
                        Get.find<LocationController>().locationModels[index];

                    return Padding(
                      padding: EdgeInsetsDirectional.only(
                        top: isAddingNewRequestType ? 8.h : 0,
                        end: 8.w,
                      ),
                      child: Chip(
                        label: Text(
                          Get.locale.toString().contains('en')
                              ? item.locationNameEnglish.capitalize!
                              : item.locationNameArabic,
                          style: isTablet
                              ? AppTextStyles.font16BlackMediumCairo
                              : AppTextStyles.font14BlackCairoMedium,
                        ),
                        backgroundColor: AppColors.field,
                        side: const BorderSide(
                          color: Colors.transparent,
                        ),
                        deleteIcon: isAddingNewRequestType
                            ? Icon(
                                Icons.close,
                                color: AppColors.icon,
                                size: 16.r,
                              )
                            : null,
                        onDeleted: isAddingNewRequestType
                            ? () {
                                //controller.removeLocation(item);
                              }
                            : null,
                      ),
                    );
                  },
                ))
            : SizedBox(
                height: 40.h,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount:
                      controller.selectedRequestType!.availability.length,
                  itemBuilder: (context, index) {
                    final item =
                        controller.selectedRequestType!.availability[index];
                    if (item == AppConstanst.all) {
                      return const SizedBox();
                    }
                    return Padding(
                      padding: EdgeInsetsDirectional.only(
                        top: isAddingNewRequestType ? 8.h : 0,
                        end: 8.w,
                      ),
                      child: Chip(
                        label: Text(
                          controller.getLocationName(item) ?? "",
                          style: isTablet
                              ? AppTextStyles.font16BlackMediumCairo
                              : AppTextStyles.font14BlackCairoMedium,
                        ),
                        backgroundColor: AppColors.field,
                        side: const BorderSide(
                          color: Colors.transparent,
                        ),
                        deleteIcon: isAddingNewRequestType
                            ? Icon(
                                Icons.close,
                                color: AppColors.icon,
                                size: 16.r,
                              )
                            : null,
                        onDeleted: isAddingNewRequestType
                            ? () {
                                controller.removeLocation(item);
                              }
                            : null,
                      ),
                    );
                  },
                ))
        : !isAddingNewRequestType
            ? Chip(
                label: Text(
                  'No Available Locations Were Added'.tr,
                  style: isTablet
                      ? AppTextStyles.font16BlackMediumCairo
                      : AppTextStyles.font14BlackCairoMedium,
                ),
                backgroundColor: AppColors.field,
                side: const BorderSide(
                  color: Colors.transparent,
                ),
              )
            : const SizedBox();
  }
}
