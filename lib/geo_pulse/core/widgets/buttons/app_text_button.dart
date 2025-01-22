import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../helpers/haptic_feedback_helper.dart';

class AppTextButton extends StatelessWidget {
  const AppTextButton({
    super.key,
    required this.onPressed,
    required this.borderRadius,
    required this.backgroundColor,
    this.text,
    this.textStyle,
    this.customWidget,
    this.height,
    this.width,
  });

  final Function() onPressed;
  final double? width;
  final double? height;
  final String? text;
  final TextStyle? textStyle;
  final Color backgroundColor;
  final double borderRadius;
  final Widget? customWidget;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: TextButton(
        onPressed: () {
          HapticFeedbackHelper.triggerHapticFeedback(
            vibration: VibrateType.mediumImpact,
            hapticFeedback: HapticFeedback.mediumImpact,
          );
          onPressed.call();
        },
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(
            backgroundColor,
          ),
          overlayColor: WidgetStateProperty.all(Colors.transparent),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          ),
        ),
        child: customWidget ??
            Text(
              text ?? 'Click'.tr,
              style: textStyle,
            ),
      ),
    );
  }
}
