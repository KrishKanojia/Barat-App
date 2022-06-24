import 'dart:convert';

import 'package:barat/Models/hall_model.dart';
import 'package:barat/screens/HomePage.dart';
import 'package:barat/screens/confirm_order_screen.dart';
import 'package:barat/services/credentialservices.dart';
import 'package:barat/services/locationservices.dart';
import 'package:barat/widgets/reusableBigText.dart';
import 'package:barat/widgets/reusableTextIconButton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../utils/color.dart';
import '../widgets/reusable_detail_copy_text.dart';

class PriceScreen extends StatefulWidget {
  const PriceScreen({Key? key}) : super(key: key);

  @override
  State<PriceScreen> createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  Map<String, dynamic>? paymentIntentData;
  final credentialServices = Get.put(CredentialServices());

  final areaid = Get.arguments[0]['areaid'];
  final DateTime date = Get.arguments[1]['date'];
  final time = Get.arguments[2]['time'];
  final noOfGuests = Get.arguments[3]['noOfGuests'];
  final isEventPlanner = Get.arguments[4]['isEventPlanner'];
  final event = Get.arguments[5]['event'];
  final CartService = Get.arguments[6]['CartService'];
  final isCartService = Get.arguments[7]['isCartService'];
  HallModel hallmodel = Get.arguments[8]['hallmodel'];

  final locationServices = Get.find<LocationServices>();

  var finalTotalPrice;
  String? mtoken = " ";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    totalPriceMethod();
    print(hallmodel.pricePerHead);
  }

  @override
  Widget build(BuildContext context) {
    // print(
    // "${userID} ${date}${time}${noOfGuests}${isEventPlanner}${isCartService}${totalPrice}");
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.adaptive.arrow_back_outlined),
        ),
        title: const Text("Hall Name"),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            SizedBox(height: 15.h),
            ReusableDetailsCopyText(
              text1: "Booking Date",
              text2: "${date.year}-${date.month}-${date.day}",

              // text2: "${snapshot.data!.data![0].hallAddress}",
            ),
            ReusableDetailsCopyText(
              text1: "Hall Price",
              text2: "${noOfGuests * hallmodel.pricePerHead}",

              // text2: "${snapshot.data!.data![0].hallAddress}",
            ),
            ReusableDetailsCopyText(
              text1: "Catering Price",
              text2: "${noOfGuests * CartService}",

              // text2: "${snapshot.data!.data![0].hallAddress}",
            ),
            const Divider(
              thickness: 3.0,
            ),
            ReusableDetailsCopyText(
              text1: "Total Price",
              text2: finalTotalPrice!.toString(),

              // text2: "${snapshot.data!.data![0].hallAddress}",
            ),
            SizedBox(height: 20.h),
            InkWell(
              onTap: () async {
                await MakePayment();
              },
              child: ReusableTextIconButton(
                text: "Proceed to Pay",
                margin: 15,
                color: Colors.greenAccent.withOpacity(0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }

//
  void totalPriceMethod() {
    // finalTotalPrice = noOfGuests * selectedPrice;

    final cateringprice = noOfGuests * CartService;

    final priceperheadprice = noOfGuests * hallmodel.pricePerHead;
    finalTotalPrice = cateringprice + priceperheadprice;
  }

  Future<void> MakePayment() async {
    try {
      // paymentIntentData = await createPaymentIntent('20', "USD");
      paymentIntentData =
          await createPaymentIntent(finalTotalPrice!.toString(), "USD");
      await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
              paymentIntentClientSecret: paymentIntentData!['client_secret'],
              applePay: true,
              googlePay: true,
              merchantDisplayName: 'Asif',
              merchantCountryCode: 'US'));

      displayPaymentSheet();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> sendNotification(String token) async {
    print("Getting Notification: ");
    try {
      Map<String, String> headerMap = {
        'Content-Type': 'application/json',
        'Authorization':
            'key=AAAAk_eQpps:APA91bFVXedy9ykfWOLRrd5xCQs8lIHgxFuZAvEIy3pJfVJBAFVMzSRKdn18b_BZc_yrukwuV7PwA3OrwOBnyVzcXvsWKQDU9DsXnittJx3_Psh5nqrhXZZTwIyLMA_V0-JBuT0Df0mL',
      };
      Map notificationMap = {
        'title': 'Hall Booking Confirmation',
        'body': '${credentialServices.getusername} Booked a Hall Please Check',
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
        'to': token,
      };
      var res = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: headerMap,
        body: jsonEncode(sendNotificationMap),
      );

      print("Notification to $mtoken");
    } catch (e) {
      print("The Problem is : ");

      print(e.toString());
    }
  }

  displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet(
          parameters: PresentPaymentSheetParameters(
              clientSecret: paymentIntentData!['client_secret'],
              confirmPayment: true));
      setState(() {
        paymentIntentData = null;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Paid Succesfully')));
      await locationServices.postbookHallsByUser(
        context: context,
        userId: hallmodel.userID,
        date: date,
        time: time!,
        guestsQuantity: noOfGuests,
        eventPlaner: isEventPlanner,
        cateringServices: isCartService,
        totalPayment: finalTotalPrice,
        hallOwnerId: hallmodel.hallOwnerId,
        areaId: areaid,
        hallid: hallmodel.hallid,
        images: hallmodel.images,
        hallname: hallmodel.hallname,
        ownername: hallmodel.ownerName,
        ownercontact: hallmodel.ownerContact.toString(),
        owneremail: hallmodel.ownerEmail,
        halladdress: hallmodel.hallAddress,
        event: event,
      );
      DocumentSnapshot snap = await FirebaseFirestore.instance
          .collection("usertokens")
          .doc(hallmodel.hallOwnerId)
          .get();

      String token = snap['token'];
      mtoken = token;
      sendNotification(token).whenComplete(
        () => Get.offAll(() => const HomePage()),
      );
    } on StripeException catch (e) {
      print('Exception/DISPLAYPAYMENTSHEET==> $e');
      showDialog(
          context: context,
          builder: (_) => const AlertDialog(
                content: Text("Cancelled "),
              ));
    }
  }

  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic>? body = {
        'amount': calculatePayment(amount),
        'currency': currency,
        'payment_method_types[]': 'card'
      };
      var response = await http.post(
          Uri.parse('https://api.stripe.com/v1/payment_intents'),
          body: body,
          headers: {
            'Authorization':
                'Bearer sk_test_51JcaT0LtlAjb95Nap4b7WGa2AemGJTdQKBnQDWN6dKoQ8hrXceBDxCoa99FoOxh0QmrnzcffUAiTB11xRGoCbMYT00SR1knM9a',
            'Content-Type': 'application/x-www-form-urlencoded'
          });

      return jsonDecode(response.body.toString());
    } catch (e) {
      print(e.toString());
    }
  }

  calculatePayment(String amount) {
    final price = int.parse(amount) * 100;
    return price.toString();
  }
}
