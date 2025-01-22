import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../extensions/extensions.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

class DefaultDropdown extends StatelessWidget {
  final bool enabled;
  final Function()? onOpened, onCanceled;
  final Widget child;
  final dynamic initialValue;
  final List<String> popupMenuItems;
  final Function(dynamic)? onSelected;
  final double? height, width;
  final bool noPadding;
  final bool haveConstraintsForMenu;

  const DefaultDropdown({
    super.key,
    required this.enabled,
    required this.child,
    required this.popupMenuItems,
    this.initialValue,
    this.onOpened,
    this.onCanceled,
    this.height,
    this.width,
    this.onSelected,
    this.noPadding = false,
    this.haveConstraintsForMenu = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? (context.isTablett ? 69.h : 56.h),
      width: width ?? double.infinity,
      padding: noPadding == true
          ? null
          : EdgeInsetsDirectional.only(
              start: 8.w,
            ),
      decoration: BoxDecoration(
        color: AppColors.field,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: Colors.transparent,
        ),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          highlightColor: AppColors.primary,
          splashColor: Colors.transparent,
        ),
        child: PopupMenuButton(
          enabled: enabled,
          onOpened: onOpened,
          onCanceled: onCanceled ?? onOpened,
          color: AppColors.card,
          offset: const Offset(0, 0),
          initialValue: initialValue,
          constraints: haveConstraintsForMenu == true
              ? BoxConstraints(
                  minWidth: width ?? (context.isTablett ? 250.w : 100.w),
                  maxWidth: width ?? (context.isTablett ? 250.w : 100.w))
              : null,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
            side: BorderSide.none,
          ),
          position: PopupMenuPosition.under,
          padding: EdgeInsets.zero,
          onSelected: onSelected,
          itemBuilder: (context) {
            return popupMenuItems.map(
              (item) {
                return PopupMenuItem(
                  value: item,
                  child: Align(
                    alignment: AlignmentDirectional.bottomStart,
                    child: Text(
                      item.tr,
                      style: AppTextStyles.font12BlackCairoRegular,
                    ),
                  ),
                );
              },
            ).toList();
          },
          child: child,
        ),
      ),
    );
  }
}
