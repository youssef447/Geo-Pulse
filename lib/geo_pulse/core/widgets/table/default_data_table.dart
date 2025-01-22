import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';

///Default Table Style
class DefaultDataTable extends StatelessWidget {
  final List<DataColumn> columns;
  final List<DataRow> rows;
  final double? columnSpacing;
  final bool? noScroll;
  const DefaultDataTable({
    super.key,
    required this.columns,
    required this.rows,
    this.columnSpacing,
    this.noScroll,
  });

  @override
  Widget build(BuildContext context) {
    var isLandScape = context.isLandscape;

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      clipBehavior: Clip.none,
      child: noScroll ?? false
          ? DataTable(
              clipBehavior: Clip.antiAlias,
              border: TableBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8.r),
                  topRight: Radius.circular(8.r),
                ),
                horizontalInside: BorderSide(
                  width: 0,
                  color: AppTheme.isDark ?? false
                      ? const Color(0xFF000000)
                      : AppColors.card,
                ),
              ),
              columnSpacing: 60.w, //columnSpacing,
              headingRowColor:
                  WidgetStatePropertyAll(AppColors.secondaryPrimary),
              dataRowMinHeight: 46.h,
              dataRowMaxHeight: 46.h,
              headingRowHeight: 46.h,
              horizontalMargin: isLandScape ? 29.w : 16.w,
              dividerThickness: 0,
              showCheckboxColumn: false,
              columns: columns,
              rows: rows,
            )
          : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                border: TableBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8.r),
                    topRight: Radius.circular(8.r),
                  ),
                  horizontalInside: BorderSide(
                    width: 0,
                    color: AppTheme.isDark ?? false
                        ? const Color(0xFF000000)
                        : AppColors.card,
                  ),
                ),
                columnSpacing: 60.w, //columnSpacing,
                headingRowColor:
                    WidgetStatePropertyAll(AppColors.secondaryPrimary),
                dataRowMinHeight: 46.h,
                dataRowMaxHeight: 46.h,
                headingRowHeight: 46.h,
                horizontalMargin: isLandScape ? 29.w : 16.w,
                dividerThickness: 0,
                showCheckboxColumn: false,
                columns: columns,
                rows: rows,
              ),
            ),
    );
  }
}
