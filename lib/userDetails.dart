import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class PersonalizeScreen extends StatefulWidget {
  @override
  _PersonalizeScreenState createState() => _PersonalizeScreenState();
}

class _PersonalizeScreenState extends State<PersonalizeScreen> {
  final _formKey = GlobalKey<FormState>();
  String _gender = 'Male';
  String _activityLevel = 'Moderate';
  bool _isDiabetic = false;
  bool _isHypertensive = false;
  bool _acceptTerms = false;
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  // Firestore function to save user data
  Future<void> _saveData() async {
    if (_formKey.currentState!.validate() && _acceptTerms) {
      try {
        await FirebaseFirestore.instance.collection('users').add({
          'age': int.parse(_ageController.text),
          'height': double.parse(_heightController.text),
          'weight': double.parse(_weightController.text),
          'gender': _gender,
          'activityLevel': _activityLevel,
          'isDiabetic': _isDiabetic,
          'isHypertensive': _isHypertensive,
          'acceptTerms': _acceptTerms,
        });

        // Show success message using GetX Snackbar
        Get.snackbar(
          'Success',
          'Data saved successfully!',
          snackPosition: SnackPosition.BOTTOM,
          margin: EdgeInsets.all(20),
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } catch (e) {
        // Show error message using GetX Snackbar
        Get.snackbar(
          'Error',
          'Failed to save data!',
          snackPosition: SnackPosition.BOTTOM,
          margin: EdgeInsets.all(20),
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } else {
      // Show validation error if terms are not accepted
      Get.snackbar(
        'Warning',
        'Please accept the terms and conditions',
        snackPosition: SnackPosition.BOTTOM,
        margin: EdgeInsets.all(20),
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
    }
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
              SizedBox(height: (MediaQuery.of(context).size.height / 100) * 5),
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
                  Text("Your Experience",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),)
                ],
              ),
              SizedBox(height: (MediaQuery.of(context).size.height / 100) * 5),
              _buildTextField(_ageController, 'Enter Age', TextInputType.number),
              SizedBox(height: (MediaQuery.of(context).size.height / 100) * 3),
              _buildTextField(_heightController, 'Enter Height (cm)', TextInputType.number),
              SizedBox(height: (MediaQuery.of(context).size.height / 100) * 3),
              _buildTextField(_weightController, 'Enter Weight (kg)', TextInputType.number),
              SizedBox(height: (MediaQuery.of(context).size.height / 100) * 3),
              _buildDropdown(
                  _gender,
                  ['Male', 'Female', 'Transgender'],
                  'Choose Gender',
                  (value){
                    setState(() {
                      _gender = value!;
                    });
                  },
              ),
              SizedBox(height: (MediaQuery.of(context).size.height / 100) * 3),
              _buildDropdown(
                _activityLevel,
                ['Bed Ridden', 'Sedentary Lifestyle', 'Moderate', 'Heavy'],
                'Choose Activity Level',
                    (value){
                  setState(() {
                    _activityLevel = value!;
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
                  }
              ),
              SizedBox(height: (MediaQuery.of(context).size.height / 100) * 3),
              _buildCheckbox(
                  'Are You Hypertensive?',
                  _isHypertensive,
                      (value) {
                    setState(() {
                      _isHypertensive = value!;
                    });
                  }
              ),
              SizedBox(height: (MediaQuery.of(context).size.height / 100) * 3),
              _buildCheckbox(
                  'Accept All Terms & Conditions',
                  _acceptTerms,
                      (value) {
                    setState(() {
                      _acceptTerms = value!;
                    });
                  }
              ),
              SizedBox(height: (MediaQuery.of(context).size.height / 100) * 5),
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
                          fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold),
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
  Widget _buildTextField(TextEditingController controller, String hint, TextInputType keyBoard) {
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
            fontSize: 15, color: Colors.black, fontWeight: FontWeight.w400),
      ),
    );
  }

  Widget _buildDropdown<T>(T value, List<T> items, String hint, ValueChanged<T?> onChanged) {
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
              fontSize: 15, color: Colors.grey, fontWeight: FontWeight.w400),
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

  Widget _buildCheckbox(String label, bool value, ValueChanged<bool?> onChanged) {
    return SizedBox(
      width: 358,
      height: 48,
      child: InkWell(
        onTap: () {
          onChanged(!value); // Tapping on the entire container toggles the checkbox
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
                checkColor: Colors.white,  // Color of the checkmark
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
