import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:geo_pulse/geo_pulse/core/extensions/extensions.dart';

import '../../theme/app_colors.dart';

class DefaultSwitchButton extends StatelessWidget {
  const DefaultSwitchButton({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: context.isTablett ? 0.7 : 0.6,
      child: FlutterSwitch(
        activeColor: AppColors.secondaryPrimary,
        inactiveColor: AppColors.lightGrey,
        value: value,
        onToggle: onChanged,
        // width: context.isTablett ? (context.isPortrait ? 70.w : 65.w) : 40.w,
        //  height: context.isTablett ? 35.h : 30.h,
      ),
    );
  }
}
