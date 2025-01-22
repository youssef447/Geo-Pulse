// Objectives: This file is responsible for providing an adaptive layout widget that changes based on the screen size.

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdaptiveLayout extends StatelessWidget {
  final WidgetBuilder mobileLayout, tabletLayout;

  const AdaptiveLayout({
    super.key,
    required this.mobileLayout,
    required this.tabletLayout,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: ((context, constraints) {
        if (constraints.maxWidth < 600 && context.isPhone) {
          return mobileLayout(context);
        } else {
          return tabletLayout(context);
        }
      }),
    );
  }
}
