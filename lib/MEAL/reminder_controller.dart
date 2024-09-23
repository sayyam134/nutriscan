import 'package:get/get.dart';

class ReminderController extends GetxController {
  var reminderStates = List.generate(7, (index) => false.obs); // Observable list for 7 days

  void toggleReminder(int dayIndex) {
    reminderStates[dayIndex].value = !reminderStates[dayIndex].value; // Toggle the reminder state for the specific day
  }
}
