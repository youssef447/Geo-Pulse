import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../../../../core/extensions/extensions.dart';

import '../../../../../../../core/constants/app_assets.dart';
import '../../../../../../../core/constants/strings.dart';
import '../../../../../../../core/helpers/get_dialog_helper.dart';
import '../../../../../../../core/helpers/haptic_feedback_helper.dart';
import '../../../../../../../core/helpers/spacing_helper.dart';
import '../../../../../../../core/routes/app_routes.dart';
import '../../../../../../../core/routes/route_arguments.dart';
import '../../../../../../../core/theme/app_colors.dart';
import '../../../../../../../core/theme/app_text_styles.dart';
import '../../../../../../../core/widgets/dialog/default_dialog.dart';
import '../../../../controller/controller/location_controller.dart';

///By: Youssef Ashraf
/// Date: 1/10/2024
/// Description: This is the mobile location details appbar widget.
class MobileLocDetailsAppbar extends GetView<LocationController> {
  final int index;
  const MobileLocDetailsAppbar({
    super.key,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LocationController>(
        id: AppConstanst.location,
        builder: (controller) {
          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 16.w,
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
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
                    horizontalSpace(8),
                    Expanded(
                      child: Text(
                        context.isArabic
                            ? controller
                                .locationModels[index].locationNameArabic
                            : controller
                                .locationModels[index].locationNameEnglish,
                        overflow: TextOverflow.ellipsis,
                        style: context.isTablett
                            ? AppTextStyles.font28BlackSemiBoldCairo
                            : AppTextStyles.font26BlackSemiBoldCairo,
                      ),
                    ),
                  ],
                ),
                verticalSpace(8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        controller.setEditLocationData(index);
                        context.navigateTo(Routes.addLocation,
                            arguments: {RouteArguments.edit: true});
                      },
                      child: Container(
                        width: 41.w,
                        height: 32.h,
                        decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(8.r)),
                        alignment: Alignment.center,
                        child: SvgPicture.asset(
                          AppAssets.edit,
                          color: AppColors.icon,
                        ),
                      ),
                    ),
                    horizontalSpace(8),
                    GestureDetector(
                      onTap: () {
                        GetDialogHelper.generalDialog(
                          child: DefaultDialog(
                            width: 343.w,
                            lottieAsset: AppAssets.trash,
                            title: 'Delete Location'.tr,
                            subTitle:
                                'Are you sure you want to delete this location?'
                                    .tr,
                            showButtons: true,
                            autoClose: false,
                            onConfirm: () {
                              controller.deleteLocation(index);
                            },
                          ),
                          context: context,
                        );
                      },
                      child: Container(
                        width: 41.w,
                        height: 32.h,
                        decoration: BoxDecoration(
                            color: AppColors.red,
                            borderRadius: BorderRadius.circular(8.r)),
                        alignment: Alignment.center,
                        child: SvgPicture.asset(AppAssets.trashImg),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }
}
