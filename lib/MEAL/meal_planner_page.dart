import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'reminder_controller.dart'; // Import your controller
import '../homepage.dart';

class MealPlannerPage extends StatefulWidget {
  @override
  State<MealPlannerPage> createState() => _MealPlannerPageState();
}

class _MealPlannerPageState extends State<MealPlannerPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ReminderController reminderController = Get.put(ReminderController()); // Initialize the controller

  int cal = 0;
  int carbs = 0;
  int fats = 0;
  int protein = 0;

  String loc = 'Madhya Pradesh';
  String deitPref = "veg";

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  Future<void> _fetchUserDetails() async {
    User? user = _auth.currentUser;

    if (user != null) {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();

      if (userDoc.exists) {
        setState(() {
          cal = userDoc['Tcal'];
          carbs = userDoc['Tcarbs'];
          fats = userDoc['Tfats'];
          protein = userDoc['Tprotein'];
          loc = userDoc['location'];
          deitPref = userDoc['dietaryPreference'];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Meal Planner',
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Get.offAll(() => HomePage());
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: fetchMealPlan(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No meal plan available'));
                }

                final mealPlan = snapshot.data!;
                return ListView.builder(
                  itemCount: mealPlan.length,
                  itemBuilder: (context, dayIndex) {
                    final dayMeals = mealPlan[dayIndex];

                    double totalCalories = 0;
                    double totalCarbs = 0;
                    double totalFats = 0;
                    double totalProtein = 0;

                    dayMeals.forEach((meal) {
                      totalCalories += meal['Total Calories'];
                      totalCarbs += meal['Total Carbs'];
                      totalFats += meal['Total Fats'];
                      totalProtein += meal['Total Protein'];
                    });

                    return Card(
                      margin: EdgeInsets.symmetric(
                        vertical: screenHeight * 0.02,
                        horizontal: screenWidth * 0.03,
                      ),
                      elevation: 5,
                      child: Padding(
                        padding: EdgeInsets.all(screenHeight * 0.02),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Day ${dayIndex + 1}',
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold,
                                      fontSize: screenHeight * 0.022,
                                    ),
                                  ),
                                  Obx(() => GestureDetector(
                                    onTap: () {
                                      reminderController.toggleReminder(); // Toggle reminder state
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.black),
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: screenWidth * 0.03,
                                        vertical: screenHeight * 0.01,
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            reminderController.reminderAdded.value ? Icons.check : Icons.notifications,
                                            color: Colors.black,
                                          ),
                                          SizedBox(width: 5),
                                          Text(
                                            reminderController.reminderAdded.value ? 'Reminder Added' : 'Add to Reminders',
                                            style: GoogleFonts.poppins(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )),
                                ],
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.01),
                            ...List.generate(dayMeals.length, (mealIndex) {
                              final meal = dayMeals[mealIndex];
                              return Container(
                                width: double.infinity,
                                margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.black),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(screenHeight * 0.015),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${meal['Food Name']}',
                                        style: GoogleFonts.poppins(
                                          fontSize: screenHeight * 0.018,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      SizedBox(height: screenHeight * 0.005),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text('Calories: ${meal['Total Calories']}', style: GoogleFonts.poppins(color: Colors.grey[800], fontWeight: FontWeight.w600)),
                                                Text('Carbs: ${meal['Total Carbs']}', style: GoogleFonts.poppins(color: Colors.grey[800], fontWeight: FontWeight.w600)),
                                                Text('Fats: ${meal['Total Fats']}', style: GoogleFonts.poppins(color: Colors.grey[800], fontWeight: FontWeight.w600)),
                                                Text('Protein: ${meal['Total Protein']}', style: GoogleFonts.poppins(color: Colors.grey[800], fontWeight: FontWeight.w600)),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [
                                                Text('State: ${meal['State']}', style: GoogleFonts.poppins(color: Colors.grey[800], fontWeight: FontWeight.w600)),
                                                Text('Type: ${meal['Type']}', style: GoogleFonts.poppins(color: Colors.grey[800], fontWeight: FontWeight.w600)),
                                                SizedBox(height: screenHeight * 0.01),
                                                GestureDetector(
                                                  onTap: () async {
                                                    final foodName = meal['Food Name'];
                                                    final query = Uri.encodeComponent('How to make $foodName');
                                                    final url = Uri.parse('https://www.youtube.com/results?search_query=$query');

                                                    if (await canLaunchUrl(url)) {
                                                      await launchUrl(url);
                                                    } else {
                                                      throw 'Could not launch $url';
                                                    }
                                                  },
                                                  child: Container(
                                                    width: screenWidth * 0.25,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius: BorderRadius.circular(25),
                                                      border: Border.all(color: Colors.black),
                                                    ),
                                                    padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01, horizontal: screenWidth * 0.02),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Image.asset(
                                                          'assets/images/google.webp',
                                                          height: 20,
                                                        ),
                                                        SizedBox(width: 5),
                                                        Text(
                                                          'Search',
                                                          style: GoogleFonts.poppins(color: Colors.black),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  color: Colors.black,
                                  width: 2,
                                ),
                              ),
                              padding: EdgeInsets.symmetric(
                                vertical: screenHeight * 0.02,
                                horizontal: screenWidth * 0.04,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Total Nutrients',
                                    style: GoogleFonts.poppins(
                                      fontSize: screenHeight * 0.022,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: screenHeight * 0.01),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('Total Calories:', style: GoogleFonts.poppins(color: Colors.grey[800], fontWeight: FontWeight.w600)),
                                            Text('Total Carbs:', style: GoogleFonts.poppins(color: Colors.grey[800], fontWeight: FontWeight.w600)),
                                            Text('Total Fats:', style: GoogleFonts.poppins(color: Colors.grey[800], fontWeight: FontWeight.w600)),
                                            Text('Total Protein:', style: GoogleFonts.poppins(color: Colors.grey[800], fontWeight: FontWeight.w600)),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Text('${totalCalories.toStringAsFixed(2)}', style: GoogleFonts.poppins(color: Colors.grey[800], fontWeight: FontWeight.w600)),
                                            Text('${totalCarbs.toStringAsFixed(2)}', style: GoogleFonts.poppins(color: Colors.grey[800], fontWeight: FontWeight.w600)),
                                            Text('${totalFats.toStringAsFixed(2)}', style: GoogleFonts.poppins(color: Colors.grey[800], fontWeight: FontWeight.w600)),
                                            Text('${totalProtein.toStringAsFixed(2)}', style: GoogleFonts.poppins(color: Colors.grey[800], fontWeight: FontWeight.w600)),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<List<dynamic>> fetchMealPlan() async {
    final response = await http.post(
      Uri.parse('https://sayyam134.pythonanywhere.com/generate_7_day_meal_plan'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'user_preferences': {
          'dietary_preference': deitPref,
          'location': loc,
        },
        'daily_requirements': {
          'calories': cal,
          'carbs': carbs,
          'protein': protein,
          'fats': fats,
        },
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final mealPlan = data['meal_plan'];
      return mealPlan;
    } else {
      throw Exception('Failed to load meal plan');
    }
  }
}
