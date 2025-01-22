part of '../pages/home_page.dart';

class UserRowChildren extends StatelessWidget {
  final UserModel? user;
  final String? locationName;
  const UserRowChildren({super.key, this.user, this.locationName});

  @override
  Widget build(BuildContext context) {
    var isTablet = context.isTablett;

    return user != null
        ? Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                'Locations'.tr,
                style: isTablet
                    ? AppTextStyles.font28BlackSemiBoldCairo
                    : AppTextStyles.font26BlackSemiBoldCairo,
              ),
              SvgPicture.asset(
                context.isArabic ? AppAssets.arrowBack : AppAssets.arrowForward,
                width: 24.w,
                height: 24.h,
                color: AppColors.text,
              ),
              Text(
                locationName!,
                style: isTablet
                    ? AppTextStyles.font28BlackSemiBoldCairo
                    : AppTextStyles.font26BlackSemiBoldCairo,
              ),
              SvgPicture.asset(
                context.isArabic ? AppAssets.arrowBack : AppAssets.arrowForward,
                width: 24.w,
                height: 24.h,
                color: AppColors.text,
              ),
              Text(
                '${user!.firstName} ${user!.lastName}',
                style: isTablet
                    ? AppTextStyles.font28BlackSemiBoldCairo
                    : AppTextStyles.font26BlackSemiBoldCairo,
              ),
              const Spacer(),
              isTablet
                  ? const SizedBox()
                  : GetBuilder<CheckInController>(
                      builder: (controller) {
                        return controller.showHeader
                            ? const SizedBox()
                            : AppDefaultButton(
                                style: AppTextStyles.font14BlackCairoMedium
                                    .copyWith(
                                  color: AppColors.textButton,
                                ),
                                text: 'Check In'.tr,
                                width: 100,
                                height: 42,
                                onPressed: () {
                                  controller.toggleShowHeader();
                                },
                              );
                      },
                    )
            ],
          )
        : Row(
            children: [
              Text(
                'Geo Pulse'.tr,
                style: isTablet
                    ? AppTextStyles.font28BlackSemiBoldCairo
                    : AppTextStyles.font26BlackSemiBoldCairo,
              ),
              const Spacer(),
              isTablet
                  ? OrientationLayout(
                      portrait: (BuildContext context) => const SizedBox(),
                      landscape: (BuildContext context) =>
                          GetBuilder<CheckInController>(
                        builder: (controller) {
                          return controller.showHeader
                              ? const SizedBox()
                              : AppDefaultButton(
                                  style: AppTextStyles.font16BlackMediumCairo
                                      .copyWith(
                                    color: AppColors.textButton,
                                  ),
                                  text: 'Check In'.tr,
                                  width: 200.w,
                                  height: 45.h,
                                  onPressed: () {
                                    controller.toggleShowHeader();
                                  },
                                );
                        },
                      ),
                    )
                  : Get.find<CheckInController>().showHeader
                      ? GetBuilder<CheckInController>(
                          builder: (controller) {
                            return controller.showHeader
                                ? const SizedBox()
                                : AppDefaultButton(
                                    style: AppTextStyles.font14BlackCairoMedium
                                        .copyWith(
                                      color: AppColors.textButton,
                                    ),
                                    text: 'Check In'.tr,
                                    width: 100.w,
                                    height: 42.h,
                                    onPressed: () {
                                      controller.toggleShowHeader();
                                    },
                                  );
                          },
                        )
                      : const SizedBox()
            ],
          );
  }
}
