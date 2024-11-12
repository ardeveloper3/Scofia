// background_task_manager.dart

import 'package:scofia/common/helpers/notification_helper.dart';
import 'package:workmanager/workmanager.dart';

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      // Show the initial notification
      await NotificationHelper.instance.showInstantNotification(
        inputData!['title'],
        inputData['desc'],
      );

      // Check if the task should repeat daily
      if (inputData['repeat'] == 'yes') {
        // Schedule the task to repeat daily at the same time
        Workmanager().registerOneOffTask(
          "dailyRepeatTask", // Unique identifier for the daily task
          "repeatNotificationTask",
          inputData: inputData,
          initialDelay: Duration(minutes: 5), // Set delay to 24 hours for daily repetition
        );
      }

      // Optional: Schedule a follow-up notification
      Workmanager().registerOneOffTask(
        "followUpTask",
        "followUpNotificationTask",
        inputData: {
          "title": "Hi, this is Scofia",
          "desc": "If you've completed your task, mark it. Otherwise, please complete it.",
        },
        initialDelay: Duration(minutes: 2), // Customize the delay for the follow-up
      );

      return Future.value(true); // Task completed successfully
    } catch (e) {
      print("Error in sending notification: $e");
      return Future.value(false); // Task failed
    }
  });
}

void scheduleOneTimeNotificationTask({
  required int days,
  required int hours,
  required int minutes,
  required int seconds,
  required String title,
  required String desc,
  required int id,
  required List<String> notificationData,
}) {
  Duration delay = Duration(
    days: days,
    hours: hours,
    minutes: minutes,
    seconds: seconds,
  );

  int unicid = id; // Example integer ID
  String uniqueTaskId = "notificationTask_$unicid";
  Workmanager().registerOneOffTask(
    uniqueTaskId, // Unique task identifier
    "simpleOneTimeNotificationTask",
    inputData: {
      "title": title,
      "desc": desc,
      "repeat": notificationData[0], // "yes" or "no"
      "notification1": notificationData[1],
      "notification2": notificationData[2],
    },
    initialDelay: delay,
  );
}
