import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductDetailsPage extends StatelessWidget {
  final String name;
  final String dietType;
  final double totalCarbs;
  final double totalFat;
  final double totalProtein;
  final double totalSodium;
  final double totalSugar;
  final String ingredients;
  final String imageUrl;// URL for the product image
  final String userName;

  ProductDetailsPage({
    required this.name,
    required this.dietType,
    required this.totalCarbs,
    required this.totalFat,
    required this.totalProtein,
    required this.totalSodium,
    required this.totalSugar,
    required this.ingredients,
    required this.imageUrl, // Accepting image URL as a parameter
    required this.userName
  });

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(name,
          style: GoogleFonts.poppins(
            fontSize: screenHeight * 0.028,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Product Image in a Container with Curvy Border
              Container(
                width: screenWidth * 0.9,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black, width: 2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    imageUrl,
                    height: screenHeight * 0.4, // Adjust height as needed
                    width: screenWidth * 0.7,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
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
                    Text(
                      'Product Details:',
                      style: GoogleFonts.poppins(
                        fontSize: screenHeight * 0.028,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '(As per serving size of 100g)',
                      style: GoogleFonts.poppins(
                        fontSize: screenHeight * 0.016,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    _buildDetailRow('Diet Type:', dietType, screenHeight),
                    _buildDetailRow('Total Carbs:', '${totalCarbs} g', screenHeight),
                    _buildDetailRow('Total Fat:', '${totalFat} g', screenHeight),
                    _buildDetailRow('Total Protein:', '${totalProtein} g', screenHeight),
                    _buildDetailRow('Total Sodium:', '${totalSodium} mg', screenHeight),
                    _buildDetailRow('Total Sugar:', '${totalSugar} g', screenHeight),
                    SizedBox(height: screenHeight * 0.02),
                    Text(
                      'Ingredients:',
                      style: GoogleFonts.poppins(
                        fontSize: screenHeight * 0.028,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    Text(
                      ingredients,
                      style: GoogleFonts.poppins(fontSize: screenHeight * 0.025),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Text(
                      'Contributed by:',
                      style: GoogleFonts.poppins(
                        fontSize: screenHeight * 0.028,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    Text(
                      userName,
                      style: GoogleFonts.poppins(fontSize: screenHeight * 0.025),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
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
}
