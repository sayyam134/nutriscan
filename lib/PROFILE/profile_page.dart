import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../MODEL/calculations.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _selectedGender = 'Male';
  int _gender = 1;
  String? _selectedActivity = 'Moderate';
  double? _activityLevel = 1.76;
  String _selectedDietaryPreference = 'Vegetarian';
  String _updatedDietaryPreference = 'veg';
  String _selectedLocation = 'Madhya Pradesh';
  bool _isDiabetic = false;
  bool _isHypertensive = false;
  bool _isLoading = true;

  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  final Map<String, double> activityLevels = {
    'Bed Ridden': 1.2,
    'Sedentary Lifestyle': 1.53,
    'Moderate': 1.76,
    'Heavy': 2.25,
  };

  final Map<String, int> _genders = {
    'Male': 1,
    'Female': 2,
    'Transgender': 3,
  };

  final Map<String, String> dietaryPreferences = {
    'Vegetarian': 'veg',
    'Non-Vegetarian': 'non-veg',
    'Vegan': 'vegan',
  };

  final Map<String, String> locations = {
    'Andaman': 'Andaman',
    'Andhra Pradesh': 'Andhra Pradesh',
    'Arunachal Pradesh': 'Arunachal Pradesh',
    'Assam': 'Assam',
    'Bihar': 'Bihar',
    'Chandigarh': 'Chandigarh',
    'Chhattisgarh': 'Chhattisgarh',
    'Dadra and Nagar Haveli': 'Dadra and Nagar Haveli',
    'Daman and Diu': 'Daman and Diu',
    'Delhi': 'Delhi',
    'Goa': 'Goa',
    'Gujarat': 'Gujarat',
    'Haryana': 'Haryana',
    'Himachal Pradesh': 'Himachal Pradesh',
    'Jharkhand': 'Jharkhand',
    'Karnataka': 'Karnataka',
    'Kerala': 'Kerala',
    'Ladakh': 'Ladakh',
    'Lakshadweep': 'Lakshadweep',
    'Madhya Pradesh': 'Madhya Pradesh',
    'Maharashtra': 'Maharashtra',
    'Manipur': 'Manipur',
    'Meghalaya': 'Meghalaya',
    'Mizoram': 'Mizoram',
    'Nagaland': 'Nagaland',
    'Odisha': 'Odisha',
    'Puducherry': 'Puducherry',
    'Punjab': 'Punjab',
    'Rajasthan': 'Rajasthan',
    'Sikkim': 'Sikkim',
    'Tamil Nadu': 'Tamil Nadu',
    'Telangana': 'Telangana',
    'Tripura': 'Tripura',
    'Uttarakhand': 'Uttarakhand',
    'Uttar Pradesh': 'Uttar Pradesh',
    'West Bengal': 'West Bengal',
    'Jammu and Kashmir': 'Jammu and Kashmir',
  };

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(user.uid).get();
      if (doc.exists) {
        var data = doc.data() as Map<String, dynamic>;
        _nameController.text = data['name'] ?? '';
        _ageController.text = data['age']?.toString() ?? '';
        _heightController.text = data['height']?.toString() ?? '';
        _weightController.text = data['weight']?.toString() ?? '';
        _gender = data['gender'] ?? 1;
        _isDiabetic = data['isDiabetic'] ?? false;
        _isHypertensive = data['isHypertensive'] ?? false;

        _selectedDietaryPreference = dietaryPreferences.keys.firstWhere(
          (key) => key == data['dietaryPreference'],
          orElse: () => 'Vegetarian',
        );
        _updatedDietaryPreference =
            dietaryPreferences[_selectedDietaryPreference] ?? 'veg';
        _selectedLocation = data['location'] ?? 'Madhya Pradesh';
        _activityLevel = data['activityLevel'] ?? 1.76;

        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _saveData() async {
    if (_ageController.text.isEmpty ||
        _heightController.text.isEmpty ||
        _weightController.text.isEmpty ||
        _nameController.text.isEmpty) {
      _showSnackbar('Warning', 'Please fill in all fields correctly');
      return;
    }

    try {
      User? user = _auth.currentUser;
      await _firestore.collection('users').doc(user?.uid).update({
        'name': _nameController.text,
        'age': int.parse(_ageController.text),
        'height': double.parse(_heightController.text),
        'weight': double.parse(_weightController.text),
        'gender': _gender,
        'activityLevel': _activityLevel,
        'isDiabetic': _isDiabetic,
        'isHypertensive': _isHypertensive,
        'dietaryPreference': _updatedDietaryPreference,
        'location': _selectedLocation,
      });
      _showSnackbar('Success', 'Data updated successfully', Colors.green);
    } catch (e) {
      _showSnackbar('Error', 'Failed to update data', Colors.red);
    }
  }

  void _showSnackbar(String title, String message,
      [Color backgroundColor = Colors.orange]) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      margin: EdgeInsets.all(20),
      backgroundColor: backgroundColor,
      colorText: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Update Your Profile",
          style: GoogleFonts.poppins(
              fontSize: 24, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Navigate back to the previous screen
            Get.back(result: true);
          },
        ), // Customize the background color as needed
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.all(screenWidth * 0.04),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel("Name"),
                    _buildTextField(
                        _nameController, 'Enter Name', TextInputType.text),
                    SizedBox(height: screenHeight * 0.02),
                    _buildLabel("Age"),
                    _buildTextField(
                        _ageController, 'Enter Age', TextInputType.number),
                    SizedBox(height: screenHeight * 0.02),
                    _buildLabel("Height (cm)"),
                    _buildTextField(_heightController, 'Enter Height',
                        TextInputType.number),
                    SizedBox(height: screenHeight * 0.02),
                    _buildLabel("Weight (kg)"),
                    _buildTextField(_weightController, 'Enter Weight',
                        TextInputType.number),
                    SizedBox(height: screenHeight * 0.02),
                    _buildLabel("Gender"),
                    _buildDropdown(
                      _selectedGender,
                      _genders.keys.toList(),
                      (value) {
                        setState(() {
                          _selectedGender = value!;
                          _gender = _genders[value]!;
                        });
                      },
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    _buildLabel("Activity Level"),
                    _buildDropdown(
                      _selectedActivity,
                      activityLevels.keys.toList(),
                      (value) {
                        setState(() {
                          _selectedActivity = value!;
                          _activityLevel = activityLevels[value]!;
                        });
                      },
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    _buildLabel("Dietary Preference"),
                    _buildDropdown(
                      _selectedDietaryPreference,
                      dietaryPreferences.keys.toList(),
                      (value) {
                        setState(() {
                          _selectedDietaryPreference = value!;
                          _updatedDietaryPreference =
                              dietaryPreferences[value]!;
                        });
                      },
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    _buildLabel("Location"),
                    _buildDropdown(
                      _selectedLocation,
                      locations.keys.toList(),
                      (value) {
                        setState(() {
                          _selectedLocation = value!;
                        });
                      },
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildLabel("Are You Diabetic?"),
                        _buildCheckbox(_isDiabetic, (value) {
                          setState(() {
                            _isDiabetic = value!;
                          });
                        }),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildLabel("Are You Hypertensive?"),
                        _buildCheckbox(_isHypertensive, (value) {
                          setState(() {
                            _isHypertensive = value!;
                          });
                        }),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        width: screenWidth * 0.87,
                        height: screenHeight * 0.05,
                        child: ElevatedButton(
                          onPressed: _isLoading
                              ? null
                              : () async {
                                  await _saveData();
                                  Calculations c = Calculations();
                                  await c.updateDetails();
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF007AFF),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: _isLoading
                              ? CircularProgressIndicator(color: Colors.white)
                              : Text(
                                  'Update Profile',
                                  style: GoogleFonts.poppins(
                                    fontSize: 15,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.04),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String hint, TextInputType keyBoard) {
    return TextField(
      controller: controller,
      keyboardType: keyBoard,
      decoration: InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(),
      ),
      style: GoogleFonts.poppins(),
    );
  }

  Widget _buildDropdown<T>(T value, List<T> items, ValueChanged<T?> onChanged) {
    return DropdownButtonFormField<T>(
      value: value,
      onChanged: onChanged,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
      ),
      items: items.map((T item) {
        return DropdownMenuItem<T>(
          value: item,
          child: Text(item.toString(), style: GoogleFonts.poppins()),
        );
      }).toList(),
    );
  }

  Widget _buildCheckbox(bool value, ValueChanged<bool?> onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Checkbox(
          value: value,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
