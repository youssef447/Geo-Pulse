//Youssef Ashraf
//Individuals card for mobile view
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../../../core/helpers/spacing_helper.dart';
import '../../../../../../../core/theme/app_colors.dart';
import '../../../../../../../core/theme/app_text_styles.dart';
import '../../../../../../../core/widgets/buttons/app_default_button.dart';
import 'package:geo_pulse/geo_pulse/features/users/models/user_model.dart';

import '../../../../controller/controller/location_controller.dart';

class IndividualCard extends GetView<LocationController> {
  final UserModel model;
  const IndividualCard({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 8.w,
        vertical: 8.h,
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r), color: AppColors.card),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 40.h,
                width: 40.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  image: DecorationImage(
                    image: AssetImage(
                      model.profileURL!,
                    ),
                  ),
                ),
              ),
              horizontalSpace(12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ahmed Mohammed',
                    style: AppTextStyles.font16BlackMediumCairo,
                  ),
                  Text(
                    'Marketing Manager',
                    style: AppTextStyles.font12SecondaryBlackCairoRegular,
                  ),
                ],
              ),
            ],
          ),
          verticalSpace(16),
          RichText(
            textAlign: TextAlign.start,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            text: TextSpan(
                text: '${'Supervisor'.tr}  ',
                style: AppTextStyles.font16SecondaryBlackCairoMedium
                    .copyWith(height: 1),
                children: [
                  TextSpan(
                    text: model.supervisor,
                    style: AppTextStyles.font14BlackCairoMedium
                        .copyWith(height: 1),
                  ),
                ]),
          ),
          verticalSpace(16),
          AppDefaultButton(
            text: 'Chat'.tr,
            color: AppColors.primary,
            textColor: AppColors.textButton,
            height: 35.h,
            style: AppTextStyles.font14BlackCairoRegular,
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
