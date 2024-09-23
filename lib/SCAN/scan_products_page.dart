import 'package:flutter/material.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart'; // Import GetX package
import 'package:lottie/lottie.dart';
import 'package:nutriscan/SCAN/product_details_page.dart';
import 'add_product_page.dart'; // Import the Add Product Page
import 'package:google_fonts/google_fonts.dart';

class BarcodeScanPage extends StatefulWidget {
  final String userId; // Pass the user's unique ID

  BarcodeScanPage({required this.userId});

  @override
  _BarcodeScanPageState createState() => _BarcodeScanPageState();
}

class _BarcodeScanPageState extends State<BarcodeScanPage> {
  String result = "Scan a barcode";
  String productDetails = "";
  String userName = '';
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _loadUserData() async {
      DocumentSnapshot doc =
      await _firestore.collection('users').doc(widget.userId).get();
      if (doc.exists) {
        var data = doc.data() as Map<String, dynamic>;
        userName = data['name'] ?? '';
      }
  }

  Future<void> scanBarcode() async {
    try {
      final scannedData = await BarcodeScanner.scan();
      setState(() {
        result = scannedData.rawContent; // Display the scanned barcode content
      });

      // Fetch product details from Firestore
      fetchProductDetails(scannedData.rawContent);
    } catch (e) {
      setState(() {
        result = "Error: $e";
      });
    }
  }

  Future<void> fetchProductDetails(String barcode) async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('products')
          .doc(barcode)
          .get();

      if (doc.exists) {
        // Extract product details from Firestore
        var data = doc.data() as Map<String, dynamic>;
        // Navigate to Product Details Page using GetX
        Get.to(() => ProductDetailsPage(
          name: data['name'] ?? '',
          dietType: data['dietType'] ?? '',
          totalCarbs: data['totalCarbs'] ?? 0.0,
          totalFat: data['totalFat'] ?? 0.0,
          totalProtein: data['totalProtein'] ?? 0.0,
          totalSodium: data['totalSodium'] ?? 0.0,
          totalSugar: data['totalSugar'] ?? 0.0,
          ingredients: data['ingredients'] ?? '',
          imageUrl: data['imagePath'] ?? '',
          userName: data['contributedBy'] ?? "Unknown User",
        ));
      } else {
        // Show dialog if product does not exist
        _showProductNotFoundDialog();
      }
    } catch (e) {
      // Show Snackbar for error
      Get.snackbar(
        "Please Try Again",
        "Facing some issue",
        snackPosition: SnackPosition.BOTTOM,
        margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05), // 5% margin
        backgroundColor: Colors.red, // Set the background color
        colorText: Colors.white, // Set text color
        borderRadius: 8,
        animationDuration: Duration(milliseconds: 300),
        duration: Duration(seconds: 3), // Duration of Snackbar display
      );
    }
  }

  void _showProductNotFoundDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Product Not Found"),
          content: Text("This product does not exist in the database. Please contribute!"),
          actions: [
            TextButton(
              onPressed: () async {
                Get.back();
                // Fetch the username
                await _loadUserData();
                // Navigate to Add Product Page using GetX
                Get.to(() => AddProductPage(barcode: result, userName: userName));
              },
              child: Text("Add Product"),
            ),
            TextButton(
              onPressed: () => Get.back(),
              child: Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  Future<String?> fetchUsername(String uid) async {
    try {
      // Get a reference to the Firestore collection
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();

      // Check if the document exists
      if (userDoc.exists) {
        // Cast the data to a Map<String, dynamic>
        final data = userDoc.data() as Map<String, dynamic>;

        // Retrieve the username from the document
        return data['username'] as String?;
      } else {
        // Handle case where user document does not exist
        print("User not found");
        return null;
      }
    } catch (e) {
      // Handle any errors that occur during the fetch
      print("Error fetching username: $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get the screen size
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset("assets/animation/email_verify.json", height: screenSize.height*0.55),
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: screenSize.width * 0.8, // 80% of screen width
                height: screenSize.height * 0.06, // 6% of screen height
                child: ElevatedButton(
                  onPressed: scanBarcode,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF007AFF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Start Scan',
                    style: GoogleFonts.roboto(
                      fontSize: 15,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: screenSize.height * 0.02), // 2% of screen height
            Text(
              productDetails,
              style: TextStyle(fontSize: 16, color: Colors.blue),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
