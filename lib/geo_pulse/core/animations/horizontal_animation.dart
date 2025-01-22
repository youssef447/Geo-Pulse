import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../features/home/presentation/controller/controller/tracking_home_controller.dart';

///Adding Horizontal animation  to a given child, used in message bubble
class SlideAnimation extends StatefulWidget {
  final Widget child;

  ///reverse the animation to be Down To Up
  final bool? leftToRight;
  final double delay;
  const SlideAnimation({
    super.key,
    required this.child,
    this.leftToRight,
    this.delay = 0.0,
  });

  @override
  SlideAnimationState createState() => SlideAnimationState();
}

class SlideAnimationState extends State<SlideAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<Offset> translateAnimation;
  late Animation<double> fadeAnimation;
  final bool isAnimatable = Get.find<TrackingHomeController>().isAnimatable;

  @override
  void initState() {
    super.initState();
    if (isAnimatable) {
      controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 620),
      );
      translateAnimation = Tween<Offset>(
        begin: widget.leftToRight ?? false
            ? const Offset(-1, 0)
            : const Offset(1, 0),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: controller,
          curve: Curves.fastEaseInToSlowEaseOut,
        ),
      );
      fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: controller,
          curve: Curves.ease,
        ),
      );
      Future.delayed(Duration(milliseconds: (500 * widget.delay).round()))
          .then((value) {
        controller.forward();
      });
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isAnimatable
        ? FadeTransition(
            opacity: fadeAnimation,
            child: SlideTransition(
              position: translateAnimation,
              child: widget.child,
            ),
          )
        : widget.child;
  }
}
