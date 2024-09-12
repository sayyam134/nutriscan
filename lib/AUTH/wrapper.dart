import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nutriscan/AUTH/login.dart';
import 'package:nutriscan/homepage.dart';

import 'userDetails.dart';
import 'email_verify.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {

  // Function to check Firestore for _acceptTerm field
  Future<bool> _checkAcceptTerm() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid) // Fetch document with the user's UID
          .get();

      if (userDoc.exists && userDoc.data() != null) {
        // Check if _acceptTerm is true
        return userDoc.get('acceptTerms') == true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            User? user = snapshot.data;
            if (user!.emailVerified) {
              // If email is verified, check Firestore for _acceptTerm field
              return FutureBuilder<bool>(
                future: _checkAcceptTerm(),
                builder: (context, futureSnapshot) {
                  if (futureSnapshot.connectionState == ConnectionState.waiting) {
                    // Show a loading spinner while waiting for Firestore result
                    return Center(child: CircularProgressIndicator());
                  } else if (futureSnapshot.hasData) {
                    // If _acceptTerm is true, go to HomePage, else go to PersonalizeScreen
                    if (futureSnapshot.data == true) {
                      return HomePage();
                    } else {
                      return PersonalizeScreen();
                    }
                  } else {
                    // Handle error or fallback case (e.g., if Firestore read fails)
                    return PersonalizeScreen();
                  }
                },
              );
            } else {
              // If email is not verified, show email verification screen
              return VerifyEmail();
            }
          } else {
            // If no user is signed in, show the login screen
            return Login();
          }
        },
      ),
    );
  }
}
