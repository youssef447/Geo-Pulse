import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../../core/helpers/spacing_helper.dart';
import '../../../../../../core/helpers/validation_helper.dart';
import '../../../../../../core/theme/app_text_styles.dart';
import '../../../../../../core/widgets/fields/default_form_field.dart';
import '../../../../../../features/request_type/presentation/controller/request_types_controller.dart';

/// Objectives: This file is responsible for providing the label form field widget used to display a label and a text field in a column.

class LabelFormField extends GetView<RequestTypeController> {
  const LabelFormField({
    super.key,
    required this.editEnabled,
    required this.text,
    required this.hintText,
    required this.textController,
    required this.crossA,
    this.maxLength,
    this.expand,
    this.isRTL = false,
    this.helperText,
  });
  final String text;
  final String hintText;
  final TextEditingController textController;
  final bool editEnabled;
  final bool isRTL;
  final int? maxLength;
  final bool? expand;
  final CrossAxisAlignment crossA;
  final String? helperText;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: crossA,
      children: [
        Text(
          text,
          style: AppTextStyles.font14BlackCairoMedium,
        ),
        verticalSpace(8),
        AppTextFormField(
          helperText: helperText,
          enabled: editEnabled,
          readOnly: !editEnabled,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 8.w,
            vertical: 8.h,
          ),
          minLines: expand != null ? 3 : 1,
          alignCounterTextLeft: isRTL,
          maxLength: editEnabled ? maxLength : null,
          showCounter: editEnabled ? maxLength != null : false,
          textAlign: isRTL ? TextAlign.right : TextAlign.left,
          controller: textController,
          width: double.infinity,
          showBorder: true,
          hintText: hintText,
          onChanged: (p0) {
            controller.setIsValid();
          },
          validator: (value) {
            // if is arabic text field
            if (isRTL) {
              if (value!.isEmpty) {
                return ValidationHelper.isEmpty(value, 'This field is'.tr);
              }
              return ValidationHelper.isArabic(value);
            } else {
              if (value!.isEmpty) {
                return ValidationHelper.isEmpty(value, 'This field is'.tr);
              }
              return ValidationHelper.isEnglish(value);
            }
          },
        ),
      ],
    );
  }
}
