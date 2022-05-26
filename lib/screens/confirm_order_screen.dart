import 'dart:convert';

import 'package:barat/screens/HomePage.dart';
import 'package:barat/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../widgets/reusableText.dart';

class ConfirmOrderScreen extends StatefulWidget {
  const ConfirmOrderScreen({Key? key}) : super(key: key);
  static const routeName = '/confirm-order-screen';
  @override
  State<ConfirmOrderScreen> createState() => _ConfirmOrderScreenState();
}

class _ConfirmOrderScreenState extends State<ConfirmOrderScreen> {
  sendNotificationToAdmin() async {
    try {
      Map<String, String> headerMap = {
        'Content-Type': 'application/json',
        'Authorization':
            'key=AAAAk_eQpps:APA91bFVXedy9ykfWOLRrd5xCQs8lIHgxFuZAvEIy3pJfVJBAFVMzSRKdn18b_BZc_yrukwuV7PwA3OrwOBnyVzcXvsWKQDU9DsXnittJx3_Psh5nqrhXZZTwIyLMA_V0-JBuT0Df0mL',
      };
      Map notificationMap = {
        'title': 'Hall Booking Confirmation',
        'body': 'username Book a Hall Please Check',
      };
      Map dataMap = {
        'click-action': 'FLUTTER_NOTIFICATION_CLICK',
        'id': '1',
        'status': 'done',
      };
      Map sendNotificationMap = {
        'notification': notificationMap,
        'data': dataMap,
        'priority': 'high',
        'to': '/topics/Admin',
      };
      var res = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: headerMap,
        body: jsonEncode(sendNotificationMap),
      );
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    sendNotificationToAdmin();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          SizedBox(height: 100.h),
          Center(
            child: SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 120.h,
                    width: 140.w,
                    decoration: BoxDecoration(
                      border: Border.all(width: 5, color: Colors.greenAccent),
                      borderRadius: BorderRadius.circular(150),
                    ),
                    child: const Center(
                        child: Icon(
                      Icons.check,
                      size: 100,
                      color: Colors.greenAccent,
                    )),
                  ),
                  SizedBox(height: 40.h),
                  Center(
                    child: SizedBox(
                      width: 320.w,
                      child: ReusableText(
                          fontSize: 15,
                          text:
                              "Congratulations, The Hall has been succesfully Booked on date ${DateTime.now().toString()},"
                              " Kindly Contact the hall to confirm your booking,Thank you for using the Baraat App"),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Enter yout feedback'),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  _ratting(),
                  SizedBox(height: 20.h),
                  InkWell(
                      onTap: () {},
                      child: IconButton(
                        onPressed: () {
                          Get.off(() => const HomePage());
                        },
                        icon: const Icon(
                          Icons.home,
                          size: 40,
                          color: secondaryColor,
                        ),
                      ))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  double starRattingValue = 0;
  Widget _ratting() {
    return Center(
      child: RatingStars(
        value: starRattingValue,
        onValueChanged: (v) {
          starRattingValue = v;
          setState(() {});
        },
        starBuilder: (index, color) => Icon(
          Icons.star,
          size: 45,
          color: color,
        ),
        starCount: 5,
        starSize: 60,
        maxValue: 5,
        starSpacing: 5,
        maxValueVisibility: false,
        valueLabelVisibility: false,
        animationDuration: const Duration(milliseconds: 300),
        starOffColor: Colors.black.withOpacity(0.6),
        starColor: Colors.yellow,
      ),
    );
  }
}
