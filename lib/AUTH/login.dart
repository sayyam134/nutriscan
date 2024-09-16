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
  bool _isLoading = false; // Add this

  _login() async {
    if (_validate()) {
      setState(() {
        _isLoading = true; // Start loading
      });
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: _email.text, password: _pass.text);
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
      } finally {
        setState(() {
          _isLoading = false; // Stop loading
        });
      }
    }
  }

  _google_login() async {
    setState(() {
      if (mounted) _isLoading = true; // Ensure widget is mounted
    });
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      User? user = FirebaseAuth.instance.currentUser;
      var res = await FirebaseFirestore.instance.collection('users').doc(user?.uid).get();
      if (!res.exists) {
        await FirebaseFirestore.instance.collection('users').doc(user?.uid).set({
          'name': user?.displayName,
          'email': user?.email,
          'acceptTerms': false,
        });
      }
    } catch (e) {
      if (mounted) {
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
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false; // Stop loading if mounted
        });
      }
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
      body: Stack(
        children: [
          Padding(
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
                    height: 244,
                    width: 244,
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
                        width: 358,
                        height: 48,
                        child: TextField(
                          controller: _email,
                          decoration: InputDecoration(
                            hintText: 'Email',
                            filled: true,
                            fillColor: Colors.white,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.grey,
                                  width: 1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.black, width: 1),
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
                      SizedBox(
                        height: (MediaQuery.of(context).size.height / 100) * 1.8,
                      ),
                      SizedBox(
                        width: 358,
                        height: 48,
                        child: TextField(
                          controller: _pass,
                          obscureText: _obscureText,
                          decoration: InputDecoration(
                            hintText: 'Password',
                            filled: true,
                            fillColor: Colors.white,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.grey,
                                  width: 1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.black, width: 1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureText
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                            ),
                          ),
                          style: GoogleFonts.roboto(
                            fontSize: 15,
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
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
                              fontSize: 14,
                              color: Color(0xFF007AFF),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: SizedBox(
                          width: 350,
                          height: 40,
                          child: ElevatedButton(
                            onPressed: _login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF007AFF),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              'Sign in',
                              style: GoogleFonts.roboto(
                                fontSize: 15,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
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
                                Image.asset(
                                  'assets/images/google.webp',
                                  height: 28,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Sign in with Google',
                                  style: GoogleFonts.roboto(
                                    fontSize: 15,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: (MediaQuery.of(context).size.height / 100) * 2,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: TextButton(
                          onPressed: () => Get.to(Signup()),
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "Don't have an account? ",
                                  style: GoogleFonts.poppins(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,
                                  ),
                                ),
                                TextSpan(
                                  text: "Sign up",
                                  style: GoogleFonts.poppins(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFF007AFF),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (_isLoading) // Show progress indicator if loading
            Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}

