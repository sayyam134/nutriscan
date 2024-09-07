import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nutriscan/AUTH/login.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {

  TextEditingController _name = TextEditingController();
  TextEditingController _newemail = TextEditingController();
  TextEditingController _newpass = TextEditingController();
  TextEditingController _newconfirmpass = TextEditingController();

  bool _obscureText1 = true;
  bool _obscureText2 = true;

  _google_login() async{
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken
    );

    await FirebaseAuth.instance.signInWithCredential(credential);
  }

  _signUp()async{
    if(_newpass.text == _newconfirmpass.text){
      FirebaseAuth.instance.createUserWithEmailAndPassword(email: _newemail.text.trim(), password: _newpass.text.trim());
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
              SizedBox(
                height: (MediaQuery.of(context).size.height / 100) * 13,
              ),
              Text(
            "Let's Sign Up",
            style: GoogleFonts.poppins(
              fontSize: 40, // Font size
              fontWeight: FontWeight.w600, // Semi-bold weight
              color: Colors.black, // Text color
            ),
          ),
              SizedBox(
                height: (MediaQuery.of(context).size.height / 100) * 5,
              ),
              SizedBox(
                width: 358, // Set width
                height: 48, // Set height
                child: TextField(
                  controller: _name,
                  decoration: InputDecoration(
                    hintText: 'Enter Name', // Placeholder text
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
                height: (MediaQuery.of(context).size.height / 100) * 3,
              ),
              SizedBox(
                width: 358, // Set width
                height: 48, // Set height
                child: TextField(
                  controller: _newemail,
                  decoration: InputDecoration(
                    hintText: 'Enter Email', // Placeholder text
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
                height: (MediaQuery.of(context).size.height / 100) * 3,
              ),
              SizedBox(
                width: 358, // Set width
                height: 48, // Set height
                child: TextField(
                  controller: _newpass,
                  obscureText: _obscureText1, // Hide or show password
                  decoration: InputDecoration(
                    hintText: 'Enter Password', // Placeholder text
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
                        _obscureText1
                            ? Icons.visibility
                            : Icons
                            .visibility_off, // Show or hide password icon
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText1 =
                          !_obscureText1; // Toggle the obscure text
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
              SizedBox(
                height: (MediaQuery.of(context).size.height / 100) * 3,
              ),
              SizedBox(
                width: 358, // Set width
                height: 48, // Set height
                child: TextField(
                  controller: _newconfirmpass,
                  obscureText: _obscureText2, // Hide or show password
                  decoration: InputDecoration(
                    hintText: 'Enter Confirm Password', // Placeholder text
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
                        _obscureText2
                            ? Icons.visibility
                            : Icons
                            .visibility_off, // Show or hide password icon
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText2 =
                          !_obscureText2; // Toggle the obscure text
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
              SizedBox(
                height: (MediaQuery.of(context).size.height / 100) * 4,
              ),
              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: 350, // Set button width
                  height: 40, // Set button height
                  child: ElevatedButton(
                    onPressed: _signUp,
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
                  Text("Already have an account?"),
                  TextButton(onPressed: ()=> Get.to(Login()),
                      child: Text("Login Now",
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
