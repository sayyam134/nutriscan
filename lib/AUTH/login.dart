import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nutriscan/AUTH/forget.dart';
import 'package:nutriscan/AUTH/signup.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _email = TextEditingController();
  TextEditingController _pass = TextEditingController();

  bool _obscureText = true;

  _login() async {
    if (_validate()) {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(email: _email.text, password: _pass.text);
        Get.snackbar(
          "Success",
          "Logged in successfully!",
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

      } catch (e) {
        Get.snackbar(
          "Error",
          e.toString(),
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }
  }

  _google_login() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
      await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      try {
        User? user = FirebaseAuth.instance.currentUser;
        var res = await FirebaseFirestore.instance.collection('users').doc(user?.uid).get();
        if(!res.exists){
          await FirebaseFirestore.instance.collection('users').doc(user?.uid).set({
            'name': user?.displayName,
            'email': user?.email,
          });
        }
      } catch (e) {
        Get.snackbar(
          'Log In Failed',
          e.toString(),
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.red,
          colorText: Colors.white,
          margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
        );
      }
    } catch (e) {
      // Handle Google sign-in errors
      print(e.toString());
      Get.snackbar(
        'Error',
        'Google Sign-In failed',
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 2),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
      );
    }
  }

  bool _validate() {
    if (_email.text.isEmpty || !_email.text.contains('@')) {
      Get.snackbar(
        "Invalid Email",
        "Please enter a valid email address",
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } else if (_pass.text.isEmpty || _pass.text.length < 8) {
      Get.snackbar(
        "Invalid Password",
        "Password must be at least 8 characters",
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    precacheImage(const AssetImage('assets/images/logo.png'), context);

    return Scaffold(
      backgroundColor: const Color(0xFFFFF7EE),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: (MediaQuery.of(context).size.height / 100) * 7.5,
              ),
              Image.asset(
                'assets/images/logo.png',
                height: 244, // Set height to 244 pixels
                width: 244, // Set width to 244 pixels
                fit: BoxFit.cover,
              ),
              const SizedBox(
                width: double.infinity,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Welcome,",
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: (MediaQuery.of(context).size.height / 100) * 2.5,
                  ),
                  SizedBox(
                    width: 358, // Set width
                    height: 48, // Set height
                    child: TextField(
                      controller: _email,
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
                    height: (MediaQuery.of(context).size.height / 100) * 1.8,
                  ),
                  SizedBox(
                    width: 358, // Set width
                    height: 48, // Set height
                    child: TextField(
                      controller: _pass,
                      obscureText: _obscureText, // Hide or show password
                      decoration: InputDecoration(
                        hintText: 'Password', // Placeholder text
                        filled: true,
                        fillColor: Colors.white, // Inner color
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.grey,
                              width: 1), // Initial border color
                          borderRadius: BorderRadius.circular(8), // Optional rounded corners
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.black, width: 1), // Border on click
                          borderRadius: BorderRadius.circular(8),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureText
                                ? Icons.visibility
                                : Icons.visibility_off, // Show or hide password icon
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText; // Toggle the obscure text
                            });
                          },
                        ),
                      ),
                      style: GoogleFonts.roboto(
                        fontSize: 15, // Font size
                        color: Colors.black, // Text color
                        fontWeight: FontWeight.w400, // Regular weight
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => Get.to(ForgetPass()),
                      child: Text(
                        "Forget Password?",
                        style: GoogleFonts.poppins(
                          fontSize: 14, // Font size
                          color: Color(0xFF007AFF), // Text color in hexadecimal
                          fontWeight: FontWeight.w400, // Regular weight
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: 350, // Set button width
                      height: 40, // Set button height
                      child: ElevatedButton(
                        onPressed: _login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF007AFF), // Button background color (007AFF)
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8), // Optional: for rounded corners
                          ),
                        ),
                        child: Text(
                          'Sign in',
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
                    height: (MediaQuery.of(context).size.height / 100) * 1.5,
                  ),
                  const Divider(
                    thickness: 1,
                    color: Colors.black,
                  ),
                  SizedBox(
                    height: (MediaQuery.of(context).size.height / 100) * 1.5,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: 350, // Set button width
                      height: 40, // Set button height
                      child: ElevatedButton(
                        onPressed: _google_login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF333333), // Button background color (#333333)
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8), // Optional: for rounded corners
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/google.webp', // Google logo
                              height: 28, // Adjust the size of the logo
                            ),
                            SizedBox(width: 8), // Space between logo and text
                            Text(
                              'Sign in with Google',
                              style: GoogleFonts.poppins(
                                fontSize: 12, // Font size
                                color: Colors.white, // Text color
                                fontWeight: FontWeight.w400, // Regular weight
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don’t have an account?",
                        style: GoogleFonts.poppins(
                          fontSize: 12, // Font size
                          color: Colors.black, // Text color
                          fontWeight: FontWeight.w400, // Regular weight
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Get.to(Signup());
                        },
                        child: Text(
                          "Sign up",
                          style: GoogleFonts.poppins(
                            fontSize: 12, // Font size
                            color: Color(0xFF007AFF), // Text color
                            fontWeight: FontWeight.w400, // Regular weight
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
