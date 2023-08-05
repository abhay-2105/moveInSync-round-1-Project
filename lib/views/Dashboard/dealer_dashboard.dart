import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ship_easy/helper%20functions/helper_functions.dart';
import 'package:ship_easy/views/auth/Sign%20In/sign_in.dart';

class DealerDashBoard extends StatefulWidget {
  const DealerDashBoard({super.key});

  @override
  State<DealerDashBoard> createState() => _DealerDashBoardState();
}

class _DealerDashBoardState extends State<DealerDashBoard> {
  dynamic dealerDetails;

  Future<void> getDealerDetails() async {
    dealerDetails = (await FirebaseFirestore.instance
            .collection('Users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get())
        .data();

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getDealerDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFFF0F2F6),
      appBar: AppBar(
        backgroundColor: ColorManager.blue,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Driver List',
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
                child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: FirebaseFirestore.instance
                        .collection('Users')
                        .where('accountType', isEqualTo: 'Driver')
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
                        List<QueryDocumentSnapshot<Map<String, dynamic>>> data =
                            snapshot.data!.docs;
                        List<QueryDocumentSnapshot<Map<String, dynamic>>>
                            filterList;

                        if (dealerDetails != null) {
                          filterList = data
                              .where((element) =>
                                  element['routes']['stateFrom1'] ==
                                      dealerDetails['state'] ||
                                  element['routes']['stateTo1'] ==
                                      dealerDetails['state'])
                              .toList();
                        } else {
                          filterList = [];
                        }

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Results: ${filterList.length}',
                              style: const TextStyle(
                                  color: ColorManager.grey, fontSize: 16),
                            ),
                            verticalGap(15),
                            Expanded(
                              child: filterList.isEmpty
                                  ? const Center(
                                      child: Text(
                                      'No Driver Found..',
                                      style: TextStyle(fontSize: 16),
                                    ))
                                  : ListView.separated(
                                      padding: EdgeInsets.zero,
                                      itemBuilder: (context, index) {
                                        final data = filterList[index];
                                        return DriverTicket(
                                          dealerDetails: dealerDetails,
                                          capacity: data['truckCapacity'],
                                          exp: data['drivingExp'],
                                          transporterName:
                                              data['transporterName'],
                                          name: data['userName'],
                                          fromState: data['routes']
                                                  ['stateFrom1'] ??
                                              '',
                                          toState:
                                              data['routes']['stateTo1'] ?? '',
                                          fromCity:
                                              data['routes']['cityFrom1'] ?? '',
                                          toCity:
                                              data['routes']['cityTo1'] ?? '',
                                          docId: data.id,
                                          requests: data['requests'],
                                        );
                                      },
                                      separatorBuilder: (context, index) =>
                                          verticalGap(15),
                                      itemCount: filterList.length),
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

class DriverTicket extends StatelessWidget {
  final dynamic dealerDetails;
  final String fromState;
  final String toState;
  final String fromCity;
  final String toCity;
  final String transporterName;
  final String exp;
  final String capacity;
  final String name;
  final String docId;
  final List requests;
  const DriverTicket({
    super.key,
    required this.transporterName,
    required this.exp,
    required this.capacity,
    required this.name,
    required this.fromState,
    required this.toState,
    required this.fromCity,
    required this.toCity,
    required this.docId,
    required this.requests,
    required this.dealerDetails,
  });

  @override
  Widget build(BuildContext context) {
    print(dealerDetails['drivers']);
    print(docId);
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
                    name,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  Chip(
                      label: Text(
                        '$capacity ton',
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
                    '$fromCity, $fromState - $toCity, $toState',
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
                    transporterName,
                    style: const TextStyle(fontSize: 16),
                  ))
                ],
              ),
              verticalGap(10),
              Row(
                children: [
                  const Icon(
                    Icons.local_shipping_outlined,
                    color: ColorManager.blue,
                  ),
                  horizontalGap(10),
                  Expanded(
                      child: Text(
                    'Experience : $exp yrs.',
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
            color: (dealerDetails['drivers'] as List).contains(docId)
                ? ColorManager.blue
                : ColorManager.orange.withOpacity(0.8),
            borderRadius: const BorderRadius.only(
              bottomRight: Radius.circular(10),
              topLeft: Radius.circular(10),
            ),
            child: InkWell(
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(10),
                topLeft: Radius.circular(10),
              ),
              onTap: (dealerDetails['drivers'] as List).contains(docId)
                  ? null
                  : () async {
                      if (requests
                          .contains(FirebaseAuth.instance.currentUser!.uid)) {
                        await FirebaseFirestore.instance
                            .collection('Users')
                            .doc(docId)
                            .update({
                          'requests': FieldValue.arrayRemove(
                              [FirebaseAuth.instance.currentUser!.uid])
                        });
                      } else {
                        await FirebaseFirestore.instance
                            .collection('Users')
                            .doc(docId)
                            .update({
                          'requests': FieldValue.arrayUnion(
                              [FirebaseAuth.instance.currentUser!.uid])
                        });
                      }
                    },
              child: Container(
                height: 55,
                width: 120,
                alignment: Alignment.center,
                child: Text(
                  (dealerDetails['drivers'] as List).contains(docId)
                      ? "Accepted"
                      : !requests
                              .contains(FirebaseAuth.instance.currentUser!.uid)
                          ? 'Request'
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
