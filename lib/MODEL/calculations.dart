import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Calculations {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late int _age;
  late double _weight;
  late double _height;
  late int _gender;
  late double _activity;
  late bool _isdiabetic;
  late bool _isHypertensive;

  late double _BMR;
  late double _totalCal;
  late double _carbs;
  late double _protein;
  late double _fats;
  late double _sugar;
  late double _sodium;

  Future<void> fetchDetails() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();
        if (userDoc.exists) {
          _age = userDoc['age'];
          _height = userDoc['height'];
          _weight = userDoc['weight'];
          _gender = userDoc['gender'];
          _activity = userDoc['activityLevel'];
          _isdiabetic = userDoc['isDiabetic'];
          _isHypertensive = userDoc['isHypertensive'];
        } else {
          print('User document does not exist');
        }
      } else {
        print('User is not signed in');
      }
    } catch (e) {
      print('Failed to fetch user details: $e');
    }
  }

  void calculate() {
    try {
      if (_gender == 1) {
        _BMR = 66.5 + (13.75 * _weight) + (5.003 * _height) - (6.75 * _age);
      } else if (_gender == 2) {
        _BMR = 655.1 + (9.563 * _weight) + (1.850 * _height) - (4.676 * _age);
      } else {
        _BMR = 66.5 + (13.75 * _weight) + (5.003 * _height) - (6.75 * _age);
      }

      _totalCal = _BMR * _activity;
      _carbs = (0.6 * _totalCal * 0.129598);
      _protein = min((_weight * 0.8), (0.2 * _totalCal) * 0.129598);
      _fats = (0.2 * _totalCal) * 0.129598;

      _sugar = _isdiabetic ? 5 : 50;
      _sodium = _isHypertensive ? 999 : 2000;

      print("Total calories : ${_totalCal.round()} kcal");
      print("Total carbs : ${_carbs.round()} g");
      print("Total protein : ${_protein.round()} g");
      print("Total fats : ${_fats.round()} g");
      print("Total sugar : ${_sugar.round()} g");
      print("Total sodium : ${_sodium.round()} g");
    } catch (e) {
      print('Error in calculation: $e');
    }
  }

  Future<void> updateDetails() async {
    try {
      await fetchDetails();
      calculate();

      User? user = _auth.currentUser;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).update({
          'Tcal': _totalCal.round(),
          'Tcarbs': _carbs.round(),
          'Tprotein': _protein.round(),
          'Tfats': _fats.round(),
          'Tsugar': _sugar.round(),
          'Tsodium': _sodium.round(),
        });
      } else {
        print('User is not signed in');
      }
    } catch (e) {
      print('Failed to update user details: $e');
    }
  }
}
