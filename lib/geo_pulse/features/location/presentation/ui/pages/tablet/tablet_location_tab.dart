import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../../../../core/extensions/extensions.dart';

import '../../../../../../core/constants/strings.dart';
import '../../../../../../core/helpers/date_time_helper.dart';
import '../../../../../../core/helpers/haptic_feedback_helper.dart';
import '../../../../../../core/routes/app_routes.dart';
import '../../../../../../core/routes/route_arguments.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_text_styles.dart';
import '../../../../../../core/widgets/loading/circle_progress.dart';
import '../../../../../../core/widgets/no_data_gif.dart';
import '../../../../../../core/widgets/table/default_data_table.dart';
import '../../../controller/controller/location_controller.dart';
import '../../constants/location_columns_name.dart';

/// This file is responsible for providing the default tablet location tab widget .
class TabletLocationTab extends StatefulWidget {
  const TabletLocationTab({super.key, required this.readOnly});
  final bool readOnly;

  @override
  State<TabletLocationTab> createState() => _TabletLocationTabState();
}

class _TabletLocationTabState extends State<TabletLocationTab> {
  @override
  void initState() {
    Get.find<LocationController>().getAllLocations();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: GetBuilder<LocationController>(
          id: AppConstanst.location,
          builder: (controller) {
            if (controller.isGettingLocations) {
              return SizedBox(
                height: Get.height * 0.5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CircleProgress(),
                  ],
                ),
              );
            }
            return controller.locationModels.isEmpty
                ? const NoDataGif()
                : DefaultDataTable(
                    columns: LocationColumnsName.locationColumnsName
                        .map(
                          (element) => DataColumn(
                            label: Text(
                              element.tr,
                              style: AppTextStyles.font16WhiteRegularCairo,
                            ),
                          ),
                        )
                        .toList(),
                    rows: List.generate(
                      controller.locationModels.length,
                      (index) => DataRow(
                        onSelectChanged: (value) {
                          if (value ?? false) {
                            HapticFeedbackHelper.triggerHapticFeedback(
                              vibration: VibrateType.mediumImpact,
                              hapticFeedback: HapticFeedback.mediumImpact,
                            );
                            context.navigateTo(
                              Routes.locationDetails,
                              arguments: {
                                RouteArguments.locationModelIndex: index,
                                RouteArguments.readOnly: widget.readOnly,
                              },
                            );
                          }
                        },
                        color: WidgetStatePropertyAll(
                          index % 2 == 0
                              ? AppColors.evenRowColor
                              : AppColors.oddRowColor,
                        ),
                        cells: [
                          DataCell(
                            Text(
                              context.isArabic
                                  ? controller
                                      .locationModels[index].locationNameArabic
                                  : controller.locationModels[index]
                                      .locationNameEnglish,
                              style: AppTextStyles.font16BlackRegularCairo,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          DataCell(
                            Text(
                              Get.locale.toString().contains('en')
                                  ? '${controller.locationModels[index].address.city}, ${controller.locationModels[index].address.country}'
                                  : '${controller.locationModels[index].address.cityArabic}, ${controller.locationModels[index].address.countryArabic}',
                              style: AppTextStyles.font16BlackRegularCairo,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          DataCell(
                            GestureDetector(
                              onTap: () {
                                controller.launchLink(
                                  controller
                                      .locationModels[index].googleMapsLink,
                                );
                              },
                              child: Text(
                                controller.locationModels[index].googleMapsLink,
                                style: AppTextStyles.font16BlackRegularCairo
                                    .copyWith(color: AppColors.blue),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          DataCell(
                            Text(
                              '${DateTimeHelper.formatDouble(controller.locationModels[index].latitude)} , ${DateTimeHelper.formatDouble(controller.locationModels[index].longitude)}',
                              style: AppTextStyles.font16BlackRegularCairo,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          // DataCell(
                          //   Text(
                          //     controller.locationModels[index].locationAccuracy
                          //         .getName.tr,
                          //     style: AppTextStyles.font16BlackRegularCairo,
                          //     maxLines: 1,
                          //     overflow: TextOverflow.ellipsis,
                          //   ),
                          // ),
                          DataCell(
                            Text(
                              DateTimeHelper.formatInt(controller
                                  .locationModels[index].geoFencingPerimeter),
                              style: AppTextStyles.font16BlackRegularCairo,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ).toList(),
                  );
          }),
    );
  }
}
