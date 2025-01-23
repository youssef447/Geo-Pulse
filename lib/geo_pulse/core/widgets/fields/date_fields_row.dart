import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../extensions/extensions.dart';

import '../../helpers/spacing_helper.dart';
import '../../theme/app_text_styles.dart';
import 'date_picker_field.dart';

///Row of start date , end date fields
class DateFieldsRow extends StatelessWidget {
  final TextEditingController startDateController;
  final TextEditingController endDateController;
  final Function(DateTime)? onStartDateChanged;
  final Function(DateTime)? onEndDateChanged;

  const DateFieldsRow({
    super.key,
    required this.startDateController,
    required this.endDateController,
    required this.onStartDateChanged,
    required this.onEndDateChanged,
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
                'Start Date'.tr,
                style: AppTextStyles.font14BlackCairoMedium,
              ),
              verticalSpace(12),
              DatePickerField(
                onDateChanged: onStartDateChanged,
                textEditingController: startDateController,
                hintText: 'Choose Date'.tr,
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
                'End Date'.tr,
                style: AppTextStyles.font14BlackCairoMedium,
              ),
              verticalSpace(12),
              DatePickerField(
                onDateChanged: onEndDateChanged,
                textEditingController: endDateController,
                hintText: 'Choose Date'.tr,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
