// Objectives: This file is responsible for providing the get pages for the app.

import 'package:flutter/material.dart';

import '../../features/approvals/presentation/ui/pages/mobile/mobile_request_details.dart';
import '../../features/approvals/presentation/ui/pages/tablet/tablet_request_details.dart';
import '../../features/home/presentation/ui/pages/home_page.dart';
import '../../features/location/presentation/ui/pages/mobile/mobile_data_location.dart';
import '../../features/location/presentation/ui/pages/mobile/mobile_location_details.dart';
import '../../features/location/presentation/ui/pages/tablet/tablet_data_location.dart';
import '../../features/location/presentation/ui/pages/tablet/tablet_location_details.dart';
import '../../features/location/presentation/ui/pages/common/edit_location_google_map.dart';
import '../../features/location/presentation/ui/pages/common/location_google_map.dart';
import '../../features/notifications/presentation/ui/pages/mobile_notification_page.dart';
import '../../features/notifications/presentation/ui/pages/tablet_notification_page.dart';
import '../../features/request_type/presentation/ui/pages/mobile/mobile_request_type_details_page.dart';
import '../../features/request_type/presentation/ui/pages/mobile/mobile_request_type_page.dart';
import '../../features/request_type/presentation/ui/pages/tablet/tablet_request_type_details_page.dart';
import '../../features/request_type/presentation/ui/pages/tablet/tablet_request_type_page.dart';
import '../helpers/responsive_helper.dart';
import 'app_routes.dart';
import 'route_arguments.dart';

enum PageTransitionType {
  fade,
  slideFromRight,
  slideFromLeft,
  scale,
}

abstract class RouteGenerator {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    // Get arguments and route name
    final args = settings.arguments as Map<String, dynamic>? ?? {};
    final routeName = settings.name;

    // Define your routes with corresponding transitions
    switch (routeName) {
      case Routes.trackingHome:
        return _buildPageRoute(
          TrackingHomePage(
            user: args[RouteArguments.user],
            locationName: args[RouteArguments.locationName],
          ),
          PageTransitionType.fade,
        );
      case Routes.requestDetails:
        return _buildPageRoute(
          ResponsiveHelper(
            mobileWidget: MobileRequestDetails(
              index: args[RouteArguments.requestModelIndex],
            ),
            tabletWidget: TabletRequestDetails(
              index: args[RouteArguments.requestModelIndex],
            ),
          ),
          PageTransitionType.fade,
        );
      case Routes.locationDetails:
        return _buildPageRoute(
          ResponsiveHelper(
            mobileWidget: MobileLocationDetails(
              index: args[RouteArguments.locationModelIndex],
              readOnly: args[RouteArguments.readOnly],
            ),
            tabletWidget: TabletLocationDetails(
              index: args[RouteArguments.locationModelIndex],
              readOnly: args[RouteArguments.readOnly],
            ),
          ),
          PageTransitionType.fade,
        );
      case Routes.requestType:
        return _buildPageRoute(
          ResponsiveHelper(
            mobileWidget: MobileRequestTypePage(
              title: args[RouteArguments.title],
            ),
            tabletWidget: TabletRequestTypePage(
              title: args[RouteArguments.title],
            ),
          ),
          PageTransitionType.fade,
        );
      case Routes.requestTypeDetails:
        return _buildPageRoute(
          ResponsiveHelper(
            mobileWidget: MobileRequestTypeDetailsPage(),
            tabletWidget: TabletRequestTypeDetailsPage(),
          ),
          PageTransitionType.fade,
        );
      case Routes.notifications:
        return _buildPageRoute(
          ResponsiveHelper(
            mobileWidget: MobileNotificationPage(),
            tabletWidget: TabletNotificationPage(),
          ),
          PageTransitionType.fade,
        );
      case Routes.addLocation:
        return _buildPageRoute(
          ResponsiveHelper(
            mobileWidget: MobileDataLocation(
              isEdit: args[RouteArguments.edit],
            ),
            tabletWidget: TabletDataLocation(
              isEdit: args[RouteArguments.edit],
            ),
          ),
          PageTransitionType.fade,
        );

      case Routes.mapScreen:
        return _buildPageRoute(
          ResponsiveHelper(
            mobileWidget: MapScreen(
              isGeofencing: args[RouteArguments.isGeofencing],
            ),
            tabletWidget: MapScreen(
              isGeofencing: args[RouteArguments.isGeofencing],
            ),
          ),
          PageTransitionType.fade,
        );
      case Routes.mapEditScreen:
        return _buildPageRoute(
          ResponsiveHelper(
            mobileWidget: MapEditScreen(
              isGeofencing: args[RouteArguments.isGeofencing],
            ),
            tabletWidget: MapEditScreen(
              isGeofencing: args[RouteArguments.isGeofencing],
            ),
          ),
          PageTransitionType.fade,
        );
      case Routes.editLocation:
        return _buildPageRoute(
          ResponsiveHelper(
            mobileWidget: MapEditScreen(
              isGeofencing: args[RouteArguments.isGeofencing],
            ),
            tabletWidget: MapEditScreen(
              isGeofencing: args[RouteArguments.isGeofencing],
            ),
          ),
          PageTransitionType.fade,
        );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('Unknown route: $routeName')),
          ),
        );
    }
  }

  // Custom method to build a route with a transition
  static PageRouteBuilder<dynamic> _buildPageRoute(
      Widget page, PageTransitionType transitionType) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: const Duration(milliseconds: 400),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        switch (transitionType) {
          case PageTransitionType.fade:
            return FadeTransition(opacity: animation, child: child);
          case PageTransitionType.slideFromRight:
            return SlideTransition(
              position: animation.drive(
                Tween(begin: const Offset(1, 0), end: Offset.zero)
                    .chain(CurveTween(curve: Curves.easeInOut)),
              ),
              child: child,
            );
          case PageTransitionType.slideFromLeft:
            return SlideTransition(
              position: animation.drive(
                Tween(begin: const Offset(-1, 0), end: Offset.zero)
                    .chain(CurveTween(curve: Curves.easeInOut)),
              ),
              child: child,
            );
          case PageTransitionType.scale:
            return ScaleTransition(scale: animation, child: child);
          default:
            return child; // No animation
        }
      },
    );
  }
}
