import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../core/constants/enums.dart';

import '../../../../../../core/constants/strings.dart';
import '../../../../../../core/helpers/date_time_helper.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_text_styles.dart';
import '../../../../../../core/widgets/loading/circle_progress.dart';
import '../../../../../../core/widgets/dashed_container.dart';
import '../../../../../../core/widgets/no_data_gif.dart';
import '../../../../../../core/widgets/table/default_data_table.dart';
import '../../../constants/attendance_columns_name.dart';
import '../../../controller/controller/attendance_controller.dart';

/// A tablet page that displays attendance data, in table

class AttendanceTabletPage extends StatelessWidget {
  const AttendanceTabletPage({super.key, required this.readOnly});

  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: GetBuilder<TrackingAttendanceController>(
          id: AppConstanst.attendanceTable,
          builder: (controller) {
            if (controller.isGettingAttendances) {
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
            if (controller.attendanceDataModel.isEmpty) {
              return const NoDataGif();
            }
            return DefaultDataTable(
              noScroll: Platform.isWindows || Platform.isMacOS,
              columns: AttendanceColumnsName.attendanceColumnsName
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
                controller.attendanceDataModel.length,
                (index) => DataRow(
                  color: WidgetStatePropertyAll(
                    index % 2 == 0
                        ? AppColors.evenRowColor
                        : AppColors.oddRowColor,
                  ),
                  cells: [
                    DataCell(
                      Center(
                        child: Text(
                          DateTimeHelper.formatDate(
                            controller.attendanceDataModel[index].date,
                          ),
                          style: AppTextStyles.font16BlackRegularCairo,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    DataCell(
                      Text(
                        controller.attendanceDataModel[index].status.getName.tr,
                        style: AppTextStyles.font16BlackRegularCairo.copyWith(
                          color: controller
                              .attendanceDataModel[index].status.getColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    DataCell(
                      controller.attendanceDataModel[index].oncomingTime != null
                          ? Text(
                              DateTimeHelper.formatTime(
                                DateTimeHelper.formatTimeOfDayToDateTime(
                                    controller.attendanceDataModel[index]
                                        .oncomingTime!,
                                    null),
                              ),
                              style: AppTextStyles.font16BlackRegularCairo,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            )
                          : const DashedContainer(),
                    ),
                    DataCell(
                      controller.attendanceDataModel[index].leavingTime != null
                          ? Text(
                              DateTimeHelper.formatTime(
                                DateTimeHelper.formatTimeOfDayToDateTime(
                                    controller.attendanceDataModel[index]
                                        .leavingTime!,
                                    null),
                              ),
                              style: AppTextStyles.font16BlackRegularCairo,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            )
                          : const DashedContainer(),
                    ),
                    DataCell(
                      controller.attendanceDataModel[index].breakTime != null
                          ? Text(
                              DateTimeHelper.formatDuration(
                                controller
                                    .attendanceDataModel[index].breakTime!,
                              ),
                              style: AppTextStyles.font16BlackRegularCairo,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            )
                          : const DashedContainer(),
                    ),
                    DataCell(
                      controller.attendanceDataModel[index].totalTime != null
                          ? Text(
                              DateTimeHelper.formatDuration(
                                controller
                                    .attendanceDataModel[index].totalTime!,
                              ),
                              style: AppTextStyles.font16BlackRegularCairo,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            )
                          : const DashedContainer(),
                    ),
                  ],
                ),
              ).toList(),
            );
          }),
    );
  }
}
