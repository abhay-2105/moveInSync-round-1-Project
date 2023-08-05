import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ship_easy/views/auth/Sign%20Up/sign_up.dart';

import '../../../helper functions/helper_functions.dart';
import '../../Dashboard/dealer_dashboard.dart';
import '../../Dashboard/driver_dashboard.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final GlobalKey<FormState> formKey = GlobalKey();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  bool passVisibilty = false;
  bool isLoading = false;

  Future<void> fetchAccountType() async {
    Widget screen;

    final doc = (await FirebaseFirestore.instance
            .collection('Users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get())
        .data();

    final accountType = doc?['accountType'];

    screen = accountType == 'Dealer'
        ? const DealerDashBoard()
        : const DriverDashboard();

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  verticalGap(40),
                  Align(
                    alignment: Alignment.center,
                    child: Image.asset(
                      'assets/images/truck.jpg',
                      width: 200,
                    ),
                  ),
                  const Text(
                    'Welcome back',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 28,
                    ),
                  ),
                  verticalGap(5),
                  const Text(
                    'Sign in to your account',
                    style: TextStyle(fontSize: 16, color: ColorManager.grey),
                  ),
                  verticalGap(15),
                  const Text(
                    'Email Address',
                    style: TextStyle(fontSize: 14, color: ColorManager.grey),
                  ),
                  verticalGap(10),
                  TextFormField(
                    controller: emailController,
                    validator: (value) {
                      if (value == null || value == '') {
                        return 'This feild cannot be empty';
                      }
                      if (!EmailValidator.validate(value)) {
                        return 'Invalid email address';
                      }

                      return null;
                    },
                    decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 16),
                        border: border,
                        focusedBorder: border,
                        hintText: 'Email'),
                  ),
                  verticalGap(20),
                  const Text(
                    'Password',
                    style: TextStyle(fontSize: 14, color: ColorManager.grey),
                  ),
                  verticalGap(10),
                  TextFormField(
                    controller: passController,
                    validator: (value) {
                      if (value == null || value == '') {
                        return 'This feild cannot be empty';
                      }
                      return null;
                    },
                    obscureText: !passVisibilty,
                    decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 16),
                        border: border,
                        focusedBorder: border,
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              passVisibilty = !passVisibilty;
                            });
                          },
                          icon: Icon(
                            !passVisibilty
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: ColorManager.grey,
                          ),
                        ),
                        hintText: 'Password'),
                  ),
                  Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        style: TextButton.styleFrom(),
                        onPressed: () {},
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(
                              color: ColorManager.orange,
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                        ),
                      )),
                  verticalGap(15),
                  SizedBox(
                    height: 60,
                    width: double.infinity,
                    child: customButton('Login', () async {
                      bool? validateForm = formKey.currentState?.validate();
                      if (validateForm == null || !validateForm) return;
                      try {
                        setState(() {
                          isLoading = true;
                        });
                        await FirebaseAuth.instance.signInWithEmailAndPassword(
                            email: emailController.text.trim(),
                            password: passController.text.trim());

                        await fetchAccountType();
                        return;
                      } on FirebaseAuthException catch (error) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(error.message!)));
                      }

                      setState(() {
                        isLoading = false;
                      });
                    }, isLoading: isLoading),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Don\'t have an account?',
                        style:
                            TextStyle(fontSize: 14, color: ColorManager.grey),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignUpScreen()));
                        },
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(
                              color: ColorManager.orange,
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
