part of '../../pages/home_page.dart';

class HomeAppbar extends GetView<TrackingHomeController> {
  final bool hideLeading;
  const HomeAppbar({required this.hideLeading, super.key});

  @override
  Widget build(BuildContext context) {
    return CustomAppBar(
      hideLeading: hideLeading,
      title: ''.tr,
      centerTitle: false,
      actionWidget: Row(
        children: [
          AnimatedToggleSwitch<bool>.size(
            current: controller.isArabic,
            values: const [false, true],
            iconOpacity: 1,
            height: 26.h,
            indicatorSize: Size.fromWidth(40.w),
            customIconBuilder: (context, isArabic, global) => Text(
              isArabic.value ? 'AR'.tr : 'ENG'.tr,
              style: TextStyle(
                fontSize: 12.sp,
                color: global.active ? AppColors.icon : AppColors.primary,
              ),
            ),
            borderWidth: 1,
            iconAnimationType: AnimationType.onSelected,
            style: ToggleStyle(
              backgroundColor: AppColors.background,
              indicatorColor: AppColors.secondaryPrimary,
              borderColor: AppColors.border,
              borderRadius: BorderRadius.circular(10.r),
            ),
            onChanged: (value) {
              controller.isArabic = value;
              controller.toggleLanguage();
            },
          ),
          horizontalSpace(6),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 650),
            transitionBuilder: (child, anim) => RotationTransition(
              turns: child.key == ValueKey('dark')
                  ? Tween<double>(begin: 0.85, end: 1).animate(anim)
                  : Tween<double>(begin: 0.75, end: 1).animate(anim),
              child: ScaleTransition(
                scale: anim,
                child: child,
              ),
            ),
            child: Icon(
                key: AppTheme.isDark ?? false
                    ? ValueKey('dark')
                    : ValueKey('light'),
                AppTheme.isDark ?? false
                    ? Icons.nightlight_round_sharp
                    : Icons.wb_sunny,
                size: 30.sp,
                color: AppTheme.isDark ?? false
                    ? AppColors.icon
                    : AppColors.yellow),
          ),
          DefaultSwitchButton(
            value: AppTheme.isDark ?? false,
            onChanged: (bool value) async {
              AppTheme.toggleTheme();
            },
          ),
          /*   DefaultSwitchButton(
            value: controller.isAnimatable,
            onChanged: (bool value) async {
              controller.toggleAnimation();
            },
          ), */
        ],
      ),
    );
  }
}