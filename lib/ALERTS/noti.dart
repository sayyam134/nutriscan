import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
  FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    AndroidInitializationSettings androidInitializationSettings =
    const AndroidInitializationSettings("@mipmap/ic_launcher");

    InitializationSettings initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
    );
    await notificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) async {});
  }

  Future<void> showInstantMealNotification(int day) async {
    await notificationsPlugin.show(
      0,
      'Meal Reminder is Activated',
      "For Day ${day+1}",
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'instant_reminder_channel',
          'Instant Reminders',
          channelDescription: 'Channel for instant meal reminders',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
    );
  }

  Future<void> scheduleMealReminders(int dayIndex) async {
    DateTime now = DateTime.now();
    DateTime reminderDate = now.add(Duration(days: dayIndex));

    await scheduleMealNotification(dayIndex * 3 + 1, 9, 30, reminderDate); // Breakfast
    await scheduleMealNotification(dayIndex * 3 + 2, 13, 0, reminderDate);  // Lunch
    await scheduleMealNotification(dayIndex * 3 + 3, 20, 30, reminderDate); // Dinner
  }

  Future<void> scheduleMealNotification(int id, int hour, int minute, DateTime reminderDate) async {
    await notificationsPlugin.zonedSchedule(
      id,
      'Meals Reminder Activated',
      'Let’s have the planned meal',
      tz.TZDateTime.from(reminderDate.add(Duration(hours: hour, minutes: minute)), tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'meal_reminder_channel',
          'Meal Reminders',
          channelDescription: 'Channel for meal reminders',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }
  
}
