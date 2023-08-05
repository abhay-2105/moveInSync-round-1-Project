import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../helper functions/helper_functions.dart';
import '../auth/Sign In/sign_in.dart';

class DriverDashboard extends StatelessWidget {
  const DriverDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFFF0F2F6),
      appBar: AppBar(
        backgroundColor: ColorManager.blue,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Dealer List',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const SignInScreen()),
                  (route) => route.isFirst,
                );
              },
              icon: const Icon(
                Icons.logout,
                color: Colors.white,
              ))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            verticalGap(15),
            Expanded(
                child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                    stream: FirebaseFirestore.instance
                        .collection('Users')
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: Text(
                            'Loading...',
                            style: TextStyle(fontSize: 16),
                          ),
                        );
                      }
                      if (snapshot.hasData) {
                        DocumentSnapshot<Map<String, dynamic>> data =
                            snapshot.data!;

                        List<dynamic> dealerList = data['requests'];

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Results: ${dealerList.length}',
                              style: const TextStyle(
                                  color: ColorManager.grey, fontSize: 16),
                            ),
                            verticalGap(15),
                            Expanded(
                              child: dealerList.isEmpty
                                  ? const Center(
                                      child: Text(
                                      'No Driver Found..',
                                      style: TextStyle(fontSize: 16),
                                    ))
                                  : ListView.separated(
                                      padding: EdgeInsets.zero,
                                      itemBuilder: (context, index) {
                                        final data = dealerList[index];
                                        return StreamBuilder(
                                            stream: FirebaseFirestore.instance
                                                .collection('Users')
                                                .doc(data)
                                                .snapshots(),
                                            builder: (context, snapshot1) {
                                              if (snapshot1.connectionState ==
                                                  ConnectionState.waiting) {
                                                return const SizedBox();
                                              }
                                              if (snapshot.hasData) {
                                                return DealerTicket(
                                                  data: snapshot1.data!.data()!,
                                                  docId: snapshot1.data!.id,
                                                );
                                              }
                                              return const SizedBox();
                                            });
                                      },
                                      separatorBuilder: (context, index) =>
                                          verticalGap(15),
                                      itemCount: dealerList.length),
                            )
                          ],
                        );
                      }

                      return const Center(
                        child: Text(
                          'Unable to fetch data at the moment..',
                          style: TextStyle(fontSize: 16),
                        ),
                      );
                    })),
          ],
        ),
      ),
    );
  }
}

class DealerTicket extends StatelessWidget {
  final Map<String, dynamic> data;
  final String docId;

  const DealerTicket({
    super.key,
    required this.data,
    required this.docId,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                    blurRadius: 5,
                    spreadRadius: 5,
                    color: Colors.grey.shade200,
                    offset: const Offset(0, 5))
              ]),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    data['userName'],
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  Chip(
                      label: Text(
                        '${data['weight']} kg',
                        style: const TextStyle(
                            color: ColorManager.blue,
                            fontWeight: FontWeight.w600),
                      ),
                      backgroundColor: const Color.fromARGB(255, 222, 227, 251)
                          .withOpacity(0.5),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      side: BorderSide.none),
                ],
              ),
              verticalGap(10),
              Row(
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    color: ColorManager.blue,
                  ),
                  horizontalGap(10),
                  Expanded(
                      child: Text(
                    '${data['state']}, ${data['city']}',
                    style: const TextStyle(fontSize: 16),
                  ))
                ],
              ),
              verticalGap(10),
              Row(
                children: [
                  const Icon(
                    Icons.api_outlined,
                    color: ColorManager.blue,
                  ),
                  horizontalGap(10),
                  Expanded(
                      child: Text(
                    data['materialNature'],
                    style: const TextStyle(fontSize: 16),
                  ))
                ],
              ),
              verticalGap(10),
              Row(
                children: [
                  const Icon(
                    Icons.phone,
                    color: ColorManager.blue,
                  ),
                  horizontalGap(10),
                  Expanded(
                      child: Text(
                    'Phone: ${data['phoneNo']}',
                    style: const TextStyle(fontSize: 16),
                  ))
                ],
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Material(
            color: ColorManager.orange.withOpacity(0.8),
            borderRadius: const BorderRadius.only(
              bottomRight: Radius.circular(10),
              topLeft: Radius.circular(10),
            ),
            child: InkWell(
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(10),
                topLeft: Radius.circular(10),
              ),
              onTap: () async {
                if (data['drivers']
                    .contains(FirebaseAuth.instance.currentUser!.uid)) {
                  await FirebaseFirestore.instance
                      .collection('Users')
                      .doc(docId)
                      .update({
                    'drivers': FieldValue.arrayRemove(
                        [FirebaseAuth.instance.currentUser!.uid])
                  });
                } else {
                  await FirebaseFirestore.instance
                      .collection('Users')
                      .doc(docId)
                      .update({
                    'drivers': FieldValue.arrayUnion(
                        [FirebaseAuth.instance.currentUser!.uid])
                  });
                }
              },
              child: Container(
                height: 55,
                width: 120,
                alignment: Alignment.center,
                child: Text(
                  !data['drivers']
                          .contains(FirebaseAuth.instance.currentUser!.uid)
                      ? 'Accept'
                      : 'Undo',
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
