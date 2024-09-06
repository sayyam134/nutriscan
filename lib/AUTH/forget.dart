import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class ForgetPass extends StatefulWidget {
  const ForgetPass({super.key});

  @override
  State<ForgetPass> createState() => _ForgetPassState();
}

class _ForgetPassState extends State<ForgetPass> {

  TextEditingController _recoveryemail = TextEditingController();

  _resetpass()async{
    await FirebaseAuth.instance.sendPasswordResetEmail(email: _recoveryemail.text);
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
              SizedBox(
                height: (MediaQuery.of(context).size.height / 100) * 7.5,
              ),
              Lottie.asset("assets/animation/forget.json"),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                            'Reset Password',
                            style: GoogleFonts.poppins(
                fontSize: 38, // Font size
                fontWeight: FontWeight.w600, // Semi-bold weight
                color: Colors.black, // Text color
                            ),
                          ),
              ),
              SizedBox(
                height: (MediaQuery.of(context).size.height / 100) * 2,
              ),
              SizedBox(
                width: 358, // Set width
                height: 48, // Set height
                child: TextField(
                  controller: _recoveryemail,
                  decoration: InputDecoration(
                    hintText: 'Email', // Placeholder text
                    filled: true,
                    fillColor: Colors.white, // Inner color
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.grey,
                          width: 1), // Initial border color
                      borderRadius: BorderRadius.circular(8), // Optional: for rounded corners
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.black, width: 1), // Border on click
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  style: GoogleFonts.roboto(
                    fontSize: 15, // Font size
                    color: Colors.black, // Text color
                    fontWeight: FontWeight.w400, // Regular weight
                  ),
                ),
              ),
              SizedBox(
                height: (MediaQuery.of(context).size.height / 100) * 4,
              ),
              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: 350, // Set button width
                  height: 40, // Set button height
                  child: ElevatedButton(
                    onPressed: _resetpass,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(
                          0xFF007AFF), // Button background color (007AFF)
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            8), // Optional: for rounded corners
                      ),
                    ),
                    child: Text(
                      'Send Link',
                      style: GoogleFonts.roboto(
                        fontSize: 15, // Font size
                        color: Colors.white, // Text color
                        fontWeight: FontWeight.bold, // Font weight
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: (MediaQuery.of(context).size.height / 100) * 1,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Go back to"),
                  TextButton(onPressed: ()=> Get.back(),
                      child: Text("Login",
                        style: GoogleFonts.poppins(
                          fontSize: 14, // Font size
                          color: Color(
                              0xFF007AFF), // Text color in hexadecimal
                          fontWeight: FontWeight.w400, // Regular weight
                        ),
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
