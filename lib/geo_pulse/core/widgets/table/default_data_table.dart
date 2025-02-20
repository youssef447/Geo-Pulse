import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';

/// Default Data Table Style
class DefaultDataTable extends StatefulWidget {
  final List<DataColumn> columns;
  final List<DataRow> rows;
  final double? columnSpacing;

  const DefaultDataTable({
    super.key,
    required this.columns,
    required this.rows,
    this.columnSpacing,
  });

  @override
  State<DefaultDataTable> createState() => _DefaultDataTableState();
}

class _DefaultDataTableState extends State<DefaultDataTable> {
  bool _isOverflowing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkIntrinsicWidth();
    });
  }

  void _checkIntrinsicWidth() {
    final table = DefaultTable(
      columns: widget.columns,
      rows: widget.rows,
    );
    final tableWidth = getTableWidth(table);
    final screenWidth = MediaQuery.sizeOf(context).width - 32; // Screen width

    if (tableWidth > screenWidth) {
      setState(() {
        _isOverflowing = true;
      });
    }
  }

  double getTableWidth(Widget widget) {
    final repaintBoundary = RenderRepaintBoundary();

    final renderView = RenderView(
      view: View.of(context),
      child: RenderPositionedBox(
          alignment: Alignment.center, child: repaintBoundary),
      configuration: const ViewConfiguration(),
    );

    final pipelineOwner = PipelineOwner();
    final buildOwner = BuildOwner(focusManager: FocusManager());

    pipelineOwner.rootNode = renderView;
    renderView.prepareInitialFrame();

// Attach the widget's render object to the render tree
    final rootElement = RenderObjectToWidgetAdapter<RenderBox>(
            container: repaintBoundary, child: widget)
        .attachToRenderTree(buildOwner);

// Build and finalize the render tree
    buildOwner
      ..buildScope(rootElement)
      ..finalizeTree();

// Flush layout, compositing, and painting operations
    pipelineOwner
      ..flushLayout()
      ..flushCompositingBits()
      ..flushPaint();
    return renderView.child!.size.width;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      clipBehavior: Clip.none,
      child: _isOverflowing
          ? SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DefaultTable(
                columns: widget.columns,
                rows: widget.rows,
              ),
            )
          : DefaultTable(
              columns: widget.columns,
              rows: widget.rows,
            ),
    );
  }
}

class DefaultTable extends StatelessWidget {
  const DefaultTable({
    super.key,
    required this.columns,
    required this.rows,
  });

  final List<DataColumn> columns;
  final List<DataRow> rows;

  @override
  Widget build(BuildContext context) {
    var isLandScape = context.isLandscape;

    return DataTable(
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
      columnSpacing: 20.w,
      headingRowColor: WidgetStatePropertyAll(AppColors.secondaryPrimary),
      dataRowMinHeight: 46.h,
      dataRowMaxHeight: 46.h,
      headingRowHeight: 46.h,
      horizontalMargin: isLandScape ? 29.w : 16.w,
      dividerThickness: 0,
      showCheckboxColumn: false,
      columns: columns,
      rows: rows,
    );
  }
}
