// this shared switch button in all app
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';

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
      scale: 0.7,
      child: FlutterSwitch(
        activeColor: AppColors.secondaryPrimary,
        inactiveColor: AppColors.lightGrey,
        value: value,
        onToggle: onChanged,
        // width: context.isTablett ? (context.isPortrait ? 70.w : 65.w) : 40.w,
        // height: context.isTablett ? (context.isPortrait ? 30.h : 35.h) : 30.h,
      ),
    );
  }
}
