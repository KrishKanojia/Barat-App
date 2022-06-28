import 'package:barat/widgets/reusableText.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'HomePage.dart';

class Congratulations extends StatefulWidget {
  String? date;
  Congratulations({this.date = "", Key? key}) : super(key: key);

  @override
  State<Congratulations> createState() => _CongratulationsState();
}

class _CongratulationsState extends State<Congratulations> {
  Future<bool> _willpopscope() async {
    Get.off(() => const HomePage());
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _willpopscope,
      child: Scaffold(
        body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
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
                      "Congratulations, The Hall has been succesfully Booked on date ${widget.date},"
                      " Kindly Contact the hall to confirm your booking,Thank you for using the Baraat App"),
            ),
          ),
          TextButton(
            onPressed: () => Get.off(() => const HomePage()),
            child: const Text("OK"),
          )
        ]),
      ),
    );
  }
}
