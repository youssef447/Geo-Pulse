part of '../../pages/home_page.dart';

class DefaultShowcase extends StatelessWidget {
  const DefaultShowcase({
    super.key,
    required this.showcasekey,
    required this.description,
    required this.type,
    required this.child,
  });
  final GlobalKey showcasekey;
  final String description;
  final Widget child;
  final ShowcaseTypes type;

  @override
  Widget build(BuildContext context) {
    return Showcase(
      key: showcasekey,
      description: description,
      tooltipBackgroundColor: AppColors.primary,
      descTextStyle: AppTextStyles.font12BlackCairo,
      titlePadding: EdgeInsets.all(8.w),
      targetPadding: EdgeInsets.all(8.w),
      tooltipPadding: EdgeInsets.symmetric(vertical: 4.h),
      targetShapeBorder: const CircleBorder(),
      tooltipActionConfig:
          TooltipActionConfig(position: TooltipActionPosition.outside),
      tooltipActions: getToolTipList(type),
      blurValue: 1.5,
      child: child,
    );
  }

  List<TooltipActionButton>? getToolTipList(ShowcaseTypes type) {
    switch (type) {
      case ShowcaseTypes.first:
        return [
          TooltipActionButton(
            type: TooltipDefaultActionType.next,
            backgroundColor: AppColors.primary,
            textStyle:
                AppTextStyles.font14BlackCairo.copyWith(color: Colors.white),
          )
        ];
      case ShowcaseTypes.middle:
        return [
          TooltipActionButton(
            type: TooltipDefaultActionType.previous,
            backgroundColor: AppColors.primary,
            textStyle:
                AppTextStyles.font14BlackCairo.copyWith(color: Colors.white),
          ),
          TooltipActionButton(
            type: TooltipDefaultActionType.next,
            backgroundColor: AppColors.primary,
            textStyle:
                AppTextStyles.font14BlackCairo.copyWith(color: Colors.white),
          )
        ];
      case ShowcaseTypes.last:
        return [
          TooltipActionButton(
            name: 'Finish',
            type: TooltipDefaultActionType.next,
            backgroundColor: AppColors.primary,
            textStyle:
                AppTextStyles.font14BlackCairo.copyWith(color: Colors.white),
          )
        ];
    }
  }
}

enum ShowcaseTypes { first, middle, last }
