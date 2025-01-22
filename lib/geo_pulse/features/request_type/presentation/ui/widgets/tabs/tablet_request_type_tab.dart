import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../../../../core/extensions/extensions.dart';
import '../../../../../../core/constants/enums.dart';

import '../../../../../../core/helpers/get_dialog_helper.dart';
import '../../../../../../core/helpers/haptic_feedback_helper.dart';
import '../../../../../../core/helpers/responsive_helper.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_text_styles.dart';
import '../../../../../../core/widgets/loading/circle_progress.dart';
import '../../../../../../core/widgets/no_data_gif.dart';
import '../../../../../../core/widgets/table/default_data_table.dart';
import '../../../../constants/table_columns.dart';
import '../../../controller/request_types_controller.dart';
import '../../pages/mobile/mobile_request_type_details_page.dart';
import '../../pages/tablet/tablet_request_type_details_page.dart';
import '../request_type_dropdown_button.dart';

///Request Type tab in Tablet
class TabletRequestsTypeTab extends StatefulWidget {
  const TabletRequestsTypeTab({
    super.key,
    required this.readOnly,
  });

  final bool readOnly;

  @override
  State<TabletRequestsTypeTab> createState() => _TabletRequestsTypeTabState();
}

class _TabletRequestsTypeTabState extends State<TabletRequestsTypeTab> {
  @override
  void initState() {
    Get.find<RequestTypeController>().getRequestTypes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.readOnly) {
      Get.find<RequestTypeController>().tableColumns =
          RequestTypeColumnsConstants.readOnlyRequestTypeHeaders;
    } else {
      Get.find<RequestTypeController>().tableColumns =
          RequestTypeColumnsConstants.requestTypeHeaders;
    }
    return SliverToBoxAdapter(
      child: GetBuilder<RequestTypeController>(
          id: 'requestType',
          builder: (controller) {
            if (controller.isGettingRequestTypes) {
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
            return controller.requestTypeModels.isEmpty
                ? const NoDataGif()
                : DefaultDataTable(
                    columns: Get.find<RequestTypeController>()
                        .tableColumns
                        .map(
                          (element) => DataColumn(
                            label: Text(
                              textAlign: TextAlign.center,
                              element.tr,
                              style: AppTextStyles.font16WhiteRegularCairo,
                            ),
                          ),
                        )
                        .toList(),
                    rows: List.generate(
                      controller.requestTypeModels.length,
                      (index) => DataRow(
                        onSelectChanged: (value) {
                          HapticFeedbackHelper.triggerHapticFeedback(
                            vibration: VibrateType.mediumImpact,
                            hapticFeedback: HapticFeedback.mediumImpact,
                          );
                          controller.setSelectedRequestType(
                            controller.requestTypeModels[index],
                          );
                          GetDialogHelper.generalDialog(
                            child: const ResponsiveHelper(
                              mobileWidget: MobileRequestTypeDetailsPage(),
                              tabletWidget: TabletRequestTypeDetailsPage(),
                            ),
                            context: context,
                          );
                        },
                        color: WidgetStatePropertyAll(
                          index % 2 == 0
                              ? AppColors.evenRowColor
                              : AppColors.oddRowColor,
                        ),
                        cells: [
                          DataCell(
                            Text(
                              textAlign: TextAlign.center,
                              context.isArabic
                                  ? controller
                                      .requestTypeModels[index].arabicName
                                  : controller
                                      .requestTypeModels[index].englishName,
                              style: AppTextStyles.font16BlackRegularCairo,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          DataCell(
                            Text(
                              textAlign: TextAlign.center,
                              context.isArabic
                                  ? controller.requestTypeModels[index]
                                      .arabicDescription
                                  : controller.requestTypeModels[index]
                                      .englishDescription,
                              style: AppTextStyles.font16BlackRegularCairo,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          DataCell(
                            Text(
                              textAlign: TextAlign.center,
                              controller.requestTypeModels[index].hrApproval
                                  .getName.tr,
                              style: AppTextStyles.font16BlackRegularCairo,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          DataCell(
                            Text(
                              textAlign: TextAlign.center,
                              controller.requestTypeModels[index]
                                  .addingDescription.getName.tr,
                              style: AppTextStyles.font14BlackRegularCairo,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          DataCell(
                            Text(
                              textAlign: TextAlign.center,
                              controller.requestTypeModels[index]
                                  .addingAttachments.getName.tr,
                              style: AppTextStyles.font14BlackRegularCairo,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (!widget.readOnly)
                            DataCell(
                              RequestTypeDropdownButton(index: index),
                            ),
                        ],
                      ),
                    ).toList(),
                  );
          }),
    );
  }
}
