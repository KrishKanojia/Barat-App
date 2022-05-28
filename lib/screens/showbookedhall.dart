import 'package:barat/utils/color.dart';
import 'package:barat/widgets/reusable_detail_copy_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ShowBookedHall extends StatefulWidget {
  const ShowBookedHall({Key? key}) : super(key: key);

  @override
  State<ShowBookedHall> createState() => _ShowBookedHallState();
}

class _ShowBookedHallState extends State<ShowBookedHall> {
  List images = Get.arguments[0]['ListImage'];
  final ownerName = Get.arguments[1]['ownername'];
  final ownerContact = Get.arguments[2]['ownercontact'];
  final ownerEmail = Get.arguments[3]['owneremail'];
  final hallAddress = Get.arguments[4]['halladdress'];
  final guestsQuantity = Get.arguments[5]['guestsQuantity'];
  final clientname = Get.arguments[6]['clientname'];
  final clientemail = Get.arguments[7]['clientemail'];
  final totalPayment = Get.arguments[8]['totalPayment'];
  final date = Get.arguments[9]['date'];
  final time = Get.arguments[10]['time'];
  final hallname = Get.arguments[11]['hallname'];
  final eventplanner = Get.arguments[12]['eventplanner'];
  final cateringServices = Get.arguments[13]['cateringServices'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Column(children: [
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
          child: Column(children: <Widget>[
            const Text(
              "DETAILS",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
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
              text1: "Client Name",
              text2: "$clientname",

              // text2: "${snapshot.data!.data![0].ownerEmail}",
            ),
            ReusableDetailsCopyText(
              text1: "Client Email",
              text2: "$clientemail",

              // text2: "${snapshot.data!.data![0].ownerEmail}",
            ),
            ReusableDetailsCopyText(
              text1: "Address",
              text2: "$hallAddress",

              // text2: "${snapshot.data!.data![0].hallAddress}",
            ),
            ReusableDetailsCopyText(
              text1: "Guest Quantity",
              text2: "$guestsQuantity",
              // text2: "${snapshot.data!.data![0].hallCapacity}",
            ),
            ReusableDetailsCopyText(
              text1: "Total Amount",
              text2: "$totalPayment",
              // text2: "${snapshot.data!.data![0].pricePerHead}",
            ),
            ReusableDetailsCopyText(
              text1: "Booking Date",
              // text2: "${snapshot.data!.data![0].cateringPerHead}",
              text2: "$date $time",
            ),
            ReusableDetailsCopyText(
              text1: "Event Planner",
              // text2: "${snapshot.data!.data![0].cateringPerHead}",
              text2: eventplanner == true ? "Yes" : "No",
            ),
            ReusableDetailsCopyText(
              text1: "Catering Services",
              // text2: "${snapshot.data!.data![0].cateringPerHead}",
              text2: cateringServices == true ? "Yes" : "No",
            ),
          ]),
        ),
      ),
    ])));
  }
}