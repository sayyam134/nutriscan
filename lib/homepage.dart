import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? _userName;

  @override
  void initState() {
    super.initState();
    _fetchUserName();
  }

  Future<void> _fetchUserName() async {
    User? user = _auth.currentUser;

    if (user != null) {
      // Fetch user document from Firestore
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();

      if (userDoc.exists) {
        setState(() {
          _userName = userDoc['name']; // Assuming the field is named 'name'
        });
      } else {
        // Handle case where user document does not exist
        setState(() {
          _userName = user.displayName; // Fallback to displayName if Firestore document is missing
        });
      }
    }
  }

  Future<void> _signout() async {
    await GoogleSignIn().signOut();
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _userName != null
            ? Text("Hello, $_userName")
            : CircularProgressIndicator(), // Show loading spinner while fetching data
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _signout,
        child: Icon(Icons.logout_outlined),
      ),
    );
  }
}
