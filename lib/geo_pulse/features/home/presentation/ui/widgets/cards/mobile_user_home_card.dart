import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../../core/constants/app_assets.dart';
import '../../../../../../core/helpers/spacing_helper.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_text_styles.dart';
import 'package:tracking_module/tracking_module/features/users/models/user_model.dart';
import '../message_container.dart';

///Representation: This is the mobile view of the user home card.
class MobileUserHomeCard extends StatelessWidget {
  const MobileUserHomeCard({
    super.key,
    required this.user,
  });

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Padding(
        padding: EdgeInsetsDirectional.all(16.w),
        child: Column(
          children: [
            Row(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    CircleAvatar(
                      radius: 28.r,
                      backgroundColor: AppColors.darkGrey,
                    ),
                    CircleAvatar(
                      radius: 25.r,
                      backgroundImage: const AssetImage(AppAssets.userProfile),
                      backgroundColor: AppColors.darkGrey,
                    ),
                  ],
                ),
                horizontalSpace(12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${user.firstName} ${user.lastName}',
                        style: AppTextStyles.font16BlackMediumCairo),
                    Text(user.jobTitle,
                        style: AppTextStyles.font14SecondaryBlackCairo),
                  ],
                ),
                const Spacer(),
                const MessageContainer(),
              ],
            ),
            verticalSpace(8),
            Row(
              children: [
                Text(
                  'Email'.tr,
                  style: AppTextStyles.font14SecondaryBlackCairo,
                ),
                horizontalSpace(16),
                Text(
                  user.email,
                  style: AppTextStyles.font14SecondaryBlackCairo.copyWith(
                    color: AppColors.blue,
                  ),
                ),
              ],
            ),
            verticalSpace(8),
            Row(
              children: [
                Text(
                  'Phone'.tr,
                  style: AppTextStyles.font14SecondaryBlackCairo,
                ),
                horizontalSpace(16),
                Text(
                  user.phoneNumber,
                  style: AppTextStyles.font14BlackCairo,
                ),
              ],
            ),
            verticalSpace(8),
            Row(
              children: [
                Text(
                  'Supervisor'.tr,
                  style: AppTextStyles.font14SecondaryBlackCairo,
                ),
                horizontalSpace(16),
                Text(
                  user.supervisor,
                  style: AppTextStyles.font14BlackCairo,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
