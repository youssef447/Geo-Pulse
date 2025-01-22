import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

class DefaultDatePickerDialog extends StatelessWidget {
  final DateRangePickerController dateRangePickerController;
  const DefaultDatePickerDialog(
      {super.key, required this.dateRangePickerController});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 458.h,
      width: 343.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        color: AppColors.dialog,
      ),
      child: Column(
        children: [
          SizedBox(
            height: 368.3.h,
            child: SfDateRangePicker(
              headerStyle: const DateRangePickerHeaderStyle(
                backgroundColor: Colors.transparent,
                textAlign: TextAlign.center,
              ),

              controller: dateRangePickerController,
              selectionShape: DateRangePickerSelectionShape.circle,
              view: DateRangePickerView.month,
              selectionTextStyle: AppTextStyles.font14BlackCairoRegular
                  .copyWith(color: AppColors.textButton),
              selectionColor: AppColors.primary,
              //cells in year view

              yearCellStyle: DateRangePickerYearCellStyle(
                disabledDatesTextStyle: AppTextStyles.font14SecondaryBlackCairo,
                textStyle: AppTextStyles.font14BlackCairoRegular,
                todayTextStyle: AppTextStyles.font14BlackCairoRegular,
              ),

              monthViewSettings: const DateRangePickerMonthViewSettings(
                viewHeaderHeight: 0,
              ),

              //cells in month view
              onViewChanged: (dateRangePickerViewChangedArgs) {},

              monthCellStyle: DateRangePickerMonthCellStyle(
                disabledDatesTextStyle: AppTextStyles.font14SecondaryBlackCairo,
                textStyle: AppTextStyles.font14BlackCairoRegular,
                todayTextStyle: AppTextStyles.font14BlackCairoRegular,
              ),

              backgroundColor: Colors.transparent,

              onSelectionChanged: (dateRangePickerSelectionChangedArgs) {},
              selectionMode: DateRangePickerSelectionMode.single,
            ),
          ),
        ],
      ),
    );
  }
}
