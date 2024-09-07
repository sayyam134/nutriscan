import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class ForgetPass extends StatefulWidget {
  const ForgetPass({super.key});

  @override
  State<ForgetPass> createState() => _ForgetPassState();
}

class _ForgetPassState extends State<ForgetPass> {
  final TextEditingController _recoveryEmail = TextEditingController();

  _resetPass() async {
    if (_recoveryEmail.text.isEmpty) {
      _showSnackbar('Error', 'Please enter your email', Colors.red);
    } else if (!GetUtils.isEmail(_recoveryEmail.text)) {
      _showSnackbar('Error', 'Please enter a valid email', Colors.red);
    } else {
      try {
        await FirebaseAuth.instance
            .sendPasswordResetEmail(email: _recoveryEmail.text);
        _showSnackbar('Success', 'Password reset link sent!', Colors.green);
      } catch (e) {
        _showSnackbar('Error', e.toString(), Colors.red);
      }
    }
  }

  _showSnackbar(String title, String message, Color color) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(seconds: 2),
      backgroundColor: color,
      colorText: Colors.white,
      margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
      borderRadius: 10,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: (MediaQuery.of(context).size.height / 100) * 7.5),
              Lottie.asset("assets/animation/forget.json"),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Reset Password',
                  style: GoogleFonts.poppins(
                    fontSize: 38,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(height: (MediaQuery.of(context).size.height / 100) * 2),
              SizedBox(
                width: 358,
                height: 48,
                child: TextField(
                  controller: _recoveryEmail,
                  decoration: InputDecoration(
                    hintText: 'Email',
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
              ),
              SizedBox(height: (MediaQuery.of(context).size.height / 100) * 4),
              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: 350,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: _resetPass,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF007AFF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Send Link',
                      style: GoogleFonts.roboto(
                        fontSize: 15,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: (MediaQuery.of(context).size.height / 100) * 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Go back to",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(
                    width: (MediaQuery.of(context).size.width / 100) * 1,
                  ),
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Text(
                      "Login",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Color(0xFF007AFF),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
