import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ship_easy/views/Dashboard/dealer_dashboard.dart';
import 'package:ship_easy/views/Dashboard/driver_dashboard.dart';
import 'package:ship_easy/views/auth/Sign%20In/sign_in.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<void> fetchAccountType() async {
    Widget screen;
    if (FirebaseAuth.instance.currentUser == null) {
      screen = const SignInScreen();
    } else {
      final doc = (await FirebaseFirestore.instance
              .collection('Users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .get())
          .data();

      final accountType = doc?['accountType'];

      screen = accountType == 'Dealer'
          ? const DealerDashBoard()
          : const DriverDashboard();
    }
    Future.delayed(const Duration(seconds: 2)).then((value) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => screen),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    fetchAccountType();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFFF0F2F6),
      body: Center(
        child: Image.asset(
          'assets/images/truck.jpg',
          // width: 200,
        ),
      ),
    );
  }
}
