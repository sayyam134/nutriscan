import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nutriscan/PROFILE/profile_page.dart';

class UserDetailsPage extends StatefulWidget {
  final String userId;

  UserDetailsPage({required this.userId});

  @override
  _UserDetailsPageState createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _navigateToProfile(BuildContext context) async {
    bool? result = await Get.to(() => ProfilePage());
    if (result == true) {
      // No need to fetch user data again; StreamBuilder will handle it
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: StreamBuilder<DocumentSnapshot>(
        stream: _firestore.collection('users').doc(widget.userId).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error fetching data'));
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('No user data found'));
          }

          var userData = snapshot.data!.data() as Map<String, dynamic>?;

          return SingleChildScrollView(
            padding: EdgeInsets.all(screenWidth * 0.04),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black, width: 2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: EdgeInsets.all(screenWidth * 0.04),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('User Details:', style: GoogleFonts.poppins(fontSize: screenHeight * 0.028, fontWeight: FontWeight.bold)),
                      SizedBox(height: screenHeight * 0.02),
                      _buildDetailRow('Name:', '${userData!['name']}', screenHeight),
                      _buildDetailRow('Age:', '${userData['age']}', screenHeight),
                      _buildDetailRow('Height:', '${userData['height']} cm', screenHeight),
                      _buildDetailRow('Weight:', '${userData['weight']} kg', screenHeight),
                      _buildDetailRow('Gender:', _getGenderLabel(userData['gender']), screenHeight),
                      _buildDetailRow('Activity Level:', _getActivityLevelLabel(userData['activityLevel']), screenHeight),
                      _buildDetailRow('Dietary Preference:', '${userData['dietaryPreference']}', screenHeight),
                      _buildDetailRow('Location:', '${userData['location']}', screenHeight),
                      _buildDetailRow('Diabetic:', '${userData['isDiabetic'] ? 'Yes' : 'No'}', screenHeight),
                      _buildDetailRow('Hypertensive:', '${userData['isHypertensive'] ? 'Yes' : 'No'}', screenHeight),
                    ],
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: screenWidth * 0.87,
                    height: screenHeight * 0.05,
                    child: ElevatedButton(
                      onPressed: () => _navigateToProfile(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF007AFF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Edit Details',
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: screenWidth * 0.08),
                          Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black, width: 2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: EdgeInsets.all(screenWidth * 0.04),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Nutritional Requirements:', style: GoogleFonts.poppins(fontSize: screenHeight * 0.028, fontWeight: FontWeight.bold)),
                      SizedBox(height: screenHeight * 0.02),
                      _buildNutritionalRow('Total Calories:', '${userData['Tcal']}', screenHeight),
                      _buildNutritionalRow('Total Carbs:', '${userData['Tcarbs']} g', screenHeight),
                      _buildNutritionalRow('Total Proteins:', '${userData['Tprotein']} g', screenHeight),
                      _buildNutritionalRow('Total Fats:', '${userData['Tfats']} g', screenHeight),
                      _buildNutritionalRow('Total Sugar:', '${userData['Tsugar']} g', screenHeight),
                      _buildNutritionalRow('Total Sodium:', '${userData['Tsodium']} mg', screenHeight),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, double screenHeight) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.poppins(fontSize: screenHeight * 0.025),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: GoogleFonts.poppins(fontSize: screenHeight * 0.025),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNutritionalRow(String label, String value, double screenHeight) {
    return _buildDetailRow(label, value, screenHeight);
  }

  String _getGenderLabel(int gender) {
    switch (gender) {
      case 1: return 'Male';
      case 2: return 'Female';
      case 3: return 'Transgender';
      default: return 'Not specified';
    }
  }

  String _getActivityLevelLabel(double activityLevel) {
    if (activityLevel == 1.2) return 'Bed Ridden';
    if (activityLevel == 1.53) return 'Sedentary Lifestyle';
    if (activityLevel == 1.76) return 'Moderate';
    if (activityLevel == 2.25) return 'Heavy';
    return 'Not specified';
  }
}
