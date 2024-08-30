import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:scofia/common/helpers/notify.dart';
import 'package:scofia/common/utils/constants.dart';
import 'package:scofia/features/auth/pages/test.dart';
import 'package:scofia/features/onboarding/pages/onboarding.dart';
import 'package:scofia/features/todo/pages/HomePage.dart';
import 'package:scofia/features/todo/pages/default_home_page.dart';
import 'package:scofia/features/todo/pages/view_not.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.init();
  tz.initializeTimeZones();
  runApp(const ProviderScope(child:  MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static final defaultLightColorScheme = ColorScheme.fromSwatch(
    primarySwatch: Colors.blue);

  static final defaultDarkColorScheme = ColorScheme.fromSwatch(
    brightness: Brightness.dark,
      primarySwatch: Colors.blue);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      useInheritedMediaQuery: true,
      designSize:const Size(375, 825),
      minTextAdapt: true,

      builder: (context,child) {
        return DynamicColorBuilder(
          builder: (lightColorScheme, darkColorScheme) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Scofia',

              theme: ThemeData(
                scaffoldBackgroundColor: AppConst.kBkDark,
                colorScheme:lightColorScheme?? defaultLightColorScheme,
                useMaterial3: true,
              ),
              darkTheme: ThemeData(
                scaffoldBackgroundColor: AppConst.kBkDark,
                colorScheme: darkColorScheme?? defaultDarkColorScheme,
                useMaterial3: true,
              ),
              themeMode: ThemeMode.dark,
              home:Onboarding(),
            );
          }
        );
      }
    );
  }
}


