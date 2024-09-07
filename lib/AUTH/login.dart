import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
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
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: _email.text, password: _pass.text);
  }

  _google_login() async{
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken
    );

    await FirebaseAuth.instance.signInWithCredential(credential);
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
                      fontSize: 20,
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
                                : Icons
                                    .visibility_off, // Show or hide password icon
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureText =
                                  !_obscureText; // Toggle the obscure text
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
                              color: Color(
                                  0xFF007AFF), // Text color in hexadecimal
                              fontWeight: FontWeight.w400, // Regular weight
                            ),
                          ))),
                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: 350, // Set button width
                      height: 40, // Set button height
                      child: ElevatedButton(
                        onPressed: _login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(
                              0xFF007AFF), // Button background color (007AFF)
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                8), // Optional: for rounded corners
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
                      Text("Don't have an account?"),
                      TextButton(onPressed: ()=> Get.to(Signup()),
                          child: Text("Sign Up Now",
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
