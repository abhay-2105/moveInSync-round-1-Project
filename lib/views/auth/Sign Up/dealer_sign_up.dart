import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ship_easy/helper%20functions/color_manager.dart';
import 'package:ship_easy/helper%20functions/shared_widgets.dart';
import 'package:ship_easy/views/Dashboard/dealer_dashboard.dart';

class DealerSignUp extends StatefulWidget {
  const DealerSignUp({super.key});

  @override
  State<DealerSignUp> createState() => _DealerSignUpState();
}

class _DealerSignUpState extends State<DealerSignUp>
    with AutomaticKeepAliveClientMixin {
  final GlobalKey<FormState> formKey = GlobalKey();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController materialController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController qtyController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final TextEditingController confirmPassController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  bool passVisibilty = false;
  bool confirmPassVisibilty = false;
  bool isLoading = false;
  List<dynamic> citySuggestion = [];
  Map<String, dynamic>? stateMap;

  final InputBorder _border = const OutlineInputBorder(
      borderSide: BorderSide(
        color: Color(0XFF707070),
        width: 1,
      ),
      borderRadius: BorderRadius.all(
        Radius.circular(15),
      ));

  Future<void> readJsonFile(String filePath) async {
    final String response = await rootBundle.loadString(filePath);
    stateMap = jsonDecode(response);
    print(stateMap!['states'][0]);
  }

  @override
  void initState() {
    super.initState();
    readJsonFile('assets/files/jsononline-net.json');
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
          if (citySuggestion.isNotEmpty) {
            citySuggestion.clear();
            setState(() {});
          }
        },
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
                TextFormField(
                  controller: passController,
                  validator: (value) {
                    if (value == null || value == '') {
                      return 'This feild cannot be empty';
                    }
                    if (value.length < 5) {
                      return 'Password should be atleast 5 digits long';
                    }
                    return null;
                  },
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
                TextFormField(
                  controller: confirmPassController,
                  obscureText: !confirmPassVisibilty,
                  validator: (value) {
                    if (passController.text != confirmPassController.text) {
                      return 'Confirm password ans password should be same';
                    }

                    return null;
                  },
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
                TextFormField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value == '') {
                      return 'This feild cannot be empty';
                    }
                    if (int.tryParse(value) == null || value.length != 10) {
                      return 'Invalid Phone no.';
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
                TextFormField(
                  controller: materialController,
                  validator: (value) {
                    if (value == null || value == '') {
                      return 'This feild cannot be empty';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      border: _border,
                      focusedBorder: _border,
                      labelText: 'Nature of Material'),
                ),
                verticalGap(20),
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: stateController,
                                validator: (value) {
                                  if (value == null || value == '') {
                                    return 'This feild cannot be empty';
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  if (citySuggestion.isNotEmpty) {
                                    citySuggestion.clear();
                                    setState(() {});
                                  }
                                },
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                    border: _border,
                                    focusedBorder: _border,
                                    labelText: 'State'),
                              ),
                            ),
                            horizontalGap(15),
                            Expanded(
                              child: TextFormField(
                                controller: cityController,
                                validator: (value) {
                                  if (value == null || value == '') {
                                    return 'This feild cannot be empty';
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  List<dynamic> state =
                                      (stateMap!["states"] as List)
                                          .where((element) =>
                                              stateController.text
                                                  .toLowerCase()
                                                  .trim() ==
                                              element['name']
                                                  .toString()
                                                  .toLowerCase())
                                          .toList();

                                  if (state.isNotEmpty) {
                                    citySuggestion =
                                        (state[0]["cities"] as List)
                                            .where((element) => element["name"]
                                                .toString()
                                                .toLowerCase()
                                                .contains(cityController.text
                                                    .trim()
                                                    .toLowerCase()))
                                            .toList();

                                    setState(() {});
                                  }
                                },
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                    border: _border,
                                    focusedBorder: _border,
                                    labelText: 'City'),
                              ),
                            ),
                          ],
                        ),
                        verticalGap(20),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: weightController,
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
                                    labelText: 'Weight (kg)'),
                              ),
                            ),
                            horizontalGap(15),
                            Expanded(
                              child: TextFormField(
                                controller: qtyController,
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
                                    labelText: 'Quantity'),
                              ),
                            ),
                          ],
                        ),
                        verticalGap(30),
                        SizedBox(
                          height: 60,
                          width: double.infinity,
                          child: customButton('Sign Up', () async {
                            bool? validateForm =
                                formKey.currentState?.validate();
                            if (validateForm == null || !validateForm) return;
                            try {
                              setState(() {
                                isLoading = true;
                              });
                              UserCredential user = await FirebaseAuth.instance
                                  .createUserWithEmailAndPassword(
                                      email: emailController.text,
                                      password: passController.text);

                              FirebaseFirestore.instance
                                  .collection('Users')
                                  .doc(user.user!.uid)
                                  .set({
                                'accountType': 'Dealer',
                                'userName': nameController.text,
                                'phoneNo': phoneController.text,
                                'materialNature': materialController.text,
                                'weight': weightController.text,
                                'quantity': qtyController.text,
                                'state': stateController.text,
                                'city': cityController.text,
                              });

                              if (!mounted) return;

                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const  DealerDashBoard()),
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
                        verticalGap(100),
                      ],
                    ),
                    if (citySuggestion.isNotEmpty)
                      Positioned(
                        top: 65,
                        right: 0,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: ColorManager.grey),
                              borderRadius: BorderRadius.circular(15)),
                          height: 150,
                          width: (MediaQuery.of(context).size.width - 55) / 2,
                          child: RawScrollbar(
                            controller: scrollController,
                            radius: const Radius.circular(15),
                            mainAxisMargin: 6,
                            thumbColor: ColorManager.blue,
                            thickness: 4,
                            thumbVisibility: true,
                            child: ListView.separated(
                                controller: scrollController,
                                physics: const BouncingScrollPhysics(),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                separatorBuilder: (context, index) => Container(
                                      height: 1,
                                      color: ColorManager.grey.withOpacity(0.5),
                                    ),
                                itemCount: citySuggestion.length,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () {
                                      cityController.text =
                                          citySuggestion[index]["name"];
                                      citySuggestion.clear();
                                      cityController.selection =
                                          TextSelection.fromPosition(
                                              TextPosition(
                                                  offset: cityController
                                                      .text.length));
                                      setState(() {});
                                    },
                                    child: Container(
                                      color: Colors.white,
                                      alignment: Alignment.centerLeft,
                                      height: 35,
                                      child: IgnorePointer(
                                        child: Text(
                                          citySuggestion[index]["name"]
                                              .toString(),
                                          style: const TextStyle(
                                              fontSize: 14,
                                              overflow: TextOverflow.ellipsis),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                          ),
                        ),
                      )
                  ],
                ),
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
