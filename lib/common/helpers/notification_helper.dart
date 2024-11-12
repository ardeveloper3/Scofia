import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:scofia/common/helpers/generatetts_file.dart';
import 'package:scofia/common/models/task_model.dart';
import 'package:scofia/features/todo/pages/view_not.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
class NotificationHelper {
  NotificationHelper._privateConstructor();

  static final NotificationHelper instance = NotificationHelper
      ._privateConstructor();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  final BehaviorSubject<String?> selectedNotificationSubject =
  BehaviorSubject<String?>();

  Future<void> initializeNotification(BuildContext context) async {
    _configureSelectNotificationSubject(context);
    await _configureLocalTimeZone();

    const AndroidInitializationSettings androidInitializationSettings =
    AndroidInitializationSettings("noticon");

    final DarwinInitializationSettings initializationSettingsIOS =
    DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
      onDidReceiveLocalNotification: (id, title, body, payload) async {
        _showNotificationDialog(context, title, body);
      },
    );

    final InitializationSettings initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (response) {
        // Check if the notification payload has data to route to the specific page
        if (response.payload != null && response.payload!.contains("|")) {
          // Split the payload to extract title and body
          List<String> payloadParts = response.payload!.split("|");
          String title = payloadParts[0];
          String body = payloadParts[1];

          // Navigate to the NotificationViewPage with title and body as arguments
          Navigator.of(context).pushNamed(
            '/notificationPage',
            arguments: {'title': title, 'body': body},
          );
        }
      },
    );

  }

  void requestIOSPermission() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future<void> _configureLocalTimeZone() async {
    tz.initializeTimeZones();
    const String timeZoneName = 'Asia/Dhaka';
    tz.setLocalLocation(tz.getLocation(timeZoneName));
  }

  Future<void> scheduleNotification(int days, int hours, int minutes,
      int seconds, Task task) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      task.id ?? 0,
      task.title,
      task.desc,
      tz.TZDateTime.now(tz.local)
          .add(Duration(
          days: days, hours: hours, minutes: minutes, seconds: seconds)),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'your channel id',
          'your channel name',
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation
          .absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      payload:
      "${task.title}|${task.desc}|${task.date}|${task.startTime}|${task
          .endTime}",
    );
  }


  Future<void> showInstantNotification(String title, String body) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'full_screen_channel_id',
      'Full-Screen Notifications',
      importance: Importance.max,
      priority: Priority.high,
       // Enable full-screen intent for direct opening
      ticker: 'ticker',
    );


    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      0, // Notification ID
      title,
      body,
      notificationDetails,
      payload: "/notificationPage|$title|$body", // Using the route and data as payload
    );

    // Play audio immediately
    await playAudio(body);
  }

  void _configureSelectNotificationSubject(BuildContext context) {
    selectedNotificationSubject.stream.listen((String? payload) async {
      if (payload != null) {
        // Parse the route and data from payload
        var parts = payload.split('|');
        var route = parts[0];
        var title = parts.length > 1 ? parts[1] : '';
        var body = parts.length > 2 ? parts[2] : '';

        // Navigate only to the notification page without opening the full app
        if (route == "/notificationPage") {
          Navigator.pushNamed(
            context,
            '/notificationPage',
            arguments: {'title': title, 'body': body},
          );
        }
      }
    });
  }

  void _showNotificationDialog(BuildContext context, String? title,
      String? body,
      [String? payload]) {
    showDialog(
      context: context,
      builder: (BuildContext context) =>
          CupertinoAlertDialog(
            title: Text(title ?? ""),
            content: Text(
                body ?? "", textAlign: TextAlign.justify, maxLines: 4),
            actions: [
              CupertinoDialogAction(
                isDestructiveAction: true,
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Close'),
              ),
              if (payload != null)
                CupertinoDialogAction(
                  child: const Text('View'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              NotificationViewPage(payload: payload)),
                    );
                  },
                ),
            ],
          ),
    );
  }

  Future<void> playAudio(String text) async {
    final FlutterTts flutterTts = FlutterTts();
    await flutterTts.awaitSpeakCompletion(true); // Ensure it waits until speech is completed
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1.0);
    await flutterTts.setVolume(1.0);
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.speak(text);
  }


}
