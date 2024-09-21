import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nutriscan/MEAL/meal_planner_page.dart';
import 'location_dietray.dart';

class Mealwrapper extends StatelessWidget {
  final String userId; // Pass the user's unique ID

  Mealwrapper({required this.userId});

  Future<bool> checkUserHasPro() async {
    try {
      // Fetch user data from Firestore
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        var data = userDoc.data() as Map<String, dynamic>;
        print("User data: $data"); // Debugging line

        // Check if 'hasPro' exists and is true
        return data.containsKey('hasPro') && data['hasPro'] == true;
      }
      return false;
    } catch (e) {
      print("Error fetching user data: $e");
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<bool>(
        future: checkUserHasPro(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show a loading indicator while waiting for data
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Handle any errors that occur
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.hasData) {
            bool hasPro = snapshot.data!;

            // Redirect based on the result
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (hasPro==true) {
                // User has Pro
                Get.offAll(() => MealPlannerPage()); // Navigate to MealPlanner
              } else {
                // User does not have Pro
                Get.offAll(() => DietaryPreferenceScreen(userId: userId)); // Navigate to Dietary Preference screen
              }
            });
            return Container(); // Empty container, since navigation is handled
          } else {
            // In case snapshot is empty, show a message
            return Center(child: Text("No data available"));
          }
        },
      ),
    );
  }
}
