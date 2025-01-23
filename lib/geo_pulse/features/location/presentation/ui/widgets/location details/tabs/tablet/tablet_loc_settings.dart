import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import '../../../../../../../../core/constants/enums.dart';
import '../../../../../../../../core/helpers/spacing_helper.dart';
import '../../../../../../../../core/helpers/validation_helper.dart';
import '../../../../../../../../core/theme/app_colors.dart';
import '../../../../../../../../core/theme/app_text_styles.dart';
import '../../../../../../../../core/widgets/buttons/app_text_button.dart';
import '../../../../../../../../core/widgets/buttons/default_switch_button.dart';
import '../../../../../../../../core/widgets/dropdown/default_dropdown.dart';
import '../../../../../../../../core/widgets/fields/default_form_field.dart';
import '../../../../../controller/controller/location_controller.dart';

//tabbar body of location settings in tablet
class TabletLocSettings extends StatefulWidget {
  final int index;

  const TabletLocSettings({super.key, required this.index});

  @override
  State<TabletLocSettings> createState() => _TabletLocSettingsState();
}

class _TabletLocSettingsState extends State<TabletLocSettings> {
  @override
  void initState() {
    Get.find<LocationController>().setEditLocationData(widget.index);

    String periodType = Get.find<LocationController>()
                .locationModels[widget.index]
                .allowPeriodTime !=
            null
        ? Get.find<LocationController>()
            .locationModels[widget.index]
            .allowPeriodTime!
            .getName
        : AllowPeriodTime.mins.getName;

    Get.find<LocationController>().selectedPeriodTypeToggle(periodType);
    Get.find<LocationController>().allowBreaksInAttendance =
        Get.find<LocationController>()
            .locationModels[widget.index]
            .allowBreaksInAttendance;
    Get.find<LocationController>().allowPause =
        Get.find<LocationController>().locationModels[widget.index].allowPause;
    Get.find<LocationController>().allowPeriodController.text =
        Get.find<LocationController>()
                    .locationModels[widget.index]
                    .allowPeriodTimeNumber ==
                null
            ? '0'
            : Get.find<LocationController>()
                .locationModels[widget.index]
                .allowPeriodTimeNumber
                .toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) {
        Get.find<LocationController>().setEditLocationData(widget.index);
      },
      child: GetBuilder<LocationController>(
          //id: AppConstanst.location,
          builder: (controller) {
        return Container(
          // height: 142.h,
          decoration: BoxDecoration(
              color: AppColors.card, borderRadius: BorderRadius.circular(8.r)),
          padding: const EdgeInsets.only(
            top: 22,
            right: 16,
            left: 16,
            bottom: 8,
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: LabelSwitchRow(
                      label: '${'Allow Breaks in attendance'.tr}  ',
                      value: controller.allowBreaksInAttendance,
                      onChanged: (value) {
                        controller.updateAllowBreaks(/*widget.index*/);
                      },
                    ),
                  ),
                  horizontalSpace(38),
                  Expanded(
                    child: LabelSwitchRow(
                      label: '${'Allow Pause'.tr}  ',
                      value: controller.allowPause,
                      onChanged: (value) {
                        controller.updateAllowPause(/*widget.index*/);
                      },
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  if (controller.allowBreaksInAttendance)
                    Expanded(
                      child: GetBuilder<LocationController>(
                          // id: AppConstanst.locationDialog,
                          builder: (controller) {
                        return Padding(
                          padding: EdgeInsets.only(top: 12.0.h),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 3,
                                child: AppTextFormField(
                                  hintText: 'Text Allowance Period Here'.tr,
                                  maxLines: 1,
                                  helperText: '',
                                  keyboardType: TextInputType.number,
                                  hintStyle: AppTextStyles
                                      .font12SecondaryBlackCairoRegular,
                                  style: AppTextStyles
                                      .font12SecondaryBlackCairoRegular,
                                  showBorder: true,
                                  width: double.infinity,
                                  controller: controller.allowPeriodController,
                                  validator: (value) {
                                    return ValidationHelper.isEmpty(
                                      value,
                                      'Allowance Period'.tr,
                                    );
                                  },
                                ),
                              ),
                              horizontalSpace(12),
                              Expanded(
                                flex: 1,
                                child: DefaultDropdown(
                                  height: 48.h,
                                  popupMenuItems: locationAllowPeriodTimeList,
                                  enabled: true,
                                  onOpened: () {
                                    controller.toggleArrow(true);
                                  },
                                  onCanceled: () =>
                                      controller.toggleArrow(false),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          overflow: TextOverflow.ellipsis,
                                          controller.selectedPeriodType != null
                                              ? controller
                                                  .selectedPeriodType!.tr
                                              : 'Period'.tr,
                                          style: AppTextStyles
                                              .font12SecondaryBlackCairoRegular,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.only(
                                            end: 10.0.w),
                                        child: SvgPicture.asset(
                                          controller.dropDownArrow,
                                          color: AppColors.inverseBase,
                                        ),
                                      ),
                                    ],
                                  ),
                                  onSelected: (value) {
                                    controller.selectedPeriodTypeToggle(value);
                                    controller.toggleArrow(false);
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                  const Spacer(),
                  GetBuilder<LocationController>(
                    //id: AppConstanst.locationDialog,
                    builder: (controller) {
                      // Determine if the button should be displayed
                      bool showButton = controller.allowPause !=
                              controller
                                  .locationModels[widget.index].allowPause ||
                          controller.allowBreaksInAttendance !=
                              controller.locationModels[widget.index]
                                  .allowBreaksInAttendance ||
                          controller.locationModels[widget.index]
                                  .allowPeriodTimeNumber
                                  .toString() !=
                              controller.allowPeriodController.text ||
                          controller.locationModels[widget.index]
                                  .allowPeriodTime?.getName
                                  .toLowerCase() !=
                              controller.selectedPeriodType?.toLowerCase();

                      return showButton
                          ? AppTextButton(
                              onPressed: () {
                                if (controller
                                    .allowPeriodController.text.isNotEmpty) {
                                  controller.editLocation(widget.index);
                                } else {
                                  null;
                                }
                              },
                              width: 80.w,
                              height: 40.h,
                              text: 'Save'.tr,
                              textStyle: AppTextStyles.font18BlackCairoMedium,
                              backgroundColor: (controller.allowPeriodController
                                          .text.isNotEmpty ||
                                      !controller.locationModels[widget.index]
                                          .allowPause)
                                  ? AppColors.primary
                                  : AppColors.whiteShadow,
                              borderRadius: 4.r,
                            )
                          : SizedBox(); // Use SizedBox to hide the button
                    },
                  )
                ],
              )
            ],
          ),
        );
      }),
    );
  }
}

class LabelSwitchRow extends GetView<LocationController> {
  const LabelSwitchRow({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final Function(bool) onChanged;
  final bool value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.font18BlackCairoMedium,
        ),
        DefaultSwitchButton(
          value: value,
          onChanged: onChanged,
        )
      ],
    );
  }
}
