import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  //flutter localNoticationPlagins
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static Future<void> onDidReceiveNotification(
      NotificationResponse notificationResponse) async {}

  //initialize the notificatio plugin
  static Future<void> init() async {


    //define the android initialize
    const AndroidInitializationSettings androidInitializationSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    // define ios Initialize settings
    const DarwinInitializationSettings iOSInitializationSettings =
    DarwinInitializationSettings();

    //combine Android and Ios initilizationSettings
    const InitializationSettings initializationSettings =
    InitializationSettings(
      android: androidInitializationSettings,
      iOS: iOSInitializationSettings,
    );

    //initialize the plugin with the specified settings
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotification,
      onDidReceiveBackgroundNotificationResponse: onDidReceiveNotification,
    );
    // request Notification permission for android
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  //show an instant notification

  static Future<void> showInstantNotification(String title, String body) async {
    // define Notification details

    const NotificationDetails platformChannelSpcifics = NotificationDetails(
        android: AndroidNotificationDetails(
          "channel_Id",
          "channel_Name",
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails());
    await flutterLocalNotificationsPlugin.show(
        0, title, body, platformChannelSpcifics);
  }

  //show Scedule Notification
  static Future<void> scheduleNotification(
      String title, String body, DateTime scheduledTimeDate) async {
    // define Notification details

    const NotificationDetails platformChannelSpcifics = NotificationDetails(
        android: AndroidNotificationDetails(
          "channel_Id",
          "channel_Name",
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails());
    await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        title,
        body,
        tz.TZDateTime.from(scheduledTimeDate, tz.local),
        platformChannelSpcifics,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dateAndTime


    );
  }

}
