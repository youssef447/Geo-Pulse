import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../extensions/extensions.dart';

import '../../helpers/date_time_helper.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

/// Objectives: This file is responsible for providing default text form field widget that is used in the app.
class AppTextFormField extends StatelessWidget {
  const AppTextFormField({
    super.key,
    this.contentPadding,
    this.focusedBorder,
    this.showBorder,
    this.enabledBorder,
    this.textAlign,
    this.width,
    this.inputTextStyle,
    this.hintStyle,
    this.style,
    this.hintText,
    this.isObscureText,
    this.suffixIcon,
    this.backGroundColor,
    this.onChanged,
    this.controller,
    this.validator,
    this.prefixIcon,
    this.prefixIcon2,
    this.label,
    this.readOnly,
    this.enabled,
    this.onTap,
    this.top,
    this.bottom,
    this.maxLength,
    this.expands,
    this.keyboardType,
    this.autovalidateMode,
    this.height,
    this.labelText,
    this.minLines,
    this.maxLines,
    this.collapsed,
    this.defaultHeight,
    this.textDirection,
    this.alignCounterTextLeft = false,
    this.showCounter = false,
    this.helperText,
  });

  final TextAlign? textAlign;
  final int? maxLength;
  final bool? defaultHeight;
  final bool? collapsed;
  final EdgeInsetsGeometry? contentPadding;
  final Function(String)? onChanged;
  final InputBorder? focusedBorder;
  final InputBorder? enabledBorder;
  final TextStyle? inputTextStyle;
  final TextStyle? hintStyle, style;
  final String? hintText;
  final bool? isObscureText, readOnly, enabled, showBorder;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final Widget? prefixIcon2;
  final Widget? label;
  final Color? backGroundColor;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final double? top, bottom;
  final double? height;
  final double? width;
  final AutovalidateMode? autovalidateMode;
  final void Function()? onTap;
  final bool? expands;
  final TextInputType? keyboardType;
  final String? labelText;
  final int? minLines;
  final int? maxLines;
  final TextDirection? textDirection;
  final bool alignCounterTextLeft;
  final bool showCounter;
  final String? helperText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      buildCounter: showCounter
          ? (
              _, {
              required currentLength,
              required isFocused,
              maxLength,
            }) {
              String? errorMessage = validator?.call(controller?.text);

              return Row(
                textDirection: alignCounterTextLeft
                    ? TextDirection.rtl
                    : TextDirection.ltr,
                children: [
                  if (errorMessage != null &&
                      errorMessage.isNotEmpty &&
                      isFocused)
                    Text(
                      errorMessage,
                      style: AppTextStyles.font12RedRegularCairo,
                    ),
                  const Spacer(),
                  Text(
                    "${DateTimeHelper.formatInt(currentLength)}/${DateTimeHelper.formatInt(maxLength ?? 0)}",
                    style: GoogleFonts.cairo(
                      color: AppColors.lightGrey,
                      fontWeight: FontWeight.w400,
                      fontSize: context.isTablett ? 13.sp : 10.sp,
                    ),
                  ),
                ],
              );
            }
          : null,
      textDirection: textDirection,
      textInputAction: TextInputAction.done,
      keyboardType: keyboardType,
      expands: expands ?? false,
      autovalidateMode: autovalidateMode ?? AutovalidateMode.onUserInteraction,
      onTap: onTap,
      controller: controller,
      onChanged: onChanged,
      minLines: minLines,
      maxLines: maxLines,
      readOnly: readOnly ?? false,
      enabled: enabled,
      maxLength: maxLength,
      textAlignVertical: TextAlignVertical.center,
      textAlign: textAlign ?? TextAlign.start,
      cursorColor: AppColors.primary,
      decoration: InputDecoration(
        helperText: helperText,
        counterStyle: GoogleFonts.cairo(
          color: AppColors.lightGrey,
          fontWeight: FontWeight.w400,
          fontSize: context.isTablett ? 13.sp : 10.sp,
        ),
        hintStyle: context.isTablett
            ? AppTextStyles.font16SecondaryBlackCairo
            : AppTextStyles.font14SecondaryBlackCairo,
        isCollapsed: collapsed,
        errorStyle: AppTextStyles.font12RedRegularCairo,
        labelText: labelText,
        prefixIcon: prefixIcon != null
            ? Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: context.isTablett ? 16.w : 9.33.w,
                  vertical: context.isTablett ? 7.65.h : 4.65.w,
                ),
                child: prefixIcon,
              )
            : null,
        label: label,
        contentPadding: contentPadding,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide.none,
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide.none,
        ),
        enabledBorder: showBorder ?? false
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide.none,
              )
            : InputBorder.none,
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: const BorderSide(
            color: Colors.red,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: const BorderSide(
            color: Colors.red,
          ),
        ),
        hintText: hintText,
        suffixIcon: suffixIcon != null
            ? Padding(
                padding: EdgeInsetsDirectional.only(
                    end: context.isTablett ? 8.w : 6.w,
                    top: context.isTablett ? 10.h : 12.h,
                    bottom: context.isTablett ? 10.h : 12.h),
                child: suffixIcon,
              )
            : null,
        fillColor: backGroundColor ?? AppColors.field,
        filled: true,
      ),
      obscureText: isObscureText ?? false,
      style: style ??
          (context.isTablett
              ? AppTextStyles.font16BlackMediumCairo
              : AppTextStyles.font14BlackCairoMedium),
      validator: validator,
    );
  }
}
