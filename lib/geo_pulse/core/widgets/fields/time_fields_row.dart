import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../extensions/extensions.dart';

import '../../helpers/spacing_helper.dart';
import '../../theme/app_text_styles.dart';
import 'time_picker_field.dart';

///Row of start time , end time fields
class TimeFieldsRow extends StatelessWidget {
  final TextEditingController startTimeController;
  final TextEditingController endTimeController;
  const TimeFieldsRow({
    super.key,
    required this.startTimeController,
    required this.endTimeController,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Start Time'.tr,
                style: AppTextStyles.font14BlackCairoMedium,
              ),
              verticalSpace(16),
              TimePickerField(
                textEditingController: startTimeController,
                hintText: 'Choose Time'.tr,
              ),
            ],
          ),
        ),
        horizontalSpace(
          context.isTablett ? 12 : 16,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'End Time'.tr,
                style: AppTextStyles.font14BlackCairoMedium,
              ),
              verticalSpace(16),
              TimePickerField(
                textEditingController: endTimeController,
                hintText: 'Choose Time'.tr,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
