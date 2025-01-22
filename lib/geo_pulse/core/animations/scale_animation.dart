import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../features/home/presentation/controller/controller/tracking_home_controller.dart';

///Adding Scale Effect to a given child
class ScaleAnimation extends StatefulWidget {
  final Widget child;

  final double delay;
  final Duration? duration;
  const ScaleAnimation({
    super.key,
    required this.child,
    this.delay = 0.0,
    this.duration,
  });

  @override
  ScaleAnimationState createState() => ScaleAnimationState();
}

class ScaleAnimationState extends State<ScaleAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scaleAnimation, fadeAnimation;
  final bool isAnimatable = Get.find<TrackingHomeController>().isAnimatable;
  @override
  void initState() {
    super.initState();
    if (isAnimatable) {
      controller = AnimationController(
        vsync: this,
        duration: widget.duration ??
            const Duration(
              milliseconds: 600,
            ),
      );

      scaleAnimation = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: controller,
          curve: Curves.ease,
        ),
      );
      fadeAnimation = Tween<double>(begin: -0.5, end: 1).animate(
        CurvedAnimation(
          parent: controller,
          curve: Curves.ease,
        ),
      );
      Future.delayed(Duration(milliseconds: (500 + widget.delay).round()))
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
            child: ScaleTransition(
              scale: scaleAnimation,
              child: widget.child,
            ),
          )
        : widget.child;
  }
}
