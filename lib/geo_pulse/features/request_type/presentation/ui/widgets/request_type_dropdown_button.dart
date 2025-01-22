import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../../core/extensions/extensions.dart';
import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/helpers/get_dialog_helper.dart';
import '../../../../../core/helpers/haptic_feedback_helper.dart';
import '../../../../../core/routes/app_routes.dart';
import '../../../../../core/routes/route_arguments.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/dialog/default_dialog.dart';
import '../../../../../features/request_type/presentation/controller/request_types_controller.dart';

import '../../../../../core/theme/app_text_styles.dart';

///Objectives: This file is responsible for providing the request type dropdown button widget used when adding or editing a request type.
class RequestTypeDropdownButton extends GetView<RequestTypeController> {
  final int index;

  const RequestTypeDropdownButton({
    super.key,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        highlightColor: AppColors.primary,
      ),
      child: PopupMenuButton(
        style: context.isPhone
            ? null
            : const ButtonStyle(
                padding: WidgetStatePropertyAll(EdgeInsets.zero),
                alignment: AlignmentDirectional.centerEnd,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
        onOpened: () {
          HapticFeedbackHelper.triggerHapticFeedback(
            vibration: VibrateType.mediumImpact,
            hapticFeedback: HapticFeedback.mediumImpact,
          );
        },
        color: AppColors.dialog,
        iconColor: AppColors.primary,
        padding: EdgeInsets.zero,
        onSelected: (value) {},
        itemBuilder: (BuildContext context) {
          return [
            PopupMenuItem(
              onTap: () {
                controller.setSelectedRequestType(
                  controller.requestTypeModels[index],
                );
                context.navigateTo(
                  Routes.requestType,
                  arguments: {
                    RouteArguments.title: 'Edit Request Type'.tr,
                  },
                );
              },
              value: 'Edit'.tr,
              child: Text(
                'Edit'.tr,
                style: AppTextStyles.font14BlackCairoMedium,
              ),
            ),
            PopupMenuItem(
              value: 'Delete'.tr,
              onTap: () {
                GetDialogHelper.generalDialog(
                  child: DefaultDialog(
                    width: context.isPhone ? 343.w : 411.w,
                    lottieAsset: AppAssets.trash,
                    title: 'Delete Request Type'.tr,
                    subTitle:
                        'Are you sure you want to delete this Request Type?'.tr,
                    showButtons: true,
                    autoClose: false,
                    onConfirm: () {
                      controller.deleteReqType(index);
                    },
                  ),
                  context: context,
                );
              },
              child: Text(
                'Delete'.tr,
                style: AppTextStyles.font14BlackCairoMedium,
              ),
            ),
          ];
        },
        child: SvgPicture.asset(
          AppAssets.more,
          color: AppColors.inverseBase,
        ),
      ),
    );
  }
}
