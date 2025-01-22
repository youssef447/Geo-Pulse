// Objectives: This file is responsible for providing an orientation layout widget that changes based on the screen orientation.

import 'package:flutter/material.dart';

class OrientationLayout extends StatelessWidget {
  final WidgetBuilder portrait, landscape;

  const OrientationLayout({
    super.key,
    required this.portrait,
    required this.landscape,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        var orientation = MediaQuery.of(context).orientation;

        if (orientation == Orientation.portrait) {
          return portrait(context);
        } else {
          return landscape(context);
        }
      },
    );
  }
}
