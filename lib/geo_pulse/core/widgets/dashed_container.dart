import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_colors.dart';

///shown when there is empty data in the table
class DashedContainer extends StatelessWidget {
  const DashedContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 0.5.h,
      width: 10.w,
      color: AppColors.text,
    );
  }
}
