import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final user = FirebaseAuth.instance.currentUser;

  _signout() async{
    await GoogleSignIn().signOut();
    await FirebaseAuth.instance.signOut();
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Hello , ${user!.email}"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _signout,
        child: Icon(Icons.logout_outlined),
      ),
    );
  }
}
