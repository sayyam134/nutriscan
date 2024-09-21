import 'package:get/get.dart';

class ReminderController extends GetxController {
  var reminderAdded = false.obs; // Observable variable for reminder status

  void toggleReminder() {
    reminderAdded.value = !reminderAdded.value; // Toggle the value
  }
}
