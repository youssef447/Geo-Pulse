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

class MobileLocSettings extends StatefulWidget {
  final int index;

  const MobileLocSettings({super.key, required this.index});

  @override
  State<MobileLocSettings> createState() => _MobileLocSettingsState();
}

class _MobileLocSettingsState extends State<MobileLocSettings> {
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
    return SliverToBoxAdapter(
      child: GetBuilder<LocationController>(
          //id: AppConstanst.location,
          builder: (controller) {
        return Align(
          alignment: Alignment.topCenter,
          child: Container(
            decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(8.r)),
            padding: EdgeInsets.only(
              left: 16.w,
              right: 16.w,
              bottom: 16.h,
              top: 8.h,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LabelSwitchRow(
                  label: '${'Allow Breaks in attendance'.tr}  ',
                  value: controller.allowBreaksInAttendance,
                  // controller
                  //   .locationModels[widget.index].allowBreaksInAttendance,
                  onChanged: (value) {
                    controller.updateAllowBreaks(/*widget.index*/);
                  },
                ),
                if (controller.allowBreaksInAttendance)
                  Padding(
                    padding: EdgeInsets.only(top: 12.0.h),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 3,
                          child: AppTextFormField(
                            hintText: 'Text Allowance Period Here'.tr,
                            maxLines: 1,
                            keyboardType: TextInputType.number,
                            hintStyle:
                                AppTextStyles.font12SecondaryBlackCairoRegular,
                            style:
                                AppTextStyles.font12SecondaryBlackCairoRegular,
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
                            onCanceled: () => controller.toggleArrow(false),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Text(
                                    overflow: TextOverflow.ellipsis,
                                    controller.selectedPeriodType != null
                                        ? controller.selectedPeriodType!.tr
                                        : 'Period'.tr,
                                    style: AppTextStyles
                                        .font12SecondaryBlackCairoRegular,
                                  ),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsetsDirectional.only(end: 10.0.w),
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
                  ),
                verticalSpace(4),
                LabelSwitchRow(
                  label: '${'Allow Pause'.tr}  ',
                  value: controller
                      .allowPause, // controller.locationModels[widget.index].allowPause,
                  onChanged: (value) {
                    controller.updateAllowPause(/*widget.index*/);
                  },
                ),
                verticalSpace(12),
                GetBuilder<LocationController>(
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
                        controller.locationModels[widget.index].allowPeriodTime
                                ?.getName
                                .toLowerCase() !=
                            controller.selectedPeriodType?.toLowerCase();

                    // Conditionally render the button
                    return showButton
                        ? AppTextButton(
                            onPressed: () {
                              if (controller
                                  .allowPeriodController.text.isNotEmpty) {
                                controller.editLocation(widget.index);
                                // controller.updateAllowPause();
                              }
                            },
                            width: 80.w,
                            height: 40.h,
                            text: 'Save'.tr,
                            textStyle: AppTextStyles.font18BlackCairoMedium,
                            backgroundColor: AppColors.primary,
                            borderRadius: 4.r,
                          )
                        : SizedBox(); // Hide button using an empty widget
                  },
                )

                /*  verticalSpace(4),
                    LabelSwitchRow(
                      label: '${'Allowance Period'.tr}  ',
                      value: controller.locationModels[index].allowPeriod,
                      onChanged: (value) {
                        controller.updateAllowenceGeofence(index);
                      },
                    ),
                    if (controller.locationModels[index].allowPeriod)
                      RichText(
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.ellipsis,
                        text: TextSpan(
                            text: '${'Allowance Period'.tr} : ',
                            style: AppTextStyles.font14BlackCairoMedium
                                .copyWith(height: 1.2),
                            children: [
                              TextSpan(
                                  text:
                                      '${DateTimeHelper.formatInt(controller.locationModels[index].allowPeriodTimeNumber ?? 0)} ${controller.locationModels[index].allowPeriodTime?.getName.tr}',
                                  style:
                                      AppTextStyles.font14SecondaryBlackCairo),
                            ]),
                      ), */
              ],
            ),
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
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.font18BlackCairoRegular.copyWith(height: 1),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        DefaultSwitchButton(
          value: value,
          onChanged: onChanged,
        )
      ],
    );
  }
}
