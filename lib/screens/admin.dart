import 'package:barat/screens/HomePage.dart';
import 'package:barat/screens/areaForm.dart';
import 'package:barat/screens/create_hall_user.dart';
import 'package:barat/screens/hallsdetailform.dart';
import 'package:barat/screens/order_confirm_list.dart';
import 'package:barat/services/locationservices.dart';
import 'package:barat/widgets/loading_button.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        LoadingButton(
            onClick: () {
              Get.to(() => const AdminAreaForm());
            },
            color: Colors.red,
            childWidget: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text('Create Area'),
              ],
            )),
        SizedBox(height: 10.h),
        LoadingButton(
            onClick: () {
              Get.to(() => const HallsDetailForm());
            },
            color: Colors.red,
            childWidget: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text('Create Halls'),
              ],
            )),
        SizedBox(height: 10.h),
        LoadingButton(
          onClick: () {
            Get.to(() => const CreateHallUser());
          },
          color: Colors.red,
          childWidget: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text('Create Halls User'),
            ],
          ),
        ),
        SizedBox(height: 10.h),
        LoadingButton(
          onClick: () {
            Get.to(() => const OrderConfirmList());
          },
          color: Colors.red,
          childWidget: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text('Show All Bookings'),
            ],
          ),
        ),
        SizedBox(height: 10.h),
        InkWell(
          onTap: () {
            Get.to(() => const HomePage());
          },
          child: const ReusableTextIconButton(
            text: 'Go To Home Page',
          ),
        )
      ]),
    ));
  }
}
