import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ship_easy/helper%20functions/color_manager.dart';
import 'package:ship_easy/helper%20functions/shared_widgets.dart';
import 'package:ship_easy/views/Dashboard/driver_dashboard.dart';

class DriverSignUp extends StatefulWidget {
  const DriverSignUp({super.key});

  @override
  State<DriverSignUp> createState() => _DriverSignUpState();
}

class _DriverSignUpState extends State<DriverSignUp>
    with AutomaticKeepAliveClientMixin {
  final GlobalKey<FormState> formKey = GlobalKey();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final TextEditingController confirmPassController = TextEditingController();
  final TextEditingController transporterController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController truckNoController = TextEditingController();
  final TextEditingController truckCapacityController = TextEditingController();
  final TextEditingController expController = TextEditingController();
  final TextEditingController fromState1 = TextEditingController();
  final TextEditingController fromCity1 = TextEditingController();
  final TextEditingController toState1 = TextEditingController();
  final TextEditingController toCity1 = TextEditingController();
  final TextEditingController fromState2 = TextEditingController();
  final TextEditingController fromCity2 = TextEditingController();
  final TextEditingController toState2 = TextEditingController();
  final TextEditingController toCity2 = TextEditingController();
  final TextEditingController fromState3 = TextEditingController();
  final TextEditingController fromCity3 = TextEditingController();
  final TextEditingController toState3 = TextEditingController();
  final TextEditingController toCity3 = TextEditingController();
  bool passVisibilty = false;
  bool confirmPassVisibilty = false;
  bool isLoading = false;

  final InputBorder _border = const OutlineInputBorder(
      borderSide: BorderSide(
        color: Color(0XFF707070),
        width: 1,
      ),
      borderRadius: BorderRadius.all(
        Radius.circular(15),
      ));

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                verticalGap(20),
                //full name
                TextFormField(
                  controller: nameController,
                  validator: (value) {
                    if (value == null || value == '') {
                      return 'This feild cannot be empty';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      border: _border,
                      focusedBorder: _border,
                      labelText: 'Full Name'),
                ),

                verticalGap(20),
                //email
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
                      border: _border,
                      focusedBorder: _border,
                      labelText: 'Email'),
                ),

                verticalGap(20),
                //password
                TextFormField(
                  validator: (value) {
                    if (value == null || value == '') {
                      return 'This feild cannot be empty';
                    }
                    if (value.length < 5) {
                      return 'Password should be atleast 5 digits long';
                    }
                    return null;
                  },
                  controller: passController,
                  obscureText: !passVisibilty,
                  decoration: InputDecoration(
                      border: _border,
                      focusedBorder: _border,
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
                      labelText: 'Password'),
                ),

                verticalGap(20),
                //confirm password
                TextFormField(
                  controller: confirmPassController,
                  validator: (value) {
                    if (passController.text != confirmPassController.text) {
                      return 'Confirm password ans password should be same';
                    }
                    return null;
                  },
                  obscureText: !confirmPassVisibilty,
                  decoration: InputDecoration(
                      border: _border,
                      focusedBorder: _border,
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            confirmPassVisibilty = !confirmPassVisibilty;
                          });
                        },
                        icon: Icon(
                          !confirmPassVisibilty
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: ColorManager.grey,
                        ),
                      ),
                      labelText: 'Confirm Password'),
                ),

                verticalGap(20),
                // phone no
                TextFormField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value == '') {
                      return 'This feild cannot be empty';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      border: _border,
                      focusedBorder: _border,
                      labelText: 'Phone no.',
                      prefixIcon: const SizedBox(
                          height: 50,
                          width: 50,
                          child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                '+91',
                                style: TextStyle(fontSize: 16),
                              )))),
                ),

                verticalGap(20),
                //transporter Name
                TextFormField(
                  controller: transporterController,
                  validator: (value) {
                    if (value == null || value == '') {
                      return 'This feild cannot be empty';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      border: _border,
                      focusedBorder: _border,
                      labelText: 'Transporter Name'),
                ),

                verticalGap(20),
                Row(
                  children: [
                    //age
                    Expanded(
                      child: TextFormField(
                        controller: ageController,
                        validator: (value) {
                          if (value == null || value == '') {
                            return 'This feild cannot be empty';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            border: _border,
                            focusedBorder: _border,
                            labelText: 'Age'),
                      ),
                    ),

                    horizontalGap(15),

                    //truck no.
                    Expanded(
                      child: TextFormField(
                        controller: truckNoController,
                        validator: (value) {
                          if (value == null || value == '') {
                            return 'This feild cannot be empty';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            border: _border,
                            focusedBorder: _border,
                            labelText: 'Truck No.'),
                      ),
                    ),
                  ],
                ),
                verticalGap(20),
                Row(
                  children: [
                    // truck capacity
                    Expanded(
                      child: TextFormField(
                        controller: truckCapacityController,
                        validator: (value) {
                          if (value == null || value == '') {
                            return 'This feild cannot be empty';
                          }
                          if (double.tryParse(value) == null) {
                            return 'invalid input';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            border: _border,
                            focusedBorder: _border,
                            labelText: 'Truck Capacity (tons)'),
                      ),
                    ),

                    horizontalGap(15),
                    // driving experience
                    Expanded(
                      child: TextFormField(
                        controller: expController,
                        validator: (value) {
                          if (value == null || value == '') {
                            return 'This feild cannot be empty';
                          }
                          if (int.tryParse(value) == null) {
                            return 'invalid input';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            border: _border,
                            focusedBorder: _border,
                            labelText: 'Driving Exp. (yrs)'),
                      ),
                    ),
                  ],
                ),
                verticalGap(20),
                const Text(
                  'Mention your 3 interested routes',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17),
                ),
                verticalGap(15),
                const Text(
                  'Route 1*',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                ),
                verticalGap(10),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: fromState1,
                        validator: (value) {
                          if (value == null || value == '') {
                            return 'This feild cannot be empty';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            border: _border,
                            focusedBorder: _border,
                            labelText: 'From State'),
                      ),
                    ),
                    horizontalGap(15),
                    Expanded(
                      child: TextFormField(
                        controller: toState1,
                        validator: (value) {
                          if (value == null || value == '') {
                            return 'This feild cannot be empty';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            border: _border,
                            focusedBorder: _border,
                            labelText: 'To State'),
                      ),
                    ),
                  ],
                ),

                verticalGap(10),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: fromCity1,
                        validator: (value) {
                          if (value == null || value == '') {
                            return 'This feild cannot be empty';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            border: _border,
                            focusedBorder: _border,
                            labelText: 'From City'),
                      ),
                    ),
                    horizontalGap(15),
                    Expanded(
                      child: TextFormField(
                        controller: toCity1,
                        validator: (value) {
                          if (value == null || value == '') {
                            return 'This feild cannot be empty';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            border: _border,
                            focusedBorder: _border,
                            labelText: 'To City'),
                      ),
                    ),
                  ],
                ),

                verticalGap(15),
                const Text(
                  'Route 2',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                ),

                verticalGap(10),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: fromState2,
                        decoration: InputDecoration(
                            border: _border,
                            focusedBorder: _border,
                            labelText: 'From State'),
                      ),
                    ),
                    horizontalGap(15),
                    Expanded(
                      child: TextFormField(
                        controller: toState2,
                        decoration: InputDecoration(
                            border: _border,
                            focusedBorder: _border,
                            labelText: 'To State'),
                      ),
                    ),
                  ],
                ),

                verticalGap(10),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: fromCity2,
                        decoration: InputDecoration(
                            border: _border,
                            focusedBorder: _border,
                            labelText: 'From City'),
                      ),
                    ),
                    horizontalGap(15),
                    Expanded(
                      child: TextFormField(
                        controller: toCity2,
                        decoration: InputDecoration(
                            border: _border,
                            focusedBorder: _border,
                            labelText: 'To City'),
                      ),
                    ),
                  ],
                ),

                verticalGap(15),
                const Text(
                  'Route 3',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                ),

                verticalGap(10),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: fromState3,
                        decoration: InputDecoration(
                            border: _border,
                            focusedBorder: _border,
                            labelText: 'From State'),
                      ),
                    ),
                    horizontalGap(15),
                    Expanded(
                      child: TextFormField(
                        controller: toState3,
                        decoration: InputDecoration(
                            border: _border,
                            focusedBorder: _border,
                            labelText: 'To State'),
                      ),
                    ),
                  ],
                ),

                verticalGap(10),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: fromCity3,
                        decoration: InputDecoration(
                            border: _border,
                            focusedBorder: _border,
                            labelText: 'From City'),
                      ),
                    ),
                    horizontalGap(15),
                    Expanded(
                      child: TextFormField(
                        controller: toCity3,
                        decoration: InputDecoration(
                            border: _border,
                            focusedBorder: _border,
                            labelText: 'To City'),
                      ),
                    ),
                  ],
                ),

                verticalGap(20),
                SizedBox(
                  height: 60,
                  width: double.infinity,
                  child: customButton('Sign Up', () async {
                    FocusScope.of(context).unfocus();
                    bool? validateForm = formKey.currentState?.validate();
                    if (validateForm == null || !validateForm) return;
                    try {
                      setState(() {
                        isLoading = true;
                      });
                      UserCredential user = await FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                              email: emailController.text,
                              password: passController.text);

                      Map<String, String> routes = {
                        'stateFrom1': fromState1.text.trim(),
                        'cityFrom1': fromCity1.text.trim(),
                        'stateTo1': toState1.text.trim(),
                        'cityTo1': toCity1.text.trim(),
                      };

                      if (fromState2.text.trim() != '' &&
                          toState2.text.trim() != '' &&
                          fromCity2.text.trim() != '' &&
                          toCity2.text.trim() != '') {
                        routes.addAll({
                          'stateFrom2': fromState2.text.trim(),
                          'cityFrom2': fromCity2.text.trim(),
                          'stateTo2': toState2.text.trim(),
                          'cityTo2': toCity2.text.trim(),
                        });
                      }

                      if (fromState3.text.trim() != '' &&
                          toState3.text.trim() != '' &&
                          fromCity3.text.trim() != '' &&
                          toCity3.text.trim() != '') {
                        routes.addAll({
                          'stateFrom3': fromState3.text.trim(),
                          'cityFrom3': fromCity3.text.trim(),
                          'stateTo3': toState3.text.trim(),
                          'cityTo3': toCity3.text.trim(),
                        });
                      }

                      FirebaseFirestore.instance
                          .collection('Users')
                          .doc(user.user!.uid)
                          .set({
                        'accountType': 'Driver',
                        'userName': nameController.text,
                        'phoneNo': phoneController.text,
                        'transporterName': transporterController.text,
                        'age': ageController.text,
                        'truckNo': truckNoController.text,
                        'truckCapacity': truckCapacityController.text,
                        'drivingExp': expController.text,
                        'routes': routes,
                        'requests': [],
                      });

                      if (!mounted) return;

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const DriverDashboard()),
                      );
                    } on FirebaseAuthException catch (error) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(error.message!)));
                    }

                    setState(() {
                      isLoading = false;
                    });
                  }, isLoading: isLoading),
                ),
                verticalGap(50),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
