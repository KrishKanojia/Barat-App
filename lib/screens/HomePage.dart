import 'package:barat/Models/location_model.dart';
import 'package:barat/screens/admin.dart';
import 'package:barat/screens/areaForm.dart';
import 'package:barat/screens/halls_screen.dart';
import 'package:barat/screens/loginPage.dart';
import 'package:barat/screens/order_confirm_list.dart';
import 'package:barat/services/locationservices.dart';
import 'package:barat/utils/color.dart';
import 'package:barat/widgets/reusableBigText.dart';
import 'package:barat/widgets/reusableText.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../services/credentialservices.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  static const routeName = '/home-page';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final box = GetStorage();
  final locationServices = Get.put(LocationServices());
  // final CredentialServices credentialServices = CredentialServices();
  final credentialServices = Get.put(CredentialServices());
  final getHall = FirebaseFirestore.instance.collection("admin");

  @override
  void initState() {
    super.initState();
    print("Checking curret User ${FirebaseAuth.instance.currentUser}");
    print(
        "The User Uid is ${credentialServices.userUid.value}, username : ${credentialServices.getusername}");
    LocationServices();
  }

  deleteAreaDialog({required String areaId}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            title: const Text(
              'Are you sure you want to Delete Area?',
            ),
            actions: <Widget>[
              ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.red),
                  child: const Text('Delete'),
                  onPressed: () {
                    locationServices.deleteArea(
                        context: context, areaId: areaId);
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
    final ThemeData theme = Theme.of(context);
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
        body: SafeArea(
      child: Container(
        width: width,
        height: height,
        color: background1Color,
        padding: EdgeInsets.only(
          left: width / 13,
          right: width / 13,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: height / 18),
              const ReusableBigText(
                text: "Welcome to Barat App",
                fontSize: 25,
              ),
              const ReusableText(
                text: "Book your Hall or Lawn",
                fontSize: 20,
              ),
              SizedBox(
                height: height * 0.04,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const ReusableBigText(
                    text: "Select Area",
                    fontSize: 25,
                  ),
                  // const SignOutButton(),

                  // FirebaseAuth.instance.currentUser != null
                  //     ?
                  StreamBuilder(
                    stream: FirebaseAuth.instance.authStateChanges(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.active) {
                        if (FirebaseAuth.instance.currentUser != null) {
                          return Obx(
                            () => InkWell(
                              onTap: () {},
                              child: credentialServices.getisAdmin != true
                                  ? SizedBox(
                                      width: 20.0,
                                      child: PopupMenuButton(
                                        padding: const EdgeInsets.all(0.0),
                                        onSelected: (result) {
                                          if (result == 0) {
                                            Get.to(
                                                () => const OrderConfirmList());
                                          } else if (result == 1) {
                                            credentialServices
                                                        .getisGoogleSignedIn ==
                                                    true
                                                ? credentialServices
                                                    .SignOutGoogle()
                                                : FirebaseAuth.instance
                                                    .signOut();
                                          }
                                        },
                                        itemBuilder: (BuildContext context) =>
                                            const [
                                          PopupMenuItem(
                                            value: 0,
                                            child: Text(
                                              'Bookings',
                                              style: TextStyle(
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                          PopupMenuItem(
                                            value: 1,
                                            child: Text(
                                              'Sign Out',
                                              style: TextStyle(
                                                color: Colors.black,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  : SizedBox(
                                      width: 20,
                                      child: PopupMenuButton(
                                        padding: const EdgeInsets.all(0.0),
                                        onSelected: (result) {
                                          if (result == 0) {
                                            Get.off(() => const AdminPage());
                                          } else if (result == 1) {
                                            credentialServices.LogOutViaEmail();
                                            credentialServices.isAdmin.value =
                                                false;
                                            // FirebaseAuth.instance.signOut();
                                            // Get.off(() => const LoginPage());
                                          }
                                        },
                                        itemBuilder: (BuildContext context) =>
                                            const [
                                          PopupMenuItem(
                                            value: 0,
                                            child: Text(
                                              'Dashboard',
                                              style: TextStyle(
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                          PopupMenuItem(
                                            value: 1,
                                            child: Text(
                                              'Sign Out',
                                              style: TextStyle(
                                                color: Colors.black,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                            ),
                          );
                        }
                        return SizedBox(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      const LoginPage(),
                                ),
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Icon(Icons.person_outlined),
                                SizedBox(width: 5.0),
                                Text("Sign In"),
                              ],
                            ),
                          ),
                        );
                      }
                      return SizedBox(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    const LoginPage(),
                              ),
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Icon(Icons.exit_to_app),
                              SizedBox(width: 5.0),
                              Text("Sign In"),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
              Flexible(
                  child: StreamBuilder<QuerySnapshot>(
                      stream: getHall.snapshots(),
                      // locationServices.fetchLocationArea()

                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator.adaptive());
                        }

                        if (!snapshot.hasData) {
                          return SizedBox(
                            height: MediaQuery.of(context).size.height,
                            child: const Center(
                                child: CircularProgressIndicator()),
                          );
                        } else if (!snapshot.hasData &&
                            snapshot.data!.size == 0) {
                          // Assigning total document size to document field
                          print("We have data");

                          // Provider.of<CustomerData>(context, listen: false)
                          //     .numberOfCust(context);
                          return Center(
                            child: Text(
                              'Record not found',
                              style: theme.textTheme.headline5,
                            ),
                          );
                        } else {
                          // return ListView(
                          //   shrinkWrap: true,
                          //   children: snapshot.data!.docs
                          //       .map((DocumentSnapshot documentSnapshot) {
                          //     Map<String, dynamic> data =
                          //         documentSnapshot.data()! as Map<String, dynamic>;

                          return GridView.count(
                            physics: const NeverScrollableScrollPhysics(),
                            // itemCount: snapshot.data!.docs.isEmpty ? 1 : snapshot.data!.docs.length,
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            // gridDelegate:
                            // SliverGridDelegateWithMaxCrossAxisExtent(
                            //     maxCrossAxisExtent: 160.h,
                            //     mainAxisExtent: 230.w,
                            //     crossAxisSpacing: 25.0.h,
                            //     mainAxisSpacing: 10.0.w,
                            //     childAspectRatio: 0.7),
                            crossAxisCount: 2,

                            childAspectRatio: 0.7,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 25,
                            padding: const EdgeInsets.only(
                                top: 10.0, bottom: 12.0, left: 5, right: 5),

                            children: snapshot.data!.docs
                                .map((DocumentSnapshot documentSnapshot) {
                              Map<String, dynamic> data = documentSnapshot
                                  .data()! as Map<String, dynamic>;

                              return InkWell(
                                onTap: () async {
                                  Get.to(
                                    () => const HallsScreen(),
                                    arguments: [
                                      {"id": data["id"]},
                                      {"AreaName": data["areaName"]},
                                    ],
                                  );
                                },
                                child: Container(
                                  padding: EdgeInsets.only(bottom: 15.h),
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadiusDirectional.circular(
                                              20.r),
                                      color: Colors.red,
                                      image: DecorationImage(
                                          image: NetworkImage(
                                              "${data["areaImage"]}"),
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
                                                      true
                                                  ? Positioned(
                                                      right: 0.0,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 5.0),
                                                        child: PopupMenuButton(
                                                          onSelected: (result) {
                                                            if (result == 0) {
                                                              Get.to(
                                                                  () =>
                                                                      const AdminAreaForm(),
                                                                  arguments: [
                                                                    {
                                                                      "areaid":
                                                                          data[
                                                                              "id"]
                                                                    },
                                                                  ]);
                                                            } else if (result ==
                                                                1) {
                                                              deleteAreaDialog(
                                                                  areaId: data[
                                                                      "id"]);
                                                            }
                                                          },
                                                          itemBuilder:
                                                              (BuildContext
                                                                      context) =>
                                                                  const [
                                                            PopupMenuItem(
                                                              value: 0,
                                                              child: Text(
                                                                'Edit',
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                              ),
                                                            ),
                                                            PopupMenuItem(
                                                              value: 1,
                                                              child: Text(
                                                                'Delete',
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
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
                                        },
                                      ),
                                      Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Container(
                                          color: whiteColor,
                                          child: ReusableBigText(
                                            text:
                                                "${data["areaName"].toString().substring(0, 1).toUpperCase() + data["areaName"].toString().substring(1, data["areaName"].toString().length)} ",
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          );
                        }
                      }))
            ],
          ),
        ),
      ),
    ));
  }
}
