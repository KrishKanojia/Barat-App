import 'package:barat/Models/hall_owner_model.dart';
import 'package:barat/services/credentialservices.dart';
import 'package:barat/services/locationservices.dart';
import 'package:barat/utils/color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderConfirmList extends StatefulWidget {
  const OrderConfirmList({Key? key}) : super(key: key);

  @override
  State<OrderConfirmList> createState() => _OrderConfirmListState();
}

class _OrderConfirmListState extends State<OrderConfirmList> {
  final locationServices = Get.find<LocationServices>();
  final credentialServices = Get.find<CredentialServices>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    LocationServices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background1Color,
      body: Column(
        children: [
          const SizedBox(height: 30.0),
          Flexible(
            child: Obx(
              () => credentialServices.getisAdmin == true
                  ? StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("bookings")
                          .snapshots(),
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator(
                            color: Colors.green,
                          ));
                        } else if (!snapshot.hasData ||
                            snapshot.data!.size == 0) {
                          return const Center(
                            child: Text(
                              "No Booking Done",
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                          );
                        } else {
                          return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: ListView(
                                children: snapshot.data!.docs
                                    .map((DocumentSnapshot docSnaps) {
                                  Map<String, dynamic> data =
                                      docSnaps.data()! as Map<String, dynamic>;
                                  return Container(
                                    height: 65,
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 10),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      // color: Colors.green,
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          offset: const Offset(0, 10),
                                          blurRadius: 50,
                                          color: background1Color
                                              .withOpacity(0.23),
                                        ),
                                      ],
                                    ),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Wrap(
                                        children: [
                                          ListTile(
                                              dense: true,
                                              isThreeLine: true,
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 5.0,
                                                vertical: 0.0,
                                              ),
                                              leading: CircleAvatar(
                                                maxRadius: 19,
                                                backgroundColor:
                                                    background1Color,
                                                child: CircleAvatar(
                                                  backgroundColor:
                                                      Colors.grey[100],
                                                  maxRadius: 18,
                                                  child: Text(
                                                    data["clientname"]
                                                        .toString()
                                                        .substring(0, 1),
                                                    style: const TextStyle(
                                                      fontSize: 20,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              title: Text(
                                                "Client Name: ${data["clientname"]}",
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 13,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              subtitle: Text(
                                                "Hall Name : ${data["hallname"]}\nDate : ${data["Date"]} ${data["Time"]}",
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              trailing: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: const [
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        right: 8.0,
                                                        bottom: 9.0),
                                                    child: Icon(Icons
                                                        .arrow_forward_ios_outlined),
                                                  ),
                                                ],
                                              )),
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ));
                        }
                      },
                    )
                  : Center(child: Text("Not Admin")),
            ),
          ),
        ],
      ),
      // body:
      // Center(
      //   child: FutureBuilder(
      //     future: locationServices.getHallOwner(),
      //     builder: (context, AsyncSnapshot<HallOwnerModel?> snapshot) {
      //       if (snapshot.hasData != null) {
      //         return ListView.builder(
      //             itemCount: snapshot.data?.data?.length,
      //             itemBuilder: (context, index) {
      //               return ListTile(
      //                   leading: const Icon(Icons.list),
      //                   trailing: Text(
      //                     "${snapshot.data?.data?[index].userEmail}",
      //                     style: const TextStyle(
      //                         color: Colors.green, fontSize: 15),
      //                   ),
      //                   title: Text("List item $index"));
      //             });
      //       } else {
      //         return const Center(
      //           child: CircularProgressIndicator(),
      //         );
      //       }
      //     },
      //   ),
      // ),
    );
  }
}
