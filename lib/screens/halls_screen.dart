import 'package:barat/services/locationservices.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
            text: areaName.toString(),
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
                              Get.to(() => const HallDetailScreen(),
                                  arguments: [
                                    {"ListImage": data["images"]},
                                    {"userId": data.toString()},
                                    {"ownerName": data["OwnerName"]},
                                    {"ownerContact": data["OwnerContact"]},
                                    {"ownerEmail": data["OwnerEmail"]},
                                    {"hallAddress": data["HallAddress"]},
                                    {"hallCapacity": data["HallCapacity"]},
                                    {"pricePerHead": data["PricePerHead"]},
                                    {
                                      "cateringPerHead": data["CateringPerHead"]
                                    },
                                    {"hallOwnerId": data["hallOwnerId"]},
                                    {"hallid": data["hall_id"]},
                                    {"areaid": areaId},
                                    {"hallname": data["hallName"]}
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
                                  Positioned(
                                    right: 0.0,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 5.0),
                                      child: PopupMenuButton(
                                        onSelected: (result) {
                                          if (result == 0) {
                                            deleteHallDialog(
                                                areaId: areaId,
                                                hallId: data["hall_id"]);
                                          } else if (result == 1) {}
                                        },
                                        itemBuilder: (BuildContext context) =>
                                            const [
                                          PopupMenuItem(
                                            value: 0,
                                            child: Text(
                                              'Delete',
                                              style: TextStyle(
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                          PopupMenuItem(
                                            value: 1,
                                            child: Text(
                                              'Edit',
                                              style: TextStyle(
                                                color: Colors.black,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Container(
                                      color: whiteColor,
                                      child: ReusableBigText(
                                        text: "${data["hallName"]}",
                                        fontSize: 21,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                        // itemCount: snapshot.data!.data!.length,
                        // gridDelegate:
                        //     SliverGridDelegateWithMaxCrossAxisExtent(
                        //         maxCrossAxisExtent: 160.h,
                        //         mainAxisExtent: 230.w,
                        //         crossAxisSpacing: 25.0.h,
                        //         mainAxisSpacing: 10.0.w,
                        //         childAspectRatio: 0.7),
                        // itemBuilder: (context, index) {
                        // hallName = snapshot.data!.data[index].;

                        // }
                      );
                    }
                  }))
        ],
      ),
    ));
  }
}
