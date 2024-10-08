import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nutriscan/MODEL/calculations.dart';
import 'wrapper.dart';

class PersonalizeScreen extends StatefulWidget {
  @override
  _PersonalizeScreenState createState() => _PersonalizeScreenState();
}

class _PersonalizeScreenState extends State<PersonalizeScreen> {
  final Calculations calculations = Calculations();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _selectedGender = 'Male';
  int _gender = 1;
  String? _selectedActivity = 'Moderate';
  double? _activityLevel = 1.76;
  bool _isDiabetic = false;
  bool _isHypertensive = false;
  bool _acceptTerms = false;
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

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

  // Firestore function to save user data
  Future<void> _saveData() async {
    if (_ageController.text.isEmpty ||
        _ageController.text == '0' ||
        _heightController.text.isEmpty ||
        _heightController.text == '0' ||
        _weightController.text.isEmpty ||
        _weightController.text == '0') {
      print(_ageController.text == '0');
      _showSnackbar('Warning', 'Please fill in all fields Correctly');
      return;
    }

    if (!_acceptTerms) {
      _showSnackbar('Warning', 'Please accept the terms and conditions');
      return;
    }

    try {
      User? user = _auth.currentUser;
      await _firestore.collection('users').doc(user?.uid).update({
        'age': int.parse(_ageController.text),
        'height': double.parse(_heightController.text),
        'weight': double.parse(_weightController.text),
        'gender': _gender,
        'activityLevel': _activityLevel,
        'isDiabetic': _isDiabetic,
        'isHypertensive': _isHypertensive,
        'acceptTerms': _acceptTerms,
      });
      _showSnackbar('Success', 'Data saved successfully', Colors.green);
      Get.offAll(() => Wrapper());
    } catch (e) {
      print(e.toString());
      _showSnackbar('Error','Failed to save data', Colors.red);
    }
  }

  // Helper function to show GetX Snackbar
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
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: (MediaQuery.of(context).size.height / 100) * 3),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Let's Personalize",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Your Experience",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
              SizedBox(height: (MediaQuery.of(context).size.height / 100) * 3),
              _buildTextField(
                  _ageController, 'Enter Age', TextInputType.number),
              SizedBox(height: (MediaQuery.of(context).size.height / 100) * 3),
              _buildTextField(
                  _heightController, 'Enter Height (cm)', TextInputType.number),
              SizedBox(height: (MediaQuery.of(context).size.height / 100) * 3),
              _buildTextField(
                  _weightController, 'Enter Weight (kg)', TextInputType.number),
              SizedBox(height: (MediaQuery.of(context).size.height / 100) * 3),
              _buildDropdown(
                _selectedGender,
                _genders.keys.toList(),
                'Choose Gender',
                (value) {
                  setState(() {
                    _selectedGender = value!;
                    _gender = _genders[value]!;
                  });
                },
              ),
              SizedBox(height: (MediaQuery.of(context).size.height / 100) * 3),
              _buildDropdown(
                _selectedActivity,
                activityLevels.keys.toList(),
                'Choose Activity Level',
                (value) {
                  setState(() {
                    _selectedActivity = value!;
                    _activityLevel = activityLevels[value]!;
                  });
                },
              ),
              SizedBox(height: (MediaQuery.of(context).size.height / 100) * 3),
              _buildCheckbox(
                'Are You Diabetic?',
                _isDiabetic,
                (value) {
                  setState(() {
                    _isDiabetic = value!;
                  });
                },
              ),
              SizedBox(height: (MediaQuery.of(context).size.height / 100) * 3),
              _buildCheckbox(
                'Are You Hypertensive?',
                _isHypertensive,
                (value) {
                  setState(() {
                    _isHypertensive = value!;
                  });
                },
              ),
              SizedBox(height: (MediaQuery.of(context).size.height / 100) * 3),
              _buildCheckbox(
                'Accept All Terms & Conditions',
                _acceptTerms,
                (value) {
                  setState(() {
                    _acceptTerms = value!;
                  });
                },
              ),
              SizedBox(height: (MediaQuery.of(context).size.height / 100) * 3),
              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: 350,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: _acceptTerms ? _saveData : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF007AFF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Continue',
                      style: GoogleFonts.roboto(
                        fontSize: 15,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String hint, TextInputType keyBoard) {
    return SizedBox(
      width: 358,
      height: 48,
      child: TextField(
        keyboardType: keyBoard,
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 1),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 1),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        style: GoogleFonts.roboto(
          fontSize: 15,
          color: Colors.black,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  Widget _buildDropdown<T>(
      T value, List<T> items, String hint, ValueChanged<T?> onChanged) {
    return SizedBox(
      width: 358,
      height: 48,
      child: DropdownButtonFormField<T>(
        value: value,
        onChanged: onChanged,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: hint,
          hintStyle: GoogleFonts.roboto(
            fontSize: 15,
            color: Colors.grey,
            fontWeight: FontWeight.w400,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 1),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 1),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        items: items.map((T item) {
          return DropdownMenuItem<T>(
            value: item,
            child: Text(
              item.toString(),
              style: GoogleFonts.roboto(
                fontSize: 15,
                color: Colors.black,
                fontWeight: FontWeight.w400,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCheckbox(
      String label, bool value, ValueChanged<bool?> onChanged) {
    return SizedBox(
      width: 358,
      height: 48,
      child: InkWell(
        onTap: () {
          onChanged(
              !value); // Tapping on the entire container toggles the checkbox
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey, width: 1),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: GoogleFonts.roboto(
                  fontSize: 15,
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Checkbox(
                value: value,
                onChanged: onChanged,
                activeColor: Colors.black, // Color of the checkbox when active
                checkColor: Colors.white, // Color of the checkmark
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
