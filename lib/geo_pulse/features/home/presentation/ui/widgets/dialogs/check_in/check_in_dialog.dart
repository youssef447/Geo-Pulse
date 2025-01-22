import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../../../../core/extensions/extensions.dart';

import '../../../../../../../core/constants/app_assets.dart';
import '../../../../../../../core/constants/strings.dart';
import '../../../../../../../core/helpers/spacing_helper.dart';
import '../../../../../../../core/helpers/validation_helper.dart';
import '../../../../../../../core/theme/app_colors.dart';
import '../../../../../../../core/theme/app_text_styles.dart';
import '../../../../../../../core/widgets/buttons/app_text_button.dart';
import '../../../../../../../core/widgets/fields/default_form_field.dart';
import '../../../../controller/controller/check_in_controller.dart';
import '../../../../controller/controller/tracking_home_controller.dart';

/// Represents the dialog for checking in.
class CheckInDialog extends GetView<TrackingHomeController> {
  const CheckInDialog({super.key});

  @override
  Widget build(BuildContext context) {
    var isTablet = context.isTablett;

    return GetBuilder<CheckInController>(
      id: AppConstanst.checkInDialog,
      builder: (controller) {
        return Container(
          height: isTablet ? 250.h : 230.h,
          width: isTablet ? 432.w : 343.w,
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(8.r),
          ),
          padding: EdgeInsets.all(16.w),
          child: Form(
            key: controller.formKeyCurrentLocation,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: AppColors.primary,
                      radius: 15.r,
                      child: SvgPicture.asset(
                        AppAssets.checkin,
                        color: AppColors.icon,
                      ),
                    ),
                    horizontalSpace(8),
                    Text(
                      'Check In'.tr,
                      style: AppTextStyles.font18BlackMediumCairo,
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  'Address'.tr,
                  style: AppTextStyles.font14BlackCairoMedium,
                ),
                verticalSpace(8),
                Row(
                  children: [
                    Expanded(
                      child: AppTextFormField(
                        textDirection: (context.isArabic
                            ? TextDirection.rtl
                            : TextDirection.ltr),
                        hintText: 'Text Here'.tr,
                        maxLines: 1,
                        hintStyle:
                            AppTextStyles.font12SecondaryBlackCairoRegular,
                        style: AppTextStyles.font12BlackCairoRegular,
                        showBorder: true,
                        width: double.infinity,
                        readOnly: true,
                        controller: controller.currentLocationAddress,
                        validator: (value) {
                          return ValidationHelper.isEmpty(
                            value,
                            'Address'.tr,
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: AppTextButton(
                    onPressed: () {
                      controller.submitCurrentLocation(context);
                    },
                    width: isTablet ? 120.w : double.infinity,
                    height: 40.h,
                    text: 'Check In'.tr,
                    textStyle: AppTextStyles.font16ButtonMediumCairo,
                    backgroundColor:
                        (controller.currentLocationAddress.text.isEmpty ||
                                controller.companyLocationAddress.text.isEmpty)
                            ? AppColors.whiteShadow
                            : AppColors.primary,
                    borderRadius: 4.r,
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
