import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../../../core/extensions/extensions.dart';

import '../../../../../../core/constants/app_assets.dart';
import '../../../../../../core/constants/enums.dart';
import '../../../../../../core/constants/strings.dart';
import '../../../../../../core/helpers/get_dialog_helper.dart';
import '../../../../../../core/helpers/haptic_feedback_helper.dart';
import '../../../../../../core/helpers/spacing_helper.dart';
import '../../../../../../core/helpers/validation_helper.dart';
import '../../../../../../core/routes/app_routes.dart';
import '../../../../../../core/routes/route_arguments.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_text_styles.dart';
import '../../../../../../core/widgets/buttons/default_switch_button.dart';
import '../../../../../../core/widgets/dialog/default_dialog.dart';
import '../../../../../../core/widgets/dropdown/default_dropdown.dart';
import '../../../../../../core/widgets/fields/default_form_field.dart';
import '../../../../../../core/widgets/fields/text_single_field.dart';
import '../../../controller/controller/location_controller.dart';

/// by : Mohamed Ashraf
/// date : 28/10/2024
/// show  edit or add  location

class MobileDataLocation extends GetView<LocationController> {
  final bool? isEdit;
  const MobileDataLocation({super.key, this.isEdit});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: PopScope(
        onPopInvoked: (didPop) {
          if (didPop) {
            controller.resetData();
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            child: GetBuilder<LocationController>(
              id: AppConstanst.locationDialog,
              builder: (controller) {
                return Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: controller.formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                        verticalSpace(8),
                        Text(
                          isEdit ?? false
                              ? 'Edit Location'.tr
                              : 'Add New location'.tr,
                          style: AppTextStyles.font26BlackSemiBoldCairo,
                        ),
                        verticalSpace(8),
                        Text(
                          'Location Description'.tr,
                          style: AppTextStyles.font20BlackSemiBoldCairo,
                        ),
                        verticalSpace(31),
                        TextSingleField(
                          controller: controller.locationNameEnglishController,
                          typeName: 'Location Name',
                          hintText: 'Text Here',
                          validator: (value) {
                            if (value!.isEmpty) {
                              return ValidationHelper.isEmpty(
                                  value, 'Location Name');
                            }
                            return ValidationHelper.isEnglish(value);
                          },
                        ),
                        verticalSpace(8),
                        TextSingleField(
                          isArabic: true,
                          controller: controller.locationNameArabicController,
                          typeName: 'اسم الموقع',
                          hintText: 'اكتب هنا',
                          validator: (value) {
                            if (value!.isEmpty) {
                              return ValidationHelper.isEmpty(
                                value,
                                'اسم الموقع',
                              );
                            }
                            return ValidationHelper.isArabic(value);
                          },
                        ),
                        verticalSpace(8),
                        TextSingleField(
                          controller: controller.googleMapsLinkController,
                          isArabic: context.isArabic,
                          style: AppTextStyles.font12BlackCairoRegular
                              .copyWith(color: Colors.blue),
                          typeName: 'Location at Google Maps'.tr,
                          hintText: 'Text Here'.tr.tr,
                          validator: (value) {
                            return ValidationHelper.isEmpty(
                              value,
                              'Location At Google Maps'.tr,
                            );
                          },
                          icon: SvgPicture.asset(
                            AppAssets.marker,
                            color: AppColors.blue,
                            height: 16.h,
                            width: 16.w,
                          ),
                          isReadOnly: true,
                          onTap: () {
                            context.navigateTo(
                              isEdit == true
                                  ? Routes.mapEditScreen
                                  : Routes.mapScreen,
                              arguments: {
                                RouteArguments.isGeofencing: false,
                              },
                            );
                          },
                        ),
                        verticalSpace(8),
                        TextSingleField(
                          controller: controller.latitudeController,
                          isArabic: context.isArabic,
                          typeName: 'Latitude'.tr,
                          hintText: 'Latitude'.tr,
                          validator: (value) {
                            return ValidationHelper.isEmpty(
                              value,
                              'Latitude'.tr,
                            );
                          },
                          isReadOnly: true,
                          onTap: () {
                            context.navigateTo(
                              isEdit == true
                                  ? Routes.mapEditScreen
                                  : Routes.mapScreen,
                              arguments: {
                                RouteArguments.isGeofencing: false,
                              },
                            );
                          },
                        ),
                        verticalSpace(8),
                        TextSingleField(
                          controller: controller.longitudeController,
                          isArabic: context.isArabic,
                          hintText: 'Longitude'.tr,
                          typeName: 'Longitude'.tr,
                          validator: (value) {
                            return ValidationHelper.isEmpty(
                              value,
                              'Longitude'.tr,
                            );
                          },
                          isReadOnly: true,
                          onTap: () {
                            context.navigateTo(
                              isEdit == true
                                  ? Routes.mapEditScreen
                                  : Routes.mapScreen,
                              arguments: {
                                RouteArguments.isGeofencing: false,
                              },
                            );
                          },
                        ),
                        verticalSpace(8),
                        Row(
                          children: [
                            Text(
                              'Allowance Geofence'.tr,
                              style: AppTextStyles.font14BlackCairoMedium,
                            ),
                            const Spacer(),
                            DefaultSwitchButton(
                              value: controller.allowGeofence,
                              onChanged: (bool value) {
                                controller.updateAllowenceGeofence();
                                if (controller.allowGeofence) {
                                  context.navigateTo(
                                    isEdit == true
                                        ? Routes.mapEditScreen
                                        : Routes.mapScreen,
                                    arguments: {
                                      RouteArguments.isGeofencing: true,
                                    },
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                        if (controller.allowGeofence)
                          Column(
                            children: [
                              verticalSpace(8),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: TextSingleField(
                                      isArabic: context.isArabic,
                                      controller: controller
                                          .geoFencingPerimeterController,
                                      typeName: 'Geofencing Perimeter'.tr,
                                      hintText: 'Text Here'.tr,
                                      validator: (value) {
                                        return ValidationHelper.isEmpty(
                                            value, 'Geofencing Perimeter'.tr);
                                      },
                                      isReadOnly: true,
                                      onTap: () {
                                        context.navigateTo(
                                          isEdit == true
                                              ? Routes.mapEditScreen
                                              : Routes.mapScreen,
                                          arguments: {
                                            RouteArguments.isGeofencing: true,
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                  horizontalSpace(5),
                                  Padding(
                                    padding: EdgeInsets.only(top: 24.0.h),
                                    child: Text(
                                      'Meter'.tr,
                                      style:
                                          AppTextStyles.font12BlackCairoRegular,
                                    ),
                                  ),
                                ],
                              ),
                              verticalSpace(8),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: TextSingleField(
                                      isArabic: context.isArabic,
                                      controller:
                                          controller.geoFencingAreaController,
                                      typeName: 'Geofencing Area'.tr,
                                      hintText: 'Text Here'.tr,
                                      validator: (value) {
                                        return ValidationHelper.isEmpty(
                                            value, 'Geofencing Area'.tr);
                                      },
                                      isReadOnly: true,
                                      onTap: () {
                                        context.navigateTo(
                                          isEdit == true
                                              ? Routes.mapEditScreen
                                              : Routes.mapScreen,
                                          arguments: {
                                            RouteArguments.isGeofencing: true,
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                  horizontalSpace(5),
                                  Padding(
                                    padding: EdgeInsets.only(top: 24.0.h),
                                    child: Text(
                                      'Meter²'.tr,
                                      style:
                                          AppTextStyles.font12BlackCairoRegular,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        verticalSpace(8),
                        TextSingleField(
                          isArabic: context.isArabic,
                          controller: Get.locale.toString().contains('en')
                              ? controller.countryController
                              : controller.countryArabicController,
                          typeName: 'Country'.tr,
                          hintText: 'Text Here'.tr,
                          validator: (value) {
                            return ValidationHelper.isEmpty(
                              value,
                              'Country'.tr,
                            );
                          },
                        ),
                        verticalSpace(8),
                        TextSingleField(
                          isArabic: context.isArabic,
                          controller: Get.locale.toString().contains('en')
                              ? controller.stateOrProvinceController
                              : controller.stateOrProvinceArabicController,
                          typeName: 'State or Province'.tr,
                          hintText: 'Text Here'.tr,
                          validator: (value) {
                            return ValidationHelper.isEmpty(
                              value,
                              'State or Province'.tr,
                            );
                          },
                        ),
                        verticalSpace(8),
                        TextSingleField(
                          isArabic: context.isArabic,
                          controller: Get.locale.toString().contains('en')
                              ? controller.cityController
                              : controller.cityArabicController,
                          typeName: 'City'.tr,
                          hintText: 'Text Here'.tr,
                          validator: (value) {
                            return ValidationHelper.isEmpty(
                              value,
                              'City'.tr,
                            );
                          },
                        ),
                        verticalSpace(8),
                        TextSingleField(
                          isArabic: context.isArabic,
                          controller: controller.postalCodeController,
                          typeName: 'Postal Code'.tr,
                          hintText: 'Text Here'.tr,
                          validator: (value) {
                            return ValidationHelper.isEmpty(
                              value,
                              'Postal Code'.tr,
                            );
                          },
                        ),
                        verticalSpace(24),
                        Text(
                          'Location Setting'.tr,
                          style: AppTextStyles.font20BlackSemiBoldCairo,
                        ),
                        verticalSpace(8),
                        Row(
                          children: [
                            Text(
                              'Allow Breaks In Attendance'.tr,
                              style: AppTextStyles.font14BlackCairoMedium,
                            ),
                            const Spacer(),
                            DefaultSwitchButton(
                              value: controller.allowBreaksInAttendance,
                              onChanged: (bool value) {
                                controller.updateAllowBreaks();
                              },
                            ),
                          ],
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
                                    hintStyle: AppTextStyles
                                        .font12SecondaryBlackCairoRegular,
                                    style: AppTextStyles
                                        .font12SecondaryBlackCairoRegular,
                                    showBorder: true,
                                    width: double.infinity,
                                    controller:
                                        controller.allowPeriodController,
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
                                            controller.selectedPeriodType !=
                                                    null
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
                                      controller
                                          .selectedPeriodTypeToggle(value);
                                      controller.toggleArrow(false);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        verticalSpace(12),
                        Row(
                          children: [
                            Text(
                              'Allow Pause'.tr,
                              style: AppTextStyles.font14BlackCairoMedium,
                            ),
                            const Spacer(),
                            DefaultSwitchButton(
                              value: controller.allowPause,
                              onChanged: (bool value) {
                                controller.updateAllowPause();
                              },
                            )
                          ],
                        ),
                        verticalSpace(24),
                        GestureDetector(
                          onTap: () async {
                            if (controller.isValid()) {
                              if (isEdit ?? false) {
                                await controller.editLocation(-1);
                                Navigator.of(context).pop();
                                GetDialogHelper.generalDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    child: DefaultDialog(
                                      width: 343.w,
                                      lottieAsset: AppAssets.successful,
                                      title: 'Successful'.tr,
                                      subTitle:
                                          'You Successfully Edited Location!'
                                              .tr,
                                    ));
                              } else {
                                await controller.addLocation(context).then((v) {
                                  controller.resetLocationDetails();
                                  GetDialogHelper.generalDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      child: DefaultDialog(
                                        width: 343.w,
                                        lottieAsset: AppAssets.successful,
                                        title: 'Successful'.tr,
                                        subTitle:
                                            'You Successfully Added Location!'
                                                .tr,
                                      ));
                                });
                              }
                            }
                          },
                          child: Container(
                            height: 35.h,
                            alignment: Alignment.center,
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                                horizontal: 8.w, vertical: 8.h),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4.r),
                              color: !controller.isValid()
                                  ? AppColors.whiteShadow
                                  : AppColors.primary,
                            ),
                            child: Text(
                              isEdit ?? false
                                  ? 'Edit Location'.tr
                                  : 'Add New Location'.tr,
                              style: AppTextStyles.font14BlackCairoMedium
                                  .copyWith(color: AppColors.textButton),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
