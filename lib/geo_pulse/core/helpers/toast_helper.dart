import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'dart:io' show Platform;

import 'package:toastification/toastification.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_theme.dart';

///Helper Toast that helps configure what to use based on platform
abstract class FlutterToastHelper {
  static showToast({
    Color? backgroundColor,
    required String msg,
  }) {
    if (Platform.isWindows || Platform.isMacOS) {
      toastification.show(
        closeButtonShowType: CloseButtonShowType.none,
        borderSide: BorderSide.none,
        context: Get.context,
        title: Text(
          msg.tr,
          style: AppTextStyles.font14BlackCairoRegular
              .copyWith(color: AppColors.textButton),
        ),
        backgroundColor: AppColors.primary,
        autoCloseDuration: const Duration(seconds: 3),
        showIcon: false,
        showProgressBar: false,
        alignment: Alignment.center,
      );
    } else {
      Fluttertoast.showToast(
        msg: msg.tr,
        backgroundColor: AppColors.primary,
        textColor: AppTheme.contrastColor(),
      );
    }
  }
}
