import 'package:barat/Models/hall_owner_model.dart';
import 'package:barat/screens/hall_details_screen.dart';
import 'package:barat/screens/showbookedhall.dart';
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
  final locationServices = Get.put(LocationServices());
  final credentialServices = Get.find<CredentialServices>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    LocationServices();
  }

  Widget myBookings(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 30.0),
        Flexible(
          child: Obx(() => StreamBuilder<QuerySnapshot>(
                stream: credentialServices.getisAdmin == true
                    ? FirebaseFirestore.instance
                        .collection("bookings")
                        .snapshots()
                    : FirebaseFirestore.instance
                        .collection('bookings')
                        .where('hallOwnerId',
                            isEqualTo: credentialServices.getUserId)
                        .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                        child: CircularProgressIndicator(
                      color: Colors.green,
                    ));
                  } else if (!snapshot.hasData || snapshot.data!.size == 0) {
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
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: ListView(
                          children: snapshot.data!.docs
                              .map((DocumentSnapshot docSnaps) {
                            Map<String, dynamic> data =
                                docSnaps.data()! as Map<String, dynamic>;
                            return InkWell(
                              onTap: () {
                                Get.to(() => const ShowBookedHall(),
                                    arguments: [
                                      {"ListImage": data["images"]},
                                      // {"userId": data.toString()},
                                      {"ownername": data["ownername"]},
                                      {"ownercontact": data["ownercontact"]},
                                      {"owneremail": data["owneremail"]},
                                      {"halladdress": data["halladdress"]},
                                      {
                                        "guestsQuantity": data["GuestsQuantity"]
                                      },
                                      {"clientname": data["clientname"]},
                                      {"clientemail": data["clientemail"]},
                                      {"totalPayment": data["TotalPaynment"]},

                                      {"date": data["Date"]},

                                      {"time": data["Time"]},
                                      {"hallname": data["hallname"]},
                                      {"eventplanner": data["EventPlaner"]},
                                      {
                                        "cateringServices":
                                            data["CateringServices"]
                                      },
                                      // {"areaid": areaId},
                                    ]);
                              },
                              child: Container(
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
                                      color: background1Color.withOpacity(0.23),
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
                                            backgroundColor: background1Color,
                                            child: CircleAvatar(
                                              backgroundColor: Colors.grey[100],
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
                                                    right: 8.0, bottom: 9.0),
                                                child: Icon(Icons
                                                    .arrow_forward_ios_outlined),
                                              ),
                                            ],
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ));
                  }
                },
              )),
        ),
      ],
    );
  }

  Widget myHallsBooked(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 30.0),
        Flexible(
          child: Obx(() => StreamBuilder<QuerySnapshot>(
                stream: credentialServices.getisAdmin == true
                    ? FirebaseFirestore.instance
                        .collection("bookings")
                        .snapshots()
                    : FirebaseFirestore.instance
                        .collection('bookings')
                        .where('clientid',
                            isEqualTo: credentialServices.getUserId)
                        .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                        child: CircularProgressIndicator(
                      color: Colors.green,
                    ));
                  } else if (!snapshot.hasData || snapshot.data!.size == 0) {
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
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: ListView(
                          children: snapshot.data!.docs
                              .map((DocumentSnapshot docSnaps) {
                            Map<String, dynamic> data =
                                docSnaps.data()! as Map<String, dynamic>;
                            return InkWell(
                              onTap: () {
                                Get.to(() => const ShowBookedHall(),
                                    arguments: [
                                      {"ListImage": data["images"]},
                                      // {"userId": data.toString()},
                                      {"ownername": data["ownername"]},
                                      {"ownercontact": data["ownercontact"]},
                                      {"owneremail": data["owneremail"]},
                                      {"halladdress": data["halladdress"]},
                                      {
                                        "guestsQuantity": data["GuestsQuantity"]
                                      },
                                      {"clientname": data["clientname"]},
                                      {"clientemail": data["clientemail"]},
                                      {"totalPayment": data["TotalPaynment"]},

                                      {"date": data["Date"]},

                                      {"time": data["Time"]},
                                      {"hallname": data["hallname"]},
                                      {"eventplanner": data["EventPlaner"]},
                                      {
                                        "cateringServices":
                                            data["CateringServices"]
                                      },
                                      // {"areaid": areaId},
                                    ]);
                              },
                              child: Container(
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
                                      color: background1Color.withOpacity(0.23),
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
                                            backgroundColor: background1Color,
                                            child: CircleAvatar(
                                              backgroundColor: Colors.grey[100],
                                              maxRadius: 18,
                                              child: Text(
                                                data["ownername"]
                                                    .toString()
                                                    .substring(0, 1).toUpperCase(),
                                                style: const TextStyle(
                                                  fontSize: 20,
                                                ),
                                              ),
                                            ),
                                          ),
                                          title: Text(
                                            "Owner Name: ${data["ownername"].toString().substring(0, 1).toUpperCase() + data["ownername"].toString().substring(1, data["ownername"].toString().length)}",
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
                                                    right: 8.0, bottom: 9.0),
                                                child: Icon(Icons
                                                    .arrow_forward_ios_outlined),
                                              ),
                                            ],
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ));
                  }
                },
              )),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: background1Color,
        appBar: AppBar(
          bottom: const TabBar(tabs: [
            Tab(
              text: "My Bookings",
              icon: Icon(Icons.bookmark_added),
            ),
            Tab(
              text: "My Halls Booked",
              icon: Icon(Icons.villa_sharp),
            ),
          ]),
        ),
        body: TabBarView(
          children: [
            myBookings(context),
            myHallsBooked(context),
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
      ),
    );
  }
}
