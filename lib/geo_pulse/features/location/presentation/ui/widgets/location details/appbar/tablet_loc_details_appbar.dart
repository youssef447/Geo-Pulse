import 'package:flutter/cupertino.dart';
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
import '../../../../../../../core/widgets/buttons/app_default_button.dart';
import '../../../../../../../core/widgets/dialog/default_dialog.dart';
import '../../../../controller/controller/location_controller.dart';

///This file is responsible for providing the tablet location details appbar widget.

class TabletLocDetailsAppbar extends GetView<LocationController> {
  final int index;
  const TabletLocDetailsAppbar({
    super.key,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LocationController>(
        id: AppConstanst.location,
        builder: (controller) {
          return Column(
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
                          ? controller.locationModels[index].locationNameArabic
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
              verticalSpace(16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    width: 132.w,
                    child: AppDefaultButton(
                      text: 'Edit'.tr,
                      color: AppColors.primary,
                      style: AppTextStyles.font16BlackMediumCairo,
                      textColor: AppColors.textButton,
                      icon: AppAssets.edit,
                      iconColor: AppColors.icon,
                      height: 42.h,
                      onPressed: () {
                        controller.setEditLocationData(index);
                        context.navigateTo(Routes.addLocation,
                            arguments: {RouteArguments.edit: true});
                      },
                    ),
                  ),
                  horizontalSpace(8),
                  SizedBox(
                    width: 132.w,
                    child: AppDefaultButton(
                      text: 'Delete'.tr,
                      color: AppColors.red,
                      textColor: AppColors.white,
                      height: 42.h,
                      icon: AppAssets.trashImg,
                      style: AppTextStyles.font16BlackMediumCairo,
                      onPressed: () {
                        GetDialogHelper.generalDialog(
                          child: DefaultDialog(
                            width: 411.w,
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
                    ),
                  ),
                ],
              ),
            ],
          );
        });
  }
}
