import 'package:barat/Models/hall_model.dart';
import 'package:barat/screens/hallsdetailform.dart';
import 'package:barat/screens/manual_booking.dart';
import 'package:barat/services/credentialservices.dart';
import 'package:barat/services/locationservices.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../Models/get_halls_by_i_d.dart';
import '../utils/color.dart';
import '../widgets/reusableBigText.dart';
import '../widgets/reusableText.dart';
import 'hall_details_screen.dart';

class HallsScreen extends StatefulWidget {
  const HallsScreen({Key? key}) : super(key: key);

  @override
  _HallsScreenState createState() => _HallsScreenState();
}

class _HallsScreenState extends State<HallsScreen> {
  String? hallName;
  final locationServices = Get.find<LocationServices>();
  final credentialServices = Get.find<CredentialServices>();

  var areaId = Get.arguments[0]['id'];
  String? areaName = Get.arguments[1]['AreaName'];
  var areaid;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    areaid = FirebaseFirestore.instance
        .collection("admin")
        .doc(areaId)
        .collection("halls");
    print('20 ${areaName.toString()}');
    print('21 ${areaId.toString()}');
    LocationServices();
    // locationServices.getHallApiById(data);
  }

  deleteHallDialog({required String areaId, required String hallId}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            title: const Text(
              'Are you sure you want to Delete Hall?',
            ),
            actions: <Widget>[
              ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.red),
                  child: const Text('Delete'),
                  onPressed: () {
                    locationServices.deleteHall(
                        context: context, areaId: areaId, hallId: hallId);
                  }),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.blue[700]),
                  child: const Text('Cancel'),
                  onPressed: () => Get.back()),
            ]);
      },
    );
  }

  PopupMenuItem<int> _buildMenuItem(String option, int value) {
    return PopupMenuItem<int>(
      value: value,
      child: Text(option),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
        body: Container(
      width: width,
      color: background1Color,
      padding:
          EdgeInsets.symmetric(horizontal: width / 13, vertical: height / 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ReusableBigText(
            text: areaName.toString().substring(0, 1).toUpperCase() +
                areaName.toString().substring(1, areaName.toString().length),
            fontSize: 25,
          ),
          const ReusableText(
            text: "Select Your Lawn Or Hall",
            fontSize: 20,
          ),
          SizedBox(
            height: height * 0.01,
          ),
          Expanded(
              child: StreamBuilder<QuerySnapshot>(
                  stream: areaid.snapshots(),
                  // locationServices.getHallApiById(data),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                          child: CircularProgressIndicator(
                        color: Colors.green,
                      ));
                    } else if (!snapshot.hasData || snapshot.data!.size == 0) {
                      return const Center(
                        child: Text(
                          "No Hall Found",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                      );
                    } else {
                      return GridView.count(
                        physics: const NeverScrollableScrollPhysics(),
                        // itemCount: snapshot.data!.docs.isEmpty ? 1 : snapshot.data!.docs.length,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        crossAxisCount: 2,

                        childAspectRatio: 0.7,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 25,
                        padding: const EdgeInsets.only(
                            top: 10.0, bottom: 12.0, left: 5, right: 5),

                        children: snapshot.data!.docs
                            .map((DocumentSnapshot documentSnapshot) {
                          Map<String, dynamic> data =
                              documentSnapshot.data()! as Map<String, dynamic>;
                          return InkWell(
                              onTap: () {
                                HallModel hallModel = HallModel.fromMap(data);
                                Get.to(
                                    () => HallDetailScreen(
                                        routename: "Halls screen"),
                                    arguments: [
                                      {"hallmodel": hallModel},
                                      {"areaid": areaId},
                                    ]);
                              },
                              child: Container(
                                padding: EdgeInsets.only(bottom: 15.h),
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadiusDirectional.circular(20.r),
                                    color: Colors.red,
                                    image: DecorationImage(
                                        image: NetworkImage(data["images"][0]),
                                        fit: BoxFit.cover)),
                                child: Stack(
                                  children: [
                                    StreamBuilder(
                                        stream: FirebaseAuth.instance
                                            .authStateChanges(),
                                        builder: (context, snapshot) {
                                          print(
                                              "Check isAdmin ${credentialServices.getisAdmin} ");
                                          if (snapshot.connectionState ==
                                              ConnectionState.active) {
                                            if (FirebaseAuth
                                                    .instance.currentUser !=
                                                null) {
                                              return credentialServices
                                                              .getisAdmin ==
                                                          true ||
                                                      credentialServices
                                                              .getUserId ==
                                                          data["hallOwnerId"]
                                                  ? Positioned(
                                                      right: 0.0,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 5.0),
                                                        child: PopupMenuButton(
                                                            onSelected:
                                                                (result) {
                                                          if (result == 0) {
                                                            Get.to(
                                                                () =>
                                                                    const HallsDetailForm(),
                                                                arguments: [
                                                                  {
                                                                    "areaid":
                                                                        areaId
                                                                  },
                                                                  {
                                                                    "hallid": data[
                                                                        "hall_id"]
                                                                  },
                                                                ]);
                                                          } else if (result ==
                                                              1) {
                                                            deleteHallDialog(
                                                                areaId: areaId,
                                                                hallId: data[
                                                                    "hall_id"]);
                                                          } else if (result ==
                                                              2) {
                                                            Get.to(
                                                                () =>
                                                                    const ManaulBooking(),
                                                                arguments: [
                                                                  {
                                                                    "hallid": data[
                                                                        "hall_id"]
                                                                  },
                                                                  {
                                                                    "areaid":
                                                                        areaId,
                                                                  },
                                                                  {
                                                                    "hallownerid":
                                                                        data[
                                                                            "hallOwnerId"],
                                                                  }
                                                                ]);
                                                            print(
                                                                "We are in this section");
                                                          }
                                                        }, itemBuilder:
                                                                (BuildContext
                                                                    context) {
                                                          print(
                                                              "The Value of Hall Owner is ${data["hallOwnerId"]} && ${credentialServices.getUserId}");
                                                          return credentialServices
                                                                      .getUserId ==
                                                                  data[
                                                                      "hallOwnerId"]
                                                              ? <
                                                                  PopupMenuItem<
                                                                      int>>[
                                                                  _buildMenuItem(
                                                                      "Edit",
                                                                      0),
                                                                  _buildMenuItem(
                                                                      "Delete",
                                                                      1),
                                                                  _buildMenuItem(
                                                                      "Manual Booking",
                                                                      2),
                                                                ]
                                                              : <
                                                                  PopupMenuItem<
                                                                      int>>[
                                                                  _buildMenuItem(
                                                                      "Edit",
                                                                      0),
                                                                  _buildMenuItem(
                                                                      "Delete",
                                                                      1),
                                                                ];
                                                        }),
                                                      ),
                                                    )
                                                  : const SizedBox(
                                                      width: 0.0,
                                                      height: 0.0,
                                                    );
                                            }
                                            return const SizedBox(
                                              width: 0.0,
                                              height: 0.0,
                                            );
                                          }
                                          return const SizedBox(
                                            width: 0.0,
                                            height: 0.0,
                                          );
                                        }),
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Container(
                                        color: whiteColor,
                                        child: ReusableBigText(
                                          text: data["hallName"]
                                                  .toString()
                                                  .substring(0, 1)
                                                  .toUpperCase() +
                                              data["hallName"]
                                                  .toString()
                                                  .substring(
                                                      1,
                                                      data["hallName"]
                                                          .toString()
                                                          .length),
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ));
                        }).toList(),
                      );
                    }
                  }))
        ],
      ),
    ));
  }
}
