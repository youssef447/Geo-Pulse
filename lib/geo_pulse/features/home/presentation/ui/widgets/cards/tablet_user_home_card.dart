import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../../../core/constants/app_assets.dart';
import '../../../../../../core/helpers/spacing_helper.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_text_styles.dart';
import '../../../../../../core/widgets/buttons/app_text_button.dart';
import '../../../../../../core/widgets/responsive/orientation_layout.dart';
import 'package:geo_pulse/geo_pulse/features/users/models/user_model.dart';
import '../message_container.dart';

/// Represents the tablet view of the user home card.
class TabletUserHomeCard extends StatelessWidget {
  final UserModel user;

  const TabletUserHomeCard({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Padding(
        padding: EdgeInsetsDirectional.symmetric(
          horizontal: 16.w,
          vertical: 24.h,
        ),
        child: OrientationLayout(
          // portrait
          portrait: (context) => Row(
            children: [
              _buildAvatar(),
              horizontalSpace(24),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _buildNameAndJobTitleColumn(),
                        horizontalSpace(40),
                        _buildEmailAndPhoneColumn(),
                        horizontalSpace(5),
                        Expanded(
                          flex: 3,
                          child: _buildEmailAndPhoneNumberColumn(),
                        ),
                        const Spacer(),
                        const MessageContainer(),
                      ],
                    ),
                    verticalSpace(16),
                    _buildSupervisorRow(),
                  ],
                ),
              ),
            ],
          ),
          // landscape
          landscape: (context) => Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  _buildAvatar(),
                  horizontalSpace(16),
                  _buildNameAndJobTitleColumn(),
                  horizontalSpace(16),
                  _buildEmailAndPhoneColumn(),
                  horizontalSpace(16),
                  Flexible(
                    child: _buildEmailAndPhoneNumberColumn(),
                  ),
                  horizontalSpace(16),
                  Column(
                    children: [
                      _buildSupervisorRow(),
                      verticalSpace(40),
                    ],
                  ),
                ],
              ),
              _buildChatLandscapeButton()
            ],
          ),
        ),
      ),
    );
  }

  Row _buildSupervisorRow() {
    return Row(
      children: [
        Text(
          'Supervisor'.tr,
          style: AppTextStyles.font16SecondaryBlackCairoMedium,
        ),
        horizontalSpace(5),
        Text(
          user.supervisor,
          style: AppTextStyles.font16BlackMediumCairo,
        ),
      ],
    );
  }

  _buildEmailAndPhoneNumberColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          user.email,
          style: AppTextStyles.font16SecondaryBlackCairoMedium.copyWith(
            color: AppColors.blue,
          ),
        ),
        verticalSpace(16),
        Text(
          user.phoneNumber,
          style: AppTextStyles.font16BlackMediumCairo,
        ),
      ],
    );
  }

  Column _buildEmailAndPhoneColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Email'.tr,
          style: AppTextStyles.font16SecondaryBlackCairoMedium,
        ),
        verticalSpace(16),
        Text(
          'Phone'.tr,
          style: AppTextStyles.font16SecondaryBlackCairoMedium,
        ),
      ],
    );
  }

  Column _buildNameAndJobTitleColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('${user.firstName} ${user.lastName}',
            style: AppTextStyles.font21BlackMediumCairo),
        verticalSpace(16),
        Text(user.jobTitle,
            style: AppTextStyles.font16SecondaryBlackCairoMedium),
      ],
    );
  }

  _buildChatLandscapeButton() {
    return AppTextButton(
      onPressed: () {
        // go to chat from here
      },
      customWidget: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            AppAssets.message,
            width: 24.w,
            height: 24.h,
            color: AppColors.icon,
          ),
          horizontalSpace(8),
          Text(
            'Chat with employee'.tr,
            style: AppTextStyles.font14BlackCairoMedium.copyWith(
              color: AppColors.textButton,
            ),
          )
        ],
      ),
      height: 42.h,
      backgroundColor: AppColors.primary,
      borderRadius: 8.r,
    );
  }

  Stack _buildAvatar() {
    return Stack(
      alignment: Alignment.center,
      children: [
        CircleAvatar(
          radius: 53.r,
          backgroundColor: AppColors.darkGrey,
        ),
        CircleAvatar(
          radius: 50.r,
          backgroundImage: const AssetImage(AppAssets.userProfile),
          backgroundColor: AppColors.darkGrey,
        ),
      ],
    );
  }
}
