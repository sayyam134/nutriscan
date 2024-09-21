// scan_products_page.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ScanProductsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Scan Products',
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Center(
        child: Text('Scan Products Content'),
      ),
    );
  }
}
