import 'package:barat/screens/price_screen.dart';
import 'package:barat/utils/color.dart';
import 'package:barat/widgets/reusableBigText.dart';
import 'package:barat/widgets/reusableText.dart';
import 'package:barat/widgets/reusableTextIconButton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

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
  final ownername = Get.arguments[8]['ownername'];
  final ownercontact = Get.arguments[9]['ownercontact'];
  final owneremail = Get.arguments[10]['owneremail'];
  final halladdress = Get.arguments[11]['halladdress'];

  final TextEditingController noOfGuests = TextEditingController();

  LocationServices locationServices = LocationServices();
  String? date;
  String? time;
  bool isCartService = false;
  bool isEventPlanner = false;
  List<DateTime> dates = [];
  Set<String> unselectableDates = {}; // assuming this is set somewhere
  bool isload = false;
  DateTime? _initalDate;
  DateTime dateCheck = DateTime.now();
  Future<void> getPredictedDate() async {
    await FirebaseFirestore.instance
        .collection("bookings")
        .where("hallid", isEqualTo: hallid)
        .get()
        .then((QuerySnapshot snasphot) {
      if (snasphot.docs.isNotEmpty && snasphot.size > 0) {
        snasphot.docs.forEach((element) {
          // print("The Dates are : ${element.get("Date").toDate()}");
          dates.add(element.get("Date").toDate());
        });
      }
    });
    dates.sort();
    unselectableDates = getDateSet(dates);

    dates.forEach((date) {
      print("Date is Coming : $date");
      print("Date Check is : $date");

      if (date.day != dateCheck.day) {
        print("Selected Date : ${dateCheck.day}");
        _initalDate = dateCheck;
        return;
      } else {
        dateCheck = dateCheck.add(const Duration(days: 1));
      }
    });

    setState(() {
      isload = true;
    });
  }

  String sanitizeDateTime(DateTime dateTime) {
    return "${dateTime.year}-${dateTime.month}-${dateTime.day}";
  }

  Set<String> getDateSet(List<DateTime> dates) {
    return dates.map(sanitizeDateTime).toSet();
  }

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
    getPredictedDate();
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
                isload == true
                    ? DateTimePicker(
                        selectableDayPredicate: (DateTime val) {
                          String sanitized = sanitizeDateTime(val);
                          return !unselectableDates.contains(sanitized);
                        },
                        initialDate: dateCheck,
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
                        // initialValue: _initalDate,
                        // initialValue: _initalDate.toString(),
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
                      )
                    : const SizedBox(
                        height: 0.0,
                        width: 0.0,
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
                  onChanged: (val) => setState(() {
                    print((val));
                  }),
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
                                isCartService = true;
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
                                      : Colors.red,
                                ),
                                child: const Center(child: Text('Yes'))),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                isCartService = false;
                              });
                            },
                            child: Container(
                                height: 50.h,
                                width: 80.w,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(25),
                                      bottomRight: Radius.circular(25)),
                                  color: isCartService == true
                                      ? boolColor
                                      : Colors.red,
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
                      ? ReusableText(
                          text:
                              "Catering Service is selected for ${noOfGuests.text.isEmpty ? '0' : noOfGuests.text.toString()} person",
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
                                isEventPlanner = true;
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
                                      : Colors.red,
                                ),
                                child: const Center(child: Text('Yes'))),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                isEventPlanner = false;
                              });
                            },
                            child: Container(
                                height: 50.h,
                                width: 80.w,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(25),
                                      bottomRight: Radius.circular(25)),
                                  color: isEventPlanner == true
                                      ? boolColor
                                      : Colors.red,
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
                      DateTime dt = DateTime.parse('$date $time');

                      Get.to(() => const PriceScreen(), arguments: [
                        {"userID": userID},
                        {"date": dt},
                        {"time": time!},
                        {
                          "noOfGuests": int.parse(noOfGuests.text.toString()),
                        },
                        {"isEventPlanner": isEventPlanner},
                        {
                          "CartService":
                              isCartService == true ? cateringPerHead : 0
                        },
                        {"priceperhead": pricePerHead},
                        {"hallOwnerId": hallOwnerId},
                        {"images": images},
                        {"hallid": hallid},
                        {"areaid": areaid},
                        {"hallname": hallname},
                        {"ownername": ownername},
                        {"ownercontact": ownercontact},
                        {"owneremail": owneremail},
                        {"halladdress": halladdress},
                        {"isCartService": isCartService},
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

//   DateTime selectedDate = DateTime.now();
//   DateTime? initialData;

//   bool defineSelectable(DateTime val) {
//     DateTime now = DateTime.now();
// //make it return true on initialDate
//     if (val.compareTo(initialData!) == 0) {
//       return true;
//     }
// // disabled all days before today
//     if (val.isBefore(now)) {
//       return false;
//     }
// // disabled all days except Friday
//     switch (val.weekday) {
//       case DateTime.friday:
//         return true;
//         break;
//       default:
//         return false;
//     }
//   }

//   int daysToAdd(int todayIndex, int targetIndex) {
//     print('todayIndex $todayIndex');
//     print('targetIndex $targetIndex');
//     if (todayIndex < targetIndex) {
//       // jump to target day in same week
//       return targetIndex - todayIndex;
//     } else if (todayIndex > targetIndex) {
//       // must jump to next week
//       return 7 + targetIndex - todayIndex;
//     } else {
//       return 0; // date is matched
//     }
//   }

//   DateTime defineInitialDate() {
//     DateTime now = DateTime.now();
//     int dayOffset = daysToAdd(now.weekday, DateTime.friday);
//     print('dayOffset: $dayOffset');
//     return now.add(Duration(days: dayOffset));
//   }

//   Future<Null> _selectDate(BuildContext context) async {
//     initialData = defineInitialDate();
//     print('defineInitialDate: ${initialData}');
//     print('defineSelectable: $defineSelectable');
//     final DateTime? picked = await showDatePicker(
//         context: context,
//         initialDate: initialData,
//         selectableDayPredicate: defineSelectable,
//         firstDate: DateTime(2018, 12),
//         lastDate: DateTime(2020, 12));
//     if (picked != null && picked != selectedDate) selectedDate = picked;
// //var formatter = DateFormat('EEEE, dd-MMMM-yyyy');
// //String formatted = formatter.format(selectedDate);
//     print('Select Date: $selectedDate');
// //_askGiveProvider.meetingSink(formatted);
// //addEventBloc.eventDateSink(formatted);
//   }
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
}
