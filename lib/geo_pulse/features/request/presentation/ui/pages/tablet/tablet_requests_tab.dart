import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tracking_module/tracking_module/core/extensions/extensions.dart';
import '../../../../../../core/constants/enums.dart';

import '../../../../../../core/constants/strings.dart';
import '../../../../../../core/helpers/date_time_helper.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_text_styles.dart';
import '../../../../../../core/widgets/loading/circle_progress.dart';
import '../../../../../../core/widgets/dashed_container.dart';
import '../../../../../../core/widgets/no_data_gif.dart';
import '../../../../../../core/widgets/table/default_data_table.dart';
import '../../../../constants/table_columns.dart';
import '../../../controller/requests_controller.dart';
import '../../widgets/tablet/tablet_reminder_button.dart';

/// This file is responsible for providing the default tablet requests tab widget .
class TabletRequestsTab extends StatelessWidget {
  const TabletRequestsTab({super.key, required this.readOnly});

  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    if (readOnly) {
      Get.find<TrackingRequestsController>().tableColumns =
          RequestColumnsConstants.readOnlyRequestHeaders;
    } else {
      Get.find<TrackingRequestsController>().tableColumns =
          RequestColumnsConstants.requestHeaders;
    }
    return SliverToBoxAdapter(
      child: GetBuilder<TrackingRequestsController>(
          id: AppConstanst.request,
          builder: (controller) {
            if (controller.isGettingRequests) {
              return SizedBox(
                height: Get.height * 0.35,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CircleProgress(),
                  ],
                ),
              );
            }
            if (controller.filteredRequests.isEmpty) {
              return const NoDataGif();
            }
            return DefaultDataTable(
              columns: controller.tableColumns
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
                controller.filteredRequests.length,
                (index) => DataRow(
                  color: WidgetStatePropertyAll(
                    index % 2 == 0
                        ? AppColors.evenRowColor
                        : AppColors.oddRowColor,
                  ),
                  cells: [
                    DataCell(
                      Text(
                        textAlign: TextAlign.center,
                        DateTimeHelper.formatDate(
                          controller.filteredRequests[index].requestDate,
                        ),
                        style: AppTextStyles.font16BlackRegularCairo,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    DataCell(
                      Text(
                        textAlign: TextAlign.center,
                        controller
                            .filteredRequests[index].requestStatus.getName.tr,
                        style: AppTextStyles.font16BlackRegularCairo.copyWith(
                          color: controller
                              .filteredRequests[index].requestStatus.getColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    DataCell(
                      Text(
                        textAlign: TextAlign.center,
                        !context.isArabic
                            ? controller
                                .filteredRequests[index].requestType.englishName
                            : controller
                                .filteredRequests[index].requestType.arabicName,
                        style: AppTextStyles.font16BlackRegularCairo,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    DataCell(
                      Text(
                        textAlign: TextAlign.center,
                        DateTimeHelper.formatDuration(
                          controller.filteredRequests[index].totalTime,
                        ),
                        style: AppTextStyles.font16BlackRegularCairo,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    DataCell(
                      controller.filteredRequests[index].description != null
                          ? Text(
                              controller.filteredRequests[index].description!,
                              style: AppTextStyles.font14BlackRegularCairo,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            )
                          : const DashedContainer(),
                    ),
                    if (!readOnly)
                      DataCell(
                        TabletReminderButton(
                          modelIndex: index,
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
