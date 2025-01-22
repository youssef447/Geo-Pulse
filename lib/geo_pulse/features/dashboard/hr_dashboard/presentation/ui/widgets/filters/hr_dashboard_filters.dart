// Objectives: This file is responsible for providing the HR dashboard filters widget.

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../../../core/extensions/extensions.dart';
import '../../../../../../users/logic/add_department_controller.dart';

import '../../../../../../../core/constants/strings.dart';
import '../../../../../../../core/helpers/spacing_helper.dart';
import '../../../../../../../core/theme/app_text_styles.dart';
import '../../../../../../request_type/presentation/controller/request_types_controller.dart';
import '../../../controller/tracking_hr_controller.dart';
import '../buildDropDown/build_drop_down.dart';

class HRDashboardFilters extends GetView<TrackingHRController> {
  HRDashboardFilters({super.key});
  final AddDepartmentController addDepartmentController = Get.find();
  @override
  Widget build(BuildContext context) {
    final isTablet = context.isTablett;

    return !controller.showData!
        ? const SizedBox()
        : GetBuilder<TrackingHRController>(
            id: AppConstanst.hrDashboardFilters,
            builder: (controller) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  buildDropDown(
                    context: context,
                    width: isTablet ? 200.w : null,
                    value: controller.selectedDepartmentFilter,
                    textButton: controller.departmentFilterName,
                    onPressed: (value) {
                      controller.setDepartmentFilter(value);
                    },
                    items: addDepartmentController.departmentModels
                        .map((e) => DropdownMenuItem(
                              alignment: AlignmentDirectional.centerStart,
                              value: e.departmentID.toString(),
                              child: buildMenuItem(Get.locale
                                      .toString()
                                      .contains('ar')
                                  ? e.departmentNameInArabic
                                  : addDepartmentController
                                      .containAbbreviation(e.departmentName!)),
                            ))
                        .toList(),
                    // DropdownMenuItem(
                    //   alignment: AlignmentDirectional.centerStart,
                    //   value: DepartmentFilter.employee,
                    //   child: buildMenuItem('Employee'.tr),
                    // ),
                    // DropdownMenuItem(
                    //   alignment: AlignmentDirectional.centerStart,
                    //   value: DepartmentFilter.manager,
                    //   child: buildMenuItem('Manager'.tr),
                    // ),
                    // DropdownMenuItem(
                    //   alignment: AlignmentDirectional.centerStart,
                    //   value: DepartmentFilter.hr,
                    //   child: buildMenuItem('HR'.tr),
                    // ),
                  ),
                  horizontalSpace(context.isTablett ? 16 : 8),
                  buildDropDown(
                    context: context,
                    width: isTablet ? 175.w : null,
                    value: controller.selectedLocationFilter,
                    textButton: controller.locationFilterName != 'Location'.tr
                        ? Get.find<RequestTypeController>().getLocationName(
                                controller.locationFilterName) ??
                            ""
                        : 'Location'.tr,
                    onPressed: (value) {
                      controller.setLocationFilter(value);
                    },
                    items: Get.find<RequestTypeController>()
                        .availabilityLocations
                        .keys
                        .map((e) {
                      return DropdownMenuItem(
                        alignment: AlignmentDirectional.centerStart,
                        value: e,
                        child: Text(
                          Get.find<RequestTypeController>()
                                  .getLocationName(e) ??
                              "",
                          style: AppTextStyles.font14SecondaryBlackCairo,
                        ),
                      );
                    }).toList(),
                  ),
                ],
              );
            });
  }

  buildLocationMenuItem(text) {
    return Text(
      Get.find<RequestTypeController>().getLocationName(text) ?? "",
      style: AppTextStyles.font14SecondaryBlackCairo,
    );
  }
}
