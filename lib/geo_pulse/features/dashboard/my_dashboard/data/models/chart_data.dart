// Objectives: This file is responsible for providing a model used in reusable chart widgets.

import 'dart:ui';

class ChartData {
  final String xAxisLabel;
  final String xAxisLabelArabic;
  final int yAxisLabel;
  final Color? chartItemColor;

  ChartData({
    required this.xAxisLabel,
    required this.xAxisLabelArabic,
    required this.yAxisLabel,
    this.chartItemColor,
  });
}
