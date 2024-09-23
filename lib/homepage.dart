import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../AUTH/wrapper.dart';
import '../MEAL/mealWrapper.dart';
import '../PROFILE/show_details.dart';
import '../SCAN/scan_products_page.dart';
import 'ALERTS/noti.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late List<Widget> _pages;
  String? userId;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  bool _isReminderOn = false;

  @override
  void initState() {
    super.initState();
    _loadReminderState();
    Permission.notification.request();
    NotificationService().initNotification();
    final user = _auth.currentUser;
    userId = user?.uid;

    _pages = [
      userId != null
          ? Mealwrapper(userId: userId!)
          : const Center(child: Text('Error: User not logged in')),
      ScanProductsPage(),
      userId != null
          ? UserDetailsPage(userId: userId!)
          : const Center(child: Text('Error: User not logged in')),
    ];
  }

  Future<void> _loadReminderState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isReminderOn = prefs.getBool('waterReminder') ?? false;
      if (_isReminderOn) {
        _scheduleReminders(false);
      }
    });
  }


  Future<void> _saveReminderState(bool isActive) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('waterReminder', isActive);
  }

  Future<void> _scheduleReminders(bool _show) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'hydration_channel',
      'Hydration Reminders',
      channelDescription: 'Hourly hydration reminder to drink water',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );
    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    for (int hour = 7; hour <= 23; hour++) {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        hour,
        'Hydration Reminder',
        'Time to drink water!',
        _nextInstanceOfHour(hour),
        platformChannelSpecifics,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.wallClockTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    }
    if(_show){
      Get.snackbar(
        'Reminder Set',
        'Hourly water reminders are now active!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        margin: const EdgeInsets.all(20),
        duration: const Duration(seconds: 3),
      );
    }
  }

  Future<void> _instantNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'instant_alert_channel',
      'Instant Alerts',
      channelDescription: 'Instant alert for water reminder activation',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      'Water Reminder has been Activated',
      "",
      platformChannelSpecifics,
    );
  }

  Future<void> _cancelReminders() async {
    await flutterLocalNotificationsPlugin.cancelAll();
    _saveReminderState(false);

    Get.snackbar(
      'Reminder Cancelled',
      'Hydration reminders have been turned off.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      margin: const EdgeInsets.all(20),
      duration: const Duration(seconds: 3),
    );
  }

  tz.TZDateTime _nextInstanceOfHour(int hour) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
    tz.TZDateTime(tz.local, now.year, now.month, now.day, hour);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  Future<void> _showReminderDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Get Hydrated'),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Water Reminder'),
              Switch(
                value: _isReminderOn,
                onChanged: (bool value) {
                  setState(() {
                    _isReminderOn = value;
                  });
                  if (_isReminderOn) {
                    _scheduleReminders(true);
                    _instantNotification();
                    _saveReminderState(true);
                  } else {
                    _cancelReminders();
                  }
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _signout() async {
    try {
      await GoogleSignIn().signOut();
      await FirebaseAuth.instance.signOut();

      Get.offAll(() => Wrapper());

      Get.snackbar(
        'See you soon',
        'You have successfully logged out.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        margin: const EdgeInsets.all(20),
        duration: const Duration(seconds: 3),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'An error occurred during logout.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        margin: const EdgeInsets.all(20),
        duration: const Duration(seconds: 3),
      );
    }
  }

  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'NutriScan',
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return ScaleTransition(scale: animation, child: child);
            },
            child: IconButton(
              key: ValueKey<bool>(_isReminderOn),
              icon: Icon(
                _isReminderOn ? Icons.water_drop : Icons.water_drop_outlined,
                color: _isReminderOn ? Colors.blue : Colors.black,
              ),
              onPressed: _showReminderDialog,
            ),
          ),
          IconButton(
            icon: Icon(Icons.logout_outlined),
            onPressed: _signout,
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu),
            label: 'Meal Planner',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt),
            label: 'Scan Products',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
