import 'package:flutter/material.dart';
import 'package:ship_easy/helper%20functions/color_manager.dart';

import 'dealer_sign_up.dart';
import 'driver_sign_up.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: ColorManager.blue,
            iconTheme: const IconThemeData(color: Colors.white),
            toolbarHeight: kToolbarHeight + 10,
            centerTitle: true,
            title: const Text(
              'Sign Up Form',
              style: TextStyle(color: Colors.white),
            ),
            bottom: TabBar(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                unselectedLabelColor: Colors.white60,
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                labelColor: Colors.white,
                indicator: BoxDecoration(
                    color: const Color.fromARGB(255, 143, 154, 213)
                        .withOpacity(0.5),
                    borderRadius: BorderRadius.circular(30)),
                labelStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
                tabs: const [
                  Tab(
                    text: 'Dealer',
                  ),
                  Tab(
                    text: 'Driver',
                  ),
                ]),
          ),
          body: const TabBarView(children: [
            DealerSignUp(),
            DriverSignUp(),
          ])),
    );
  }
}
