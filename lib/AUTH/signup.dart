import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nutriscan/AUTH/login.dart';
import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nutriscan/AUTH/wrapper.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _newemail = TextEditingController();
  final TextEditingController _newpass = TextEditingController();
  final TextEditingController _newconfirmpass = TextEditingController();

  bool _obscureText1 = true;
  bool _obscureText2 = true;

  // Regex pattern for password validation
  final RegExp passwordRegExp = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).{8,}$'); // 1 lowercase, 1 uppercase, 1 number, 1 symbol

  // Email validation using Regex
  final RegExp emailRegExp =
      RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");

  // Google Sign-In Function
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

  // Sign-Up Function with Error Handling
  _signUp() async {
    String email = _newemail.text.trim();
    String password = _newpass.text.trim();
    String confirmPassword = _newconfirmpass.text.trim();
    String name = _name.text.trim();

    // Email validation
    if (!emailRegExp.hasMatch(email)) {
      Get.snackbar(
        'Invalid Email',
        'Please enter a valid email address.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
      );
      return;
    }

    // Password validation
    if (!passwordRegExp.hasMatch(password)) {
      Get.snackbar(
        'Weak Password',
        'Password must be at least 8 characters long and include \n1 symbol \n1 number \n1 uppercase alphabet and \n1 lowercase alphabet.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 4),
        backgroundColor: Colors.yellow[700],
        colorText: Colors.black,
        margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
      );
      return;
    }

    // Confirm password validation
    if (password != confirmPassword) {
      Get.snackbar(
        'Password Mismatch',
        'Passwords do not match. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
      );
      return;
    }

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      await FirebaseFirestore.instance.collection('users').doc(userCredential.user?.uid).set({
        'name': name,
        'email': email,
      });
      //await Future.delayed(Duration(seconds: 1));
      Get.snackbar(
        'Success',
        'Account created successfully!',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.green,
        colorText: Colors.white,
        margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
      );
      await Future.delayed(Duration(seconds: 1));
      Get.to(Wrapper());
    } catch (e) {
      Get.snackbar(
        'Sign Up Failed',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: (MediaQuery.of(context).size.height / 100) * 13),
              Text(
                "Let's Sign Up",
                style: GoogleFonts.poppins(
                  fontSize: 40,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: (MediaQuery.of(context).size.height / 100) * 5),
              _buildTextField(_name, 'Enter Name'),
              SizedBox(height: (MediaQuery.of(context).size.height / 100) * 3),
              _buildTextField(_newemail, 'Enter Email'),
              SizedBox(height: (MediaQuery.of(context).size.height / 100) * 3),
              _buildPasswordField(_newpass, 'Enter Password', _obscureText1,
                  () {
                setState(() {
                  _obscureText1 = !_obscureText1;
                });
              }),
              SizedBox(height: (MediaQuery.of(context).size.height / 100) * 3),
              _buildPasswordField(
                  _newconfirmpass, 'Enter Confirm Password', _obscureText2, () {
                setState(() {
                  _obscureText2 = !_obscureText2;
                });
              }),
              SizedBox(height: (MediaQuery.of(context).size.height / 100) * 4),
              _buildSignupButton(),
              SizedBox(
                  height: (MediaQuery.of(context).size.height / 100) * 1.5),
              const Divider(thickness: 1, color: Colors.black),
              SizedBox(
                  height: (MediaQuery.of(context).size.height / 100) * 1.5),
              _buildGoogleSignInButton(),
              _buildLoginLink(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint) {
    return SizedBox(
      width: 358,
      height: 48,
      child: TextField(
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

  Widget _buildPasswordField(TextEditingController controller, String hint,
      bool obscureText, VoidCallback toggleObscure) {
    return SizedBox(
      width: 358,
      height: 48,
      child: TextField(
        controller: controller,
        obscureText: obscureText,
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
          suffixIcon: IconButton(
            icon: Icon(obscureText ? Icons.visibility : Icons.visibility_off),
            onPressed: toggleObscure,
          ),
        ),
        style: GoogleFonts.roboto(
            fontSize: 15, color: Colors.black, fontWeight: FontWeight.w400),
      ),
    );
  }

  Widget _buildSignupButton() {
    return Align(
      alignment: Alignment.center,
      child: SizedBox(
        width: 350,
        height: 40,
        child: ElevatedButton(
          onPressed: _signUp,
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF007AFF),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            'Sign Up',
            style: GoogleFonts.roboto(
                fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _buildGoogleSignInButton() {
    return Align(
      alignment: Alignment.center,
      child: SizedBox(
        width: 350,
        height: 40,
        child: ElevatedButton(
          onPressed: _google_login,
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF333333),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/google.webp', height: 28),
              SizedBox(width: 8),
              Text(
                'Sign in with Google',
                style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoginLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Already have an account?"),
        TextButton(
          onPressed: () => Get.to(Login()),
          child: Text(
            "Login Now",
            style: GoogleFonts.poppins(
                fontSize: 14,
                color: Color(0xFF007AFF),
                fontWeight: FontWeight.w400),
          ),
        ),
      ],
    );
  }
}
