// Objectives: This file is responsible for providing the main widget of the application.

import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:toastification/toastification.dart';
import 'package:geo_pulse/geo_pulse/core/extensions/extensions.dart';
import 'package:geo_pulse/geo_pulse/core/constants/languages.dart';
import 'package:geo_pulse/geo_pulse/core/di/injection.dart';
import 'package:geo_pulse/geo_pulse/core/helpers/getx_cache_helper.dart';
import 'package:geo_pulse/geo_pulse/core/routes/app_routes.dart';
import 'package:geo_pulse/geo_pulse/core/routes/get_pages.dart';
import 'package:geo_pulse/geo_pulse/core/theme/app_theme.dart';
//import 'package:geo_pulse/geo_pulse/features/notification_serevice/notification_controller.dart';
import 'package:geo_pulse/geo_pulse/features/notification_serevice/services/local_notification_service.dart';
import 'package:window_manager/window_manager.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // init Dependencies
  await GetXCacheHelper.init();

  await ScreenUtil.ensureScreenSize();
  configurationDependencies();
  await AppTheme.initTheme();
  // set min size for desktop window
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    await windowManager.ensureInitialized();
    WindowManager.instance.setMinimumSize(const Size(375, 812));
  }

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  if (!Platform.isWindows && !Platform.isLinux && !Platform.isMacOS) {
    await LocalNotificationService.initialize();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      LocalNotificationService.showNotification(message);
    });
  }
  _checkPermission();
  // Run the app
  runApp(const GeoPulse());
}

Future<void> _checkPermission() async {
  var status = await Permission.location.status;

  if (status.isGranted) {
  } else if (status.isDenied) {
    // Request permission
    if (await Permission.location.request().isGranted) {
    } else {}
  } else if (status.isPermanentlyDenied) {
    openAppSettings();
  }
}

class GeoPulse extends StatelessWidget {
  const GeoPulse({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      minTextAdapt: true,
      splitScreenMode: true,
      designSize: context.isTablett
          ? (context.isLandscape
              ? const Size(1024, 800)
              : const Size(768, 1024))
          : context.isLandscape
              ? const Size(812, 900)
              : const Size(375, 812),
      fontSizeResolver: (fontSize, instance) =>
          FontSizeResolvers.height(fontSize, instance),
      builder: (_, child) {
        return ToastificationWrapper(
          child: GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Geo Pulse',
            home: Column(
              children: [
                Expanded(
                  child: Navigator(
                    key: navKey,
                    onGenerateRoute: RouteGenerator.generateRoute,
                    initialRoute: Routes.trackingHome,
                  ),
                ),
              ],
            ),

            // Theme
            themeMode:
                AppTheme.isDark ?? false ? ThemeMode.dark : ThemeMode.light,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,

            // Localization
            translations: Languages(),
            locale: const Locale('en', 'US'),
            fallbackLocale: const Locale('en', 'US'),
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en'),
              Locale('ar'),
            ],
          ),
        );
      },
    );
  }
}
