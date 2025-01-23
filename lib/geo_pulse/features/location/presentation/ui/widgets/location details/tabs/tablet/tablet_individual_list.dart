import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../../../../../core/extensions/extensions.dart';

import '../../../../../../../../core/constants/app_assets.dart';
import '../../../../../../../../core/helpers/haptic_feedback_helper.dart';
import '../../../../../../../../core/helpers/spacing_helper.dart';
import '../../../../../../../../core/routes/app_routes.dart';
import '../../../../../../../../core/routes/route_arguments.dart';
import '../../../../../../../../core/theme/app_colors.dart';
import '../../../../../../../../core/theme/app_font_weights.dart';
import '../../../../../../../../core/theme/app_text_styles.dart';
import '../../../../../../../../core/theme/app_theme.dart';
import '../../../../../../../../core/widgets/fields/default_form_field.dart';
import '../../../../../../../../core/widgets/no_data_gif.dart';
import '../../../../../../../../core/widgets/table/default_data_table.dart';
import '../../../../../../../home/presentation/controller/controller/tracking_home_controller.dart';
import '../../../../../../../../core/widgets/cards/chip_card.dart';
import '../../../../../controller/controller/location_controller.dart';
import '../../../../../controller/controller/location_details_controller.dart';

///tabbar body of Individual List in tablet
class TabletIndividualList extends StatelessWidget {
  const TabletIndividualList({
    super.key,
    required this.index,
    required this.readOnly,
  });
  final int index;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LocationDetailsController>(
        id: 'individuals',
        builder: (controller) {
          return Column(
            children: [
              Row(children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: AppTextFormField(
                      height: 44.h,
                      maxLines: 1,
                      hintText: 'Search Here...'.tr,
                      backGroundColor: AppTheme.isDark ?? false
                          ? AppColors.field
                          : AppColors.white,
                      collapsed: true,
                      hintStyle: context.isTablett
                          ? AppTextStyles.font16BlackMediumCairo
                          : AppTextStyles.font12BlackCairo,
                      controller: controller.searchController,
                      contentPadding: context.isTablett
                          ? EdgeInsets.symmetric(
                              vertical: 2.h,
                            )
                          : null,
                      prefixIcon: SvgPicture.asset(
                        AppAssets.search,
                        width: context.isTablett ? 24.w : 16.0.w,
                        height: context.isTablett ? 24.h : 16.0.h,
                      ),
                    ),
                  ),
                ),
                horizontalSpace(16),
                ChipCard(
                  image: AppAssets.export,
                  onTap: () {
                    controller.exportTable(index);
                  },
                ),
              ]),
              verticalSpace(16),
              Get.find<LocationController>()
                      .locationModels[index]
                      .employees
                      .isEmpty
                  ? const NoDataGif()
                  : SizedBox(
                      width: double.infinity,
                      child: DefaultDataTable(
                        columns: controller.individualsTableColumns.map(
                          (e) {
                            return DataColumn(
                              label: Text(
                                e.tr,
                                textAlign: TextAlign.center,
                                style: AppTextStyles.font16WhiteRegularCairo,
                              ),
                            );
                          },
                        ).toList(),
                        rows: List.generate(
                          Get.find<LocationController>()
                              .locationModels[index]
                              .employees
                              .length,
                          (empIndex) {
                            final model = Get.find<LocationController>()
                                .locationModels[index]
                                .employees[empIndex];
                            final name = context.isArabic
                                ? Get.find<LocationController>()
                                    .locationModels[index]
                                    .locationNameArabic
                                : Get.find<LocationController>()
                                    .locationModels[index]
                                    .locationNameEnglish;

                            return DataRow(
                              color: WidgetStatePropertyAll(
                                empIndex % 2 == 0
                                    ? Colors.transparent
                                    : AppColors.card,
                              ),
                              onSelectChanged: (value) {
                                if (value ?? false) {
                                  if (!readOnly) {
                                    HapticFeedbackHelper.triggerHapticFeedback(
                                      vibration: VibrateType.mediumImpact,
                                      hapticFeedback:
                                          HapticFeedback.mediumImpact,
                                    );
                                    context.navigateTo(
                                      Routes.trackingHome,
                                      arguments: {
                                        RouteArguments.user: model,
                                        RouteArguments.locationName: name,
                                      },
                                    );
                                    Get.find<TrackingHomeController>()
                                        .setTabViews(model);
                                  }
                                }
                              },
                              cells: [
                                DataCell(
                                  Container(
                                    height: 32.h,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.r),
                                      image: DecorationImage(
                                        image: AssetImage(
                                          model.profileURL!,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    model.firstName,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style:
                                        AppTextStyles.font16BlackRegularCairo,
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    model.lastName,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style:
                                        AppTextStyles.font16BlackRegularCairo,
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    'Marketing Manager',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style:
                                        AppTextStyles.font16BlackRegularCairo,
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    model.supervisor,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style:
                                        AppTextStyles.font16BlackRegularCairo,
                                  ),
                                ),
                                DataCell(
                                  GestureDetector(
                                    onTap: () {},
                                    child: Container(
                                      height: 25.h,
                                      alignment: Alignment.center,
                                      width: 74.w,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(4.r),
                                        color: AppColors.primary,
                                      ),
                                      child: Text(
                                        'Chat'.tr,
                                        style: AppTextStyles
                                            .font12SecondaryBlackCairoMedium
                                            .copyWith(
                                          color: AppColors.textButton,
                                          fontWeight: AppFontWeights.regular,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ).toList(),
                      ),
                    ),
            ],
          );
        });
  }
}
