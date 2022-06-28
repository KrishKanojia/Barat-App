import 'package:barat/screens/HomePage.dart';
import 'package:barat/screens/areaForm.dart';
import 'package:barat/screens/create_hall_user.dart';
import 'package:barat/screens/hallsdetailform.dart';
import 'package:barat/screens/order_confirm_list.dart';
import 'package:barat/services/locationservices.dart';
import 'package:barat/utils/color.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:barat/services/credentialservices.dart';

import '../widgets/reusableTextIconButton.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({Key? key}) : super(key: key);

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final credentialServices = Get.put(CredentialServices());
  final locationServices = Get.put(LocationServices());

  Card makeDashboardItem(String title, IconData icon) {
    return Card(
        elevation: 5.0,
        margin: const EdgeInsets.all(8.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: background1Color,
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            verticalDirection: VerticalDirection.down,
            children: <Widget>[
              const SizedBox(height: 50.0),
              Center(
                  child: Icon(
                icon,
                size: 40.0,
                color: whiteColor,
              )),
              const SizedBox(height: 20.0),
              Center(
                child: Text(title,
                    style: const TextStyle(fontSize: 18.0, color: whiteColor)),
              )
            ],
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: background1Color,
          title: const Text("Dashboard"),
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 2.0),
          child: GridView.count(
            crossAxisCount: 2,
            padding: const EdgeInsets.all(3.0),
            children: [
              InkWell(
                onTap: () => Get.to(() => const AdminAreaForm(), arguments: [
                  {"areaid": null},
                ]),
                child: makeDashboardItem(
                    "Create Area", Icons.add_location_alt_rounded),
              ),
              InkWell(
                onTap: () => Get.to(() => const HallsDetailForm(), arguments: [
                  {"areaid": null},
                  {"hallid": null}
                ]),
                child: makeDashboardItem(
                    "Create Halls", Icons.holiday_village_outlined),
              ),
              InkWell(
                onTap: () => Get.to(() => const CreateHallUser()),
                child: makeDashboardItem("Create User", Icons.person_add),
              ),
              InkWell(
                onTap: () => Get.to(() => const OrderConfirmList()),
                child: makeDashboardItem(
                    "Show Bookings", Icons.bookmark_add_rounded),
              ),
              InkWell(
                onTap: () => Get.to(() => const HomePage()),
                child: makeDashboardItem("Home", Icons.home),
              ),
            ],
          ),
          // Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          //   LoadingButton(
          //       onClick: () {
          //         Get.to(() => const AdminAreaForm(), arguments: [
          //           {"areaid": null},
          //         ]);
          //       },
          //       color: Colors.red,
          //       childWidget: Row(
          //         mainAxisAlignment: MainAxisAlignment.center,
          //         children: const [
          //           Text('Create Area'),
          //         ],
          //       )),
          //   SizedBox(height: 10.h),
          //   LoadingButton(
          //       onClick: () {
          //         Get.to(() => const HallsDetailForm(), arguments: [
          //           {"areaid": null},
          //           {"hallid": null},
          //         ]);
          //       },
          //       color: Colors.red,
          //       childWidget: Row(
          //         mainAxisAlignment: MainAxisAlignment.center,
          //         children: const [
          //           Text('Create Halls'),
          //         ],
          //       )),
          //   SizedBox(height: 10.h),
          //   LoadingButton(
          //     onClick: () {
          //       Get.to(() => const CreateHallUser());
          //     },
          //     color: Colors.red,
          //     childWidget: Row(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: const [
          //         Text('Create Halls User'),
          //       ],
          //     ),
          //   ),
          //   SizedBox(height: 10.h),
          //   LoadingButton(
          //     onClick: () {
          //       Get.to(() => const OrderConfirmList());
          //     },
          //     color: Colors.red,
          //     childWidget: Row(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: const [
          //         Text('Show All Bookings'),
          //       ],
          //     ),
          //   ),
          //   SizedBox(height: 10.h),
          //   InkWell(
          //     onTap: () {
          //       Get.to(() => const HomePage());
          //     },
          //     child: const ReusableTextIconButton(
          //       text: 'Go To Home Page',
          //     ),
          //   )
          // ]),
        ));
  }
}
