import 'package:barat/screens/booking_form.dart';
import 'package:barat/services/locationservices.dart';
import 'package:barat/widgets/reusable_detail_copy_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../utils/color.dart';

class HallDetailScreen extends StatefulWidget {
  String routename;
  HallDetailScreen({required this.routename});

  @override
  _HallDetailScreenState createState() => _HallDetailScreenState();
}

class _HallDetailScreenState extends State<HallDetailScreen> {
  // List images = [
  //   'welcome-one.png',
  //   'welcome-two.png',
  //   'welcome-three.png',
  // ];
  LocationServices locationServices = LocationServices();
  List images = Get.arguments[0]['ListImage'];
  final userID = Get.arguments[1]['userId'];
  final ownerName = Get.arguments[2]['ownerName'];
  final ownerContact = Get.arguments[3]['ownerContact'];
  final ownerEmail = Get.arguments[4]['ownerEmail'];
  final hallAddress = Get.arguments[5]['hallAddress'];
  final hallCapacity = Get.arguments[6]['hallCapacity'];
  final pricePerHead = Get.arguments[7]['pricePerHead'];
  final cateringPerHead = Get.arguments[8]['cateringPerHead'];
  final hallOwnerId = Get.arguments[9]['hallOwnerId'];
  final hallid = Get.arguments[10]['hallid'];
  final areaid = Get.arguments[11]['areaid'];
  final hallname = Get.arguments[12]['hallname'];
  // final guestqty = Get.arguments[13]['guestqty'];
  // final totAmount = Get.arguments[14]['totAmount'];
  // final clientname = Get.arguments[15]['clientname'];
  // final date = Get.arguments[16]['date'];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // print(
    //     '31,$userID $ownerName $ownerContact hall id :  $hallid, area id : $areaid ');
    print("Onwer contact : $ownerContact");
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 230,
              color: Colors.black,
              child: CarouselSlider.builder(
                itemCount: images.length,
                itemBuilder:
                    (BuildContext context, int itemIndex, int pageViewIndex) =>
                        Container(
                  width: 900,
                  // margin: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage("${images[itemIndex]}"),
                          fit: BoxFit.contain)),
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 25.0.h),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                            children: List.generate(images.length, (indexDots) {
                          return Container(
                            margin: const EdgeInsets.only(left: 5),
                            height: 8,
                            width: itemIndex == indexDots ? 25 : 8,
                            decoration: BoxDecoration(
                              color: itemIndex == indexDots
                                  ? Colors.blue
                                  : Colors.blue.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          );
                        })),
                      ],
                    ),
                  ),
                ),
                options: CarouselOptions(
                  autoPlay: true,
                  enableInfiniteScroll: false,
                  // enlargeCenterPage: true,
                  viewportFraction: 1.1,
                  // aspectRatio: 2.0,
                  initialPage: 0,
                ),
              ),
            ),
            SizedBox(height: 10.h),
            Expanded(
              child: SingleChildScrollView(
                child: SizedBox(
                  child: Column(
                    children: <Widget>[
                      const Text(
                        "DETAILS",
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      ReusableDetailsCopyText(
                        text1: "Owner/Manger",
                        text2: "$ownerName",

                        // text2: "${snapshot.data!.data![0].ownerName}",
                      ),
                      ReusableDetailsCopyText(
                        text1: "Contact",
                        text2: "$ownerContact",

                        // text2: "${snapshot.data!.data![0].ownerContact}",
                      ),
                      ReusableDetailsCopyText(
                        text1: "Email",
                        text2: "$ownerEmail",

                        // text2: "${snapshot.data!.data![0].ownerEmail}",
                      ),
                      ReusableDetailsCopyText(
                        text1: "Address",
                        text2: "$hallAddress",

                        // text2: "${snapshot.data!.data![0].hallAddress}",
                      ),
                      ReusableDetailsCopyText(
                        text1: "Capacity per Hall",
                        text2: "$hallCapacity",
                        // text2: "${snapshot.data!.data![0].hallCapacity}",
                      ),
                      ReusableDetailsCopyText(
                        text1: "Rate per head",
                        text2: "$pricePerHead",
                        // text2: "${snapshot.data!.data![0].pricePerHead}",
                      ),
                      ReusableDetailsCopyText(
                        text1: "Catering Service per head",
                        // text2: "${snapshot.data!.data![0].cateringPerHead}",
                        text2: "$cateringPerHead",
                      ),
                      ReusableDetailsCopyText(
                        text1: "Event planner services",
                        text2: "Contact Owner/Manager",
                      ),
                      widget.routename == "Halls screen"
                          ? SizedBox(
                              height: 50.h,
                              width: 110.w,
                              child: ElevatedButton(
                                onPressed: () {
                                  Get.to(() => const BookingForm(), arguments: [
                                    {"userID": userID},
                                    {"pricePerHead": pricePerHead},
                                    {"cateringPerHead": cateringPerHead},
                                    {"hallOwnerId": hallOwnerId},
                                    {"hallid": hallid},
                                    {"areaid": areaid},
                                    {"images": images},
                                    {"hallname": hallname},
                                    {"ownername": ownerName},
                                    {"ownercontact": ownerContact},
                                    {"owneremail": ownerEmail},
                                    {"halladdress": hallAddress},
                                  ]);
                                },
                                child: Text(
                                  "Book Now",
                                  style: TextStyle(
                                    fontSize: 17.sp,
                                    color: whiteColor,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  shadowColor: Colors.blueGrey,
                                  primary: secondaryColor,
                                  elevation: 9,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    // <-- Radius
                                  ),
                                ),
                              ),
                            )
                          : Container(
                              width: 0.0,
                              height: 0.0,
                            ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 10.0,
                        ),
                        width: size.width,
                        child: Column(
                          children: [
                            Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.person_pin,
                                    size: 25,
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  const Text("Ali Ahmed Shah Khan Mallah",
                                      style: const TextStyle(fontSize: 15)),
                                ]),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              padding: const EdgeInsets.all(15.0),
                              width: size.width,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey,
                                  style: BorderStyle.solid,
                                  width: 0.0,
                                ),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(10.0),
                                  bottomLeft: Radius.circular(10.0),
                                ),
                              ),
                              child: Text(
                                "What is meaning of dummy text?Dummy text refers to the bits of content that are used to fill a website mock-up. This text helps web designers better envision how the website will look as a finished product. It is important to understand that dummy text has no meaning whatsoever",
                                softWrap: true,
                                style: const TextStyle(fontSize: 13),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//
// Expanded(
// child: FutureBuilder(
// future: locationServices.getHallApiById(userID),
// builder: (context, AsyncSnapshot<GetHallsByID?> snapshot) {
// if (!snapshot.hasData) {
// return SizedBox(
// child: CircularProgressIndicator(),
// );
// } else {
// return ListView.builder(
// // physics: NeverScrollableScrollPhysics(),
// shrinkWrap: true,
// itemCount: snapshot.data!.data!.length,
// itemBuilder: (BuildContext context, index) {
// return Container(
// height: 550.h,
// child: Column(children: <Widget>[
// const Text(
// "DETAILS",
// style: TextStyle(
// fontSize: 22, fontWeight: FontWeight.bold),
// ),
// ReusableDetailsCopyText(
// text1: "Owner/Manger",
// text2: "${snapshot.data!.data![index].ownerName}",
// ),
// ReusableDetailsCopyText(
// text1: "Contact",
// text2:
// "${snapshot.data!.data![index].ownerContact}",
// ),
// ReusableDetailsCopyText(
// text1: "Email",
// text2: "${snapshot.data!.data![index].ownerEmail}",
// ),
// ReusableDetailsCopyText(
// text1: "Address",
// text2: "${snapshot.data!.data![index].hallAddress}",
// ),
// ReusableDetailsCopyText(
// text1: "Capacity per Hall",
// text2:
// "${snapshot.data!.data![index].hallCapacity}",
// ),
// ReusableDetailsCopyText(
// text1: "Rate per head",
// text2:
// "${snapshot.data!.data![index].pricePerHead}",
// ),
// ReusableDetailsCopyText(
// text1: "Catering Service per head",
// text2:
// "${snapshot.data!.data![index].cateringPerHead}",
// ),
// ReusableDetailsCopyText(
// text1: "Event planner services",
// text2: "Contact Owner/Manager",
// ),
// SizedBox(
// height: 50.h,
// width: 110.w,
// child: ElevatedButton(
// onPressed: () {
// Get.to(() => BookingForm(), arguments: [
// {"userID": userID},
// {
// "pricePerHead":
// snapshot.data!.data![index].pricePerHead
// },
// {
// "cateringPerHead": snapshot
//     .data!.data![index].cateringPerHead
// },
// ]);
// },
// child: Text(
// "Book Now",
// style: TextStyle(
// fontSize: 17.sp,
// color: whiteColor,
// ),
// ),
// style: ElevatedButton.styleFrom(
// shadowColor: Colors.blueGrey,
// primary: secondaryColor,
// elevation: 9,
// shape: RoundedRectangleBorder(
// borderRadius: BorderRadius.circular(12),
// // <-- Radius
// ),
// ),
// ),
// )
// ]),
// );
// });
// }
// }),
// )
