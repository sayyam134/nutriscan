import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nutriscan/AUTH/login.dart';
import 'package:nutriscan/homepage.dart';

import '../userDetails.dart';
import 'email_verify.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context,snapshot){
          if(snapshot.hasData){
            if(snapshot.data!.emailVerified){
              return PersonalizeScreen();
            }
            else{
              return VerifyEmail();
            }
          }
          else{
            return Login();
          }
        },

      ),
    );
  }
}
