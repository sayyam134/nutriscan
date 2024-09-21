import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'mealWrapper.dart';

class DietaryPreferenceScreen extends StatefulWidget {
  final String userId;

  DietaryPreferenceScreen({required this.userId});

  @override
  _DietaryPreferenceScreenState createState() => _DietaryPreferenceScreenState();
}

class _DietaryPreferenceScreenState extends State<DietaryPreferenceScreen> {
  String _selectedDietaryPreference = 'Vegetarian';
  String _updatedDietaryPreference = 'veg';
  String _selectedLocation = 'Madhya Pradesh';
  String _updatedLocation = 'Madhya Pradesh';

  @override
  void initState() {
    super.initState();
    _selectedDietaryPreference = dietaryPreferences.keys.first; // Defaults to the first option
    _selectedLocation = locations.keys.first; // Defaults to the first option
  }

  final Map<String, String> dietaryPreferences = {
    'Vegetarian': 'veg',
    'Non-Vegetarian': 'von-Veg',
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

  void _showSnackbar(String title, String message, [Color backgroundColor = Colors.orange]) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      margin: EdgeInsets.all(20),
      backgroundColor: backgroundColor,
      colorText: Colors.white,
    );
  }

  Future<void> _saveData() async {
    if (_selectedDietaryPreference.isEmpty || _selectedLocation.isEmpty) {
      _showSnackbar('Error', 'Please select both dietary preference and location.', Colors.red);
      return;
    }

    try {
      String userId = widget.userId;
      CollectionReference users = FirebaseFirestore.instance.collection('users');

      await users.doc(userId).update({
        'dietaryPreference': _updatedDietaryPreference,
        'location': _updatedLocation,
        'hasPro' : true,
      });

      _showSnackbar('Success', 'Data updated successfully', Colors.green);
      Get.offAll(Mealwrapper(userId: widget.userId,));
    } catch (e) {
      _showSnackbar('Error', 'Failed to update data: $e', Colors.red);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: (MediaQuery.of(context).size.height / 100) * 20),
              _buildHeader(),
              SizedBox(height: (MediaQuery.of(context).size.height / 100) * 5),
              _buildDropdown(
                _selectedDietaryPreference,
                dietaryPreferences.keys.toList(),
                'Choose Dietary Preference',
                      (value){
                    setState(() {
                      _selectedDietaryPreference = value!;
                      _updatedDietaryPreference = dietaryPreferences[value]!;
                    });
                  }
              ),
              SizedBox(height: (MediaQuery.of(context).size.height / 100) * 5),
              _buildDropdown(
                _selectedLocation,
                locations.keys.toList(),
                'Choose Location',
                    (value){
                  setState(() {
                    _selectedLocation = value!;
                    _updatedLocation = locations[value]!;
                  });
                }
              ),
              SizedBox(height: (MediaQuery.of(context).size.height / 100) * 5),
              _buildContinueButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Dietary Preferences",
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ),
        Text(
          "Let's Customize Your Plan",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildDropdown<T>(
      T value,
      List<T> items,
      String hint,
      ValueChanged<T?> onChanged,
      ) {
    return DropdownButtonFormField<T>(
      value: value,
      onChanged: onChanged,
      isExpanded: true,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: hint,
        hintStyle: GoogleFonts.roboto(fontSize: 15, color: Colors.grey, fontWeight: FontWeight.w400),
        contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey, width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black, width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      dropdownColor: Colors.white,
      items: items.map((T item) {
        return DropdownMenuItem<T>(
          value: item,
          child: Text(
            item.toString(),
            style: GoogleFonts.roboto(fontSize: 15, color: Colors.black),
          ),
        );
      }).toList(),
      style: GoogleFonts.roboto(fontSize: 15, color: Colors.black),
    );
  }

  Widget _buildContinueButton() {
    return Center(
      child: SizedBox(
        width: 350,
        height: 40,
        child: ElevatedButton(
          onPressed: _saveData,
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF007AFF),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            'Continue',
            style: GoogleFonts.roboto(fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
