import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../extensions/extensions.dart';

import '../../constants/strings.dart';
import '../../helpers/spacing_helper.dart';
import '../../theme/app_text_styles.dart';
import 'date_picker_field.dart';
import 'time_picker_field.dart';

///
/// Row of start Date , end time fields
class DateImeField extends StatelessWidget {
  final TextEditingController dateController;
  final TextEditingController timeController;
  final Function(DateTime)? onStartDateChanged;
  final Function(TimeOfDay)? onTimeChanged;
  const DateImeField({
    super.key,
    required this.dateController,
    required this.timeController,
    required this.onStartDateChanged,
    required this.onTimeChanged,
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
                'Date'.tr,
                style: AppTextStyles.font14BlackCairoMedium,
              ),
              verticalSpace(8),
              DatePickerField(
                onDateChanged: onStartDateChanged,
                textEditingController: dateController,
                hintText: 'Choose Date'.tr,
                showIcon: true,
              ),
            ],
          ),
        ),
        horizontalSpace(
          context.isTablett ? 16 : 12,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppConstanst.time.tr,
                style: AppTextStyles.font14BlackCairoMedium,
              ),
              verticalSpace(8),
              TimePickerField(
                onDateChanged: onTimeChanged,
                showIcon: true,
                textEditingController: timeController,
                hintText: 'Choose Time'.tr,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
