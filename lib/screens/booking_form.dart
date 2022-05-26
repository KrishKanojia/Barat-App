import 'package:barat/screens/price_screen.dart';
import 'package:barat/utils/color.dart';
import 'package:barat/widgets/reusableBigText.dart';
import 'package:barat/widgets/reusableText.dart';
import 'package:barat/widgets/reusableTextIconButton.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../services/locationservices.dart';

class BookingForm extends StatefulWidget {
  const BookingForm({Key? key}) : super(key: key);

  @override
  _BookingFormState createState() => _BookingFormState();
}

class _BookingFormState extends State<BookingForm> {
  final userID = Get.arguments[0]['userID'];
  final pricePerHead = Get.arguments[1]['pricePerHead'];
  final cateringPerHead = Get.arguments[2]['cateringPerHead'];
  final hallOwnerId = Get.arguments[3]['hallOwnerId'];
  final hallid = Get.arguments[4]['hallid'];
  final areaid = Get.arguments[5]['areaid'];
  final images = Get.arguments[6]['images'];
  final hallname = Get.arguments[7]['hallname'];

  final TextEditingController noOfGuests = TextEditingController();

  LocationServices locationServices = LocationServices();
  String? date;
  String? time;
  bool isCartService = false;
  bool isEventPlanner = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    noOfGuests.text = "";
    print("41 $userID");
    print("42 $pricePerHead");
    print("43 $cateringPerHead");
    print("44 $hallid");
    print("45 $areaid");
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    noOfGuests.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: 600.h,
            padding: EdgeInsets.only(top: 25.0.h, left: 10.0.w, right: 10.0.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: ReusableBigText(
                    text: "Booking Form",
                    fontSize: 40,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                SizedBox(height: 10.h),
                DateTimePicker(
                  decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          style: BorderStyle.solid,
                          color: Colors.black,
                          width: 2.0),
                    ),
                    border: OutlineInputBorder(),
                    labelText: 'Date',
                  ),
                  type: DateTimePickerType.date,
                  //dateMask: 'yyyy/MM/dd',
                  // controller: _controller3,
                  //initialValue: _initialValue,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                  icon: const Icon(Icons.event),
                  dateLabelText: 'Date',
                  onChanged: (val) => setState(() {
                    print(date);
                    date = val;
                  }),
                  validator: (val) {
                    setState(() => date = val ?? '');
                    return null;
                  },
                  onSaved: (val) => setState(() => date = val ?? ''),
                ),
                SizedBox(height: 10.h),
                DateTimePicker(
                  decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          style: BorderStyle.solid,
                          color: Colors.black,
                          width: 2.0),
                    ),
                    border: OutlineInputBorder(),
                    labelText: 'Time',
                  ),
                  type: DateTimePickerType.time,
                  //timePickerEntryModeInput: true,
                  //controller: _controller4,
                  initialValue: '', //_initialValue,
                  icon: const Icon(Icons.access_time),
                  timeLabelText: "Time",
                  // use24HourFormat: false,
                  onChanged: (val) => setState(() {
                    print(time);
                    time = val;
                  }),
                  validator: (val) {
                    setState(() => time = val ?? '');
                    return null;
                  },
                  onSaved: (val) => setState(() => time = val ?? ''),
                ),
                SizedBox(height: 10.h),
                TextField(
                  controller: noOfGuests,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    focusColor: Colors.black,
                    fillColor: Colors.black,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          style: BorderStyle.solid,
                          color: Colors.black,
                          width: 2.0),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                          style: BorderStyle.solid,
                          color: Colors.white,
                          width: 2.0),
                    ),
                    labelText: 'No of Guests',
                  ),
                ),
                SizedBox(height: 10.h),
                SizedBox(
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ReusableBigText(
                        text: 'Catering Service',
                        fontSize: 18,
                        color: Colors.black.withOpacity(0.8),
                      ),
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                isCartService = !isCartService;
                              });
                            },
                            child: Container(
                                height: 50.h,
                                width: 80.w,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(25),
                                      bottomLeft: Radius.circular(25)),
                                  color: isCartService == true
                                      ? boolColor
                                      : Colors.grey,
                                ),
                                child: const Center(child: Text('Yes'))),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                isCartService = !isCartService;
                              });
                            },
                            child: Container(
                                height: 50.h,
                                width: 80.w,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(25),
                                      bottomRight: Radius.circular(25)),
                                  color: isCartService == false
                                      ? boolColor
                                      : Colors.grey,
                                ),
                                child: const Center(child: Text('No'))),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8.h),
                Center(
                  child: isCartService == true
                      ? const ReusableText(
                          text: "Catering Service is selected for 350 person",
                          fontSize: 12,
                        )
                      : const Text(''),
                ),
                SizedBox(height: 10.h),
                SizedBox(
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ReusableBigText(
                        text: 'Event Planner Service',
                        fontSize: 18,
                        color: Colors.black.withOpacity(0.8),
                      ),
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                isEventPlanner = !isEventPlanner;
                              });
                            },
                            child: Container(
                                height: 50.h,
                                width: 80.w,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(25),
                                      bottomLeft: Radius.circular(25)),
                                  color: isEventPlanner == true
                                      ? boolColor
                                      : Colors.grey,
                                ),
                                child: const Center(child: Text('Yes'))),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                isEventPlanner = !isEventPlanner;
                              });
                            },
                            child: Container(
                                height: 50.h,
                                width: 80.w,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(25),
                                      bottomRight: Radius.circular(25)),
                                  color: isEventPlanner == false
                                      ? boolColor
                                      : Colors.grey,
                                ),
                                child: const Center(child: Text('No'))),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8.h),
                Center(
                  child: isEventPlanner == true
                      ? const ReusableText(
                          text: "Contact the owner/manager of the hall",
                          fontSize: 12,
                        )
                      : const Text(''),
                ),
                SizedBox(height: 20.h),
                InkWell(
                  onTap: () {
                    if (date == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Enter Date"),
                          duration: Duration(seconds: 3),
                        ),
                      );
                    } else if (time == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Enter Time"),
                          duration: Duration(seconds: 3),
                        ),
                      );
                    } else if (noOfGuests.text.isEmpty ||
                        int.parse(noOfGuests.text.toString()) <= 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Enter No of Guests"),
                          duration: Duration(seconds: 3),
                        ),
                      );
                    } else {
                      Get.to(() => const PriceScreen(), arguments: [
                        {"userID": userID},
                        {"date": date!},
                        {"time": time!},
                        {
                          "noOfGuests": int.parse(noOfGuests.text.toString()),
                        },
                        {"isEventPlanner": isEventPlanner},
                        {"isCartService": isCartService},
                        {
                          "selectedPrice":
                              isCartService ? cateringPerHead : pricePerHead
                        },
                        {"hallOwnerId": hallOwnerId},
                        {"images": images},
                        {"hallid": hallid},
                        {"areaid": areaid},
                        {"hallname": hallname},
                      ]);
                    }
                  },
                  child: const ReusableTextIconButton(
                    text: "Show Expenses",
                    margin: 10,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
//
// if (date.toString().isEmpty || time.toString().isEmpty) {
// } else if (date.toString().isEmpty) {
// Get.snackbar(date.toString(), "Please filled up date ");
// } else if (time.toString().isEmpty) {
// Get.snackbar(time.toString(), "Please filled up time ");
// } else if (noOfGuests.text == null) {
// Get.snackbar(
// noOfGuests.text, "Please filled up noOfGuests ");
// }
// }
