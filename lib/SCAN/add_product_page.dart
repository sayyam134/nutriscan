import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart'; // Import the image_picker package
import 'dart:io'; // Import for File type

class AddProductPage extends StatefulWidget {
  final String barcode;
  final String userName;

  AddProductPage({
    required this.barcode,
    required this.userName
  });

  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _carbsController = TextEditingController();
  final TextEditingController _proteinController = TextEditingController();
  final TextEditingController _fatController = TextEditingController();
  final TextEditingController _sugarController = TextEditingController();
  final TextEditingController _sodiumController = TextEditingController();
  final TextEditingController _ingredientsController = TextEditingController();

  String? _selectedDiet = 'Veg'; // Default selection
  final List<String> _dietOptions = ['Veg', 'Vegan', 'Jain', 'Non-Veg'];
  File? _imageFile; // Variable to hold the image file
  final ImagePicker _picker = ImagePicker(); // Instance of ImagePicker

  bool _isLoading = false; // Loading state

  // Firestore function to save product data
  Future<void> _saveProduct() async {
    if (_nameController.text.isEmpty ||
        _carbsController.text.isEmpty ||
        _proteinController.text.isEmpty ||
        _fatController.text.isEmpty ||
        _sugarController.text.isEmpty ||
        _sodiumController.text.isEmpty ||
        _ingredientsController.text.isEmpty) {
      _showSnackbar('Warning', 'Please fill in all fields correctly');
      return;
    }

    setState(() {
      _isLoading = true; // Start loading
    });

    try {
      print("Uploading started");
      String imageUrl = await _uploadImage(_imageFile);
      print("Uploading ended");

      await FirebaseFirestore.instance.collection('products').doc(widget.barcode).set({
        'name': _nameController.text,
        'totalCarbs': double.parse(_carbsController.text),
        'totalProtein': double.parse(_proteinController.text),
        'totalFat': double.parse(_fatController.text),
        'totalSugar': double.parse(_sugarController.text),
        'totalSodium': double.parse(_sodiumController.text),
        'dietType': _selectedDiet,
        'ingredients': _ingredientsController.text,
        'imagePath': _imageFile != null ? imageUrl.toString() : null, // Add image path to Firestore
        'contributedBy' : widget.userName
      });
      _showSnackbar('Success', 'Product added successfully', Colors.green);
      Navigator.pop(context); // Go back after adding
    } catch (e) {
      _showSnackbar('Error', 'Failed to save product: $e', Colors.red);
    } finally {
      setState(() {
        _isLoading = false; // Stop loading
      });
    }
  }

  // Function to pick an image from the camera
  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.camera); // Updated method
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<String> _uploadImage(File? imageFile) async {
    if (imageFile == null) {
      throw Exception('No image selected');
    }
    try {
      // Create a reference to the Firebase Storage
      print("trying started");
      final storageRef = FirebaseStorage.instance.ref().child('products/${widget.barcode}.jpg');
      print("trying ended");
      // Upload the image
      print("putting started");
      await storageRef.putFile(imageFile);
      print("putting ended");

      // Get the download URL
      String downloadUrl = await storageRef.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }

  // Helper function to show GetX Snackbar
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

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text("Add Product"),
      ),
      body: Stack( // Use a Stack to overlay the progress indicator
        children: [
          Padding(
            padding: EdgeInsets.all(screenWidth * 0.04), // 4% of screen width
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildImagePicker(screenWidth),
                  SizedBox(height: screenHeight * 0.02), // 2% of screen height
                  _buildTextField(_nameController, 'Product Name', TextInputType.text, screenWidth),
                  SizedBox(height: screenHeight * 0.02), // 2% of screen height
                  _buildTextField(_carbsController, 'Total Carbs (g)', TextInputType.number, screenWidth),
                  SizedBox(height: screenHeight * 0.02), // 2% of screen height
                  _buildTextField(_proteinController, 'Total Protein (g)', TextInputType.number, screenWidth),
                  SizedBox(height: screenHeight * 0.02), // 2% of screen height
                  _buildTextField(_fatController, 'Total Fat (g)', TextInputType.number, screenWidth),
                  SizedBox(height: screenHeight * 0.02), // 2% of screen height
                  _buildTextField(_sugarController, 'Total Sugar (g)', TextInputType.number, screenWidth),
                  SizedBox(height: screenHeight * 0.02), // 2% of screen height
                  _buildTextField(_sodiumController, 'Total Sodium (mg)', TextInputType.number, screenWidth),
                  SizedBox(height: screenHeight * 0.02), // 2% of screen height
                  _buildDropdown(
                    _selectedDiet,
                    _dietOptions,
                    'Choose Diet Type',
                        (value) {
                      setState(() {
                        _selectedDiet = value;
                      });
                    },
                    screenWidth,
                  ),
                  SizedBox(height: screenHeight * 0.02), // 2% of screen height
                  _buildTextField(_ingredientsController, 'Ingredients Description', TextInputType.multiline, screenWidth),
                  SizedBox(height: screenHeight * 0.02), // 2% of screen height
                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: screenWidth * 0.9, // 90% of screen width
                      height: screenHeight * 0.06, // 6% of screen height
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _saveProduct, // Disable button while loading
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF007AFF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Add Product',
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
          if (_isLoading) // Show loading indicator
            Container(
              color: Colors.black54, // Optional: darken background
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }


  Widget _buildTextField(TextEditingController controller, String hint, TextInputType keyboard, double screenWidth) {
    return TextField(
      keyboardType: keyboard,
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
      maxLines: keyboard == TextInputType.multiline ? null : 1,
    );
  }

  Widget _buildDropdown<T>(
      T value, List<T> items, String hint, ValueChanged<T?> onChanged, double screenWidth) {
    return DropdownButtonFormField<T>(
      value: value,
      hint: Text(hint),
      onChanged: onChanged,
      items: items.map((T item) {
        return DropdownMenuItem<T>(
          value: item,
          child: Text(item.toString(), style: GoogleFonts.roboto(fontSize: 15)),
        );
      }).toList(),
      decoration: InputDecoration(
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
    );
  }

  Widget _buildImagePicker(double screenWidth) {
    return GestureDetector(
      onTap: _pickImage, // Open the image picker on tap
      child: Container(
        width: screenWidth * 0.9, // 90% of screen width
        height: screenWidth * 0.4, // 40% of screen width (for image display)
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
          image: _imageFile != null
              ? DecorationImage(
            image: FileImage(_imageFile!),
            fit: BoxFit.cover,
          )
              : null,
        ),
        child: _imageFile == null
            ? Center(
          child: Text(
            'Tap to pick an image',
            style: GoogleFonts.roboto(color: Colors.grey),
          ),
        )
            : null,
      ),
    );
  }
}
