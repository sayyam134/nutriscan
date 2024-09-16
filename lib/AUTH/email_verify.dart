import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:nutriscan/AUTH/wrapper.dart';

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({super.key});

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    sendVerifyLink();
    // Start the timer to check email verification status every 5 seconds
    _timer = Timer.periodic(Duration(seconds: 2), (timer) {
      _checkEmailVerified();
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  Future<void> sendVerifyLink() async {
    final user = FirebaseAuth.instance.currentUser!;
    await user.sendEmailVerification().then((value) {
      Get.snackbar(
        'Link Sent',
        'Check your mailbox and verify your Email.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.green,
        colorText: Colors.white,
        margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
      );
    });
  }

  Future<void> _checkEmailVerified() async {
    final user = FirebaseAuth.instance.currentUser!;
    await user.reload(); // Reload the user to update their information
    if (user.emailVerified) {
      _timer?.cancel(); // Stop checking once email is verified
      Get.offAll(Wrapper());
    }
  }

  Future<void> _reload() async {
    await FirebaseAuth.instance.currentUser!.reload();
    _checkEmailVerified(); // Check email verification status after reload
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
              SizedBox(height: (MediaQuery.of(context).size.height / 100) * 7.5),
              Lottie.asset("assets/animation/email_verify.json"),
              Text(
                'Verifying Email',
                style: GoogleFonts.poppins(
                  fontSize: 38,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: (MediaQuery.of(context).size.height / 100) * 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Any Trouble?",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(
                    width: (MediaQuery.of(context).size.width / 100) * 1,
                  ),
                  GestureDetector(
                    onTap: _reload,
                    child: Text(
                      "Reload",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Color(0xFF007AFF),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
