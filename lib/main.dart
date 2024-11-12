
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:scofia/common/utils/constants.dart';
import 'package:scofia/features/onboarding/pages/onboarding.dart';
import 'package:scofia/features/todo/pages/default_home_page.dart';
import 'package:scofia/features/todo/pages/view_not.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:workmanager/workmanager.dart';
import 'common/helpers/background_task_manager.dart';
final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Workmanager().initialize(callbackDispatcher, isInDebugMode: false);

  // Handle app launch from terminated state
  tz.initializeTimeZones(); // Initialize timezone for notifications

  runApp(const ProviderScope(child: MyApp()));

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static final defaultLightColorScheme = ColorScheme.fromSwatch(
      primarySwatch: Colors.blue);

  static final defaultDarkColorScheme = ColorScheme.fromSwatch(
      brightness: Brightness.dark,
      primarySwatch: Colors.blue);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      useInheritedMediaQuery: true,
      designSize: const Size(375, 825),
      minTextAdapt: true,
      builder: (context, child) {
        return DynamicColorBuilder(
          builder: (lightColorScheme, darkColorScheme) {
            return OverlaySupport(
              child: GetMaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Scofia',
                theme: ThemeData(
                  colorScheme: lightColorScheme ?? defaultLightColorScheme,
                  useMaterial3: true,
                ),
                darkTheme: ThemeData(
                  scaffoldBackgroundColor: AppConst.kBkDark,
                  colorScheme: darkColorScheme ?? defaultDarkColorScheme,
                  useMaterial3: true,
                ),

                routes: {
                  "/": (context) => Onboarding(),
                  "/home": (context) => HomeScreen(),
                  '/notificationPage': (context) => NotificationViewPage(),
                },
              ),
            );
          },
        );
      },
    );
  }
}
