import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_text_styles.dart';
import '../../../../../../core/widgets/dropdown/app_dropdown.dart';
import '../../../../../../features/request_type/presentation/controller/request_types_controller.dart';

import '../../../../../../core/constants/strings.dart';

/// Objectives: This file is responsible for providing the availability dropdown widget used when adding or editing a request type.
class AvailabilityDropdown extends GetView<RequestTypeController> {
  const AvailabilityDropdown({
    super.key,
    required this.editEnabled,
  });

  final bool editEnabled;

  @override
  Widget build(BuildContext context) {
    return AppDropdown(
      height: 40.h,
      splashColorOn: false,
      textButton: 'Choose Here'.tr,
      items:
          Get.find<RequestTypeController>().availabilityLocations.keys.map((e) {
        return DropdownMenuItem(
          value: e,
          child: GetBuilder<RequestTypeController>(
              id: AppConstanst.checkbox,
              builder: (controller) {
                return CheckboxListTile(
                  activeColor: AppColors.secondaryPrimary,
                  checkColor: AppColors.white,
                  side: BorderSide(
                    color: AppColors.fieldBorder,
                  ),
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                  title: Text(
                    controller.getLocationName(e) ?? "",
                    // Get.locale.toString().contains('en') ? e.locationNameEnglish.capitalize! : e.locationNameArabic,
                    style: AppTextStyles.font14BlackCairoMedium,
                  ),
                  value: controller.availabilityLocations[e],
                  onChanged: (value) {
                    if (!editEnabled) return;
                    controller.toggleAvailability(e);
                  },
                  checkboxShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                );
              }),
        );
      }).toList(),
      onChanged: (value) {
        if (!editEnabled) return;
        controller.toggleAvailability(value);
      },
    );
  }
}
