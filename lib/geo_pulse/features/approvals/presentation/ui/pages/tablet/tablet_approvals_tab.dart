import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../../core/extensions/extensions.dart';
import '../../../../../../core/constants/enums.dart';

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
import '../../../../../users/logic/add_employee_controller.dart';
import '../../../../constants/table_columns.dart';
import '../../../controller/tracking_approvals_controller.dart';
import '../../widgets/buttons/approve_buttons.dart';

/// Represents the approvals tab widget for the tablet approvals screen.
class TabletApprovalsTab extends StatelessWidget {
  const TabletApprovalsTab({super.key, required this.readOnly});

  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    final bool hr =
        Get.find<UserController>().employee!.position == UserPosition.hr;
    if (readOnly) {
      Get.find<TrackingApprovalsController>().tableColumns =
          ApprovalsColumnsConstants.readOnlyApprovalsHeaders;
    } else {
      Get.find<TrackingApprovalsController>().tableColumns =
          ApprovalsColumnsConstants.approvalsHeaders;
    }
    return SliverToBoxAdapter(
      child: GetBuilder<TrackingApprovalsController>(
          id: AppConstanst.approvals,
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
            return controller.approvalRequests.isEmpty
                ? const NoDataGif()
                : DefaultDataTable(
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
                      controller.approvalRequests.length,
                      (index) => DataRow(
                        onSelectChanged: (value) {
                          if (value ?? false) {
                            HapticFeedbackHelper.triggerHapticFeedback(
                              vibration: VibrateType.mediumImpact,
                              hapticFeedback: HapticFeedback.mediumImpact,
                            );
                            controller.selectedReqStatus = controller
                                .approvalRequests[index].requestStatus;
                            context.navigateTo(
                              Routes.requestDetails,
                              arguments: {
                                RouteArguments.requestModelIndex: index,
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
                            Container(
                              height: 32.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.r),
                                image: DecorationImage(
                                  image: Get.find<UserController>()
                                          .getEmployeePhoto(controller
                                              .approvalRequests[index]
                                              .requestedUserId)
                                          .contains('assets')
                                      ? AssetImage(Get.find<UserController>()
                                          .getEmployeePhoto(controller
                                              .approvalRequests[index]
                                              .requestedUserId))
                                      : NetworkImage(
                                          Get.find<UserController>()
                                              .getEmployeePhoto(controller
                                                  .approvalRequests[index]
                                                  .requestedUserId),
                                        ),
                                ),
                              ),
                            ),
                          ),

                          DataCell(
                            Text(
                              Get.find<UserController>()
                                  .getEmployeeNameFirstOrLast(
                                      controller.approvalRequests[index]
                                          .requestedUserId,
                                      true)
                                  .capitalize!,
                              style: AppTextStyles.font16BlackRegularCairo,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          DataCell(
                            Text(
                              Get.find<UserController>()
                                  .getEmployeeNameFirstOrLast(
                                      controller.approvalRequests[index]
                                          .requestedUserId,
                                      false)
                                  .capitalize!,
                              style: AppTextStyles.font16BlackRegularCairo,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),

                          ///
                          DataCell(
                            Text(
                              DateTimeHelper.formatDate(
                                controller.approvalRequests[index].requestDate,
                              ),
                              style: AppTextStyles.font16BlackRegularCairo,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          DataCell(
                            Text(
                              controller.approvalRequests[index].requestStatus
                                  .getName.tr,
                              style: AppTextStyles.font16BlackRegularCairo
                                  .copyWith(
                                color: controller.approvalRequests[index]
                                    .requestStatus.getColor,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          DataCell(
                            Text(
                              context.isArabic
                                  ? controller.approvalRequests[index]
                                      .requestType.arabicName
                                  : controller.approvalRequests[index]
                                      .requestType.englishName,
                              style: AppTextStyles.font16BlackRegularCairo,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          DataCell(
                            Text(
                              DateTimeHelper.formatDuration(
                                controller.approvalRequests[index].totalTime,
                              ),
                              style: AppTextStyles.font16BlackRegularCairo,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          controller.approvalRequests[index].requestStatus ==
                                      RequestStatus.pending &&
                                  !readOnly &&
                                  hr == true
                              ? DataCell(
                                  ApproveButtons(
                                    modelIndex: index,
                                  ),
                                )
                              : const DataCell(
                                  SizedBox(),
                                ),
                        ],
                      ),
                    ).toList(),
                  );
          }),
    );
  }
}
