import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:barat/Models/get_halls_by_i_d.dart';
import 'package:barat/Models/hall_owner_model.dart';
import 'package:barat/Models/location_model.dart';
import 'package:barat/services/credentialservices.dart';
import 'package:barat/services/utilities/app_url.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import 'package:http/http.dart' as http;
import 'package:location/location.dart';

class LocationServices extends GetxController {
  var _db = FirebaseFirestore.instance;

  void postAreaByAdmin(
      var imageUrl, String areaname, BuildContext context) async {
    //  ProgressDialog dialog = ProgressDialog(context: context);
    // dialog.show(max: 100, msg: "Please Wait ...");
    try {
      var areaDoc = await _db.collection("admin").doc();
      await _db.collection("admin").doc(areaDoc.id).set({
        "areaName": areaname.toLowerCase(),
        "areaImage": imageUrl,
        "id": areaDoc.id,
        "createdAt": Timestamp.now(),
        "updateAt": Timestamp.now(),
      });
      print("Area Uploaded SuccessFully");
    } on SocketException catch (e) {
      print("The error is ${e.toString()}");
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        duration: Duration(seconds: 3),
        content: Text(
          "No Internet Connection",
        ),
      ));
    } catch (e) {
      print("The Problem is : ${e.toString()}");
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        duration: Duration(seconds: 3),
        content: Text(
          "Something went Wrong Try Again later",
        ),
      ));
    }
    //  dialog.close();
  }

  var longitude = ' '.obs;
  var latitude = ' '.obs;
  var address = ' '.obs;
  late StreamSubscription<Position> streamSubscription;

  Future<void> postbookHallsByUser({
    required BuildContext context,
    required dynamic date,
    required String? time,
    required int guestsQuantity,
    required bool eventPlaner,
    required bool cateringServices,
    required int totalPayment,
    required String? hallOwnerId,
    required List? images,
    required String? hallid,
    required String? areaId,
    required String? ownername,
    required String? ownercontact,
    required String? owneremail,
    required String? halladdress,
    required String? hallname,
    required String? event,
  }) async {
    final credentialServices = Get.find<CredentialServices>();
    print(
        "In postbookHallsByUser  ${credentialServices.userUid.value}, username : ${credentialServices.getusername}");

    var bookingDoc = await _db.collection("bookings").doc();

    await _db.collection("bookings").doc(bookingDoc.id).set({
      "bookingId": bookingDoc.id,
      // "userId": userId,
      "Date": date,
      "Time": time,
      "GuestsQuantity": guestsQuantity,
      "EventPlaner": eventPlaner,
      "CateringServices": cateringServices,
      "TotalPaynment": totalPayment,
      "hallOwnerId": hallOwnerId,
      "bookingtime": Timestamp.now(),
      "hallid": hallid,
      "areaid": areaId,
      "images": images,
      "clientid": credentialServices.getUserId,
      "clientname": credentialServices.getusername.toLowerCase(),
      "clientemail": credentialServices.getuseremail.toLowerCase(),
      "hallname": hallname!.toLowerCase(),
      "ownername": ownername!.toLowerCase(),
      "ownercontact": ownercontact,
      "owneremail": owneremail!.toLowerCase(),
      "halladdress": halladdress,
      "feedback": "",
      "rating": 0.0,
      "event": event,
    });
    print("Area Uploaded SuccessFully");
  }

  Future<void> deleteArea({
    required BuildContext context,
    required String areaId,
  }) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    try {
      await _db
          .collection('admin')
          .doc(areaId)
          .collection("halls")
          .get()
          .then((querySnapshot) {
        for (DocumentSnapshot documentSnapshot in querySnapshot.docs) {
          documentSnapshot.reference.delete();
        }
      });
      await _db.collection('admin').doc(areaId).delete();
      Get.back();
      Get.back();
      print("Area Deleted SuccessFully");
    } on SocketException catch (e) {
      Get.back();
      Get.back();
      print("The error is ${e.toString()}");
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        duration: Duration(seconds: 3),
        content: Text(
          "No Internet Connection",
        ),
      ));
    } catch (e) {
      Get.back();
      Get.back();
      print("The Problem is : ${e.toString()}");
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        duration: Duration(seconds: 3),
        content: Text(
          "Something went Wrong Try Again later",
        ),
      ));
    }
  }

  Future<void> deleteHall(
      {required BuildContext context,
      required String? hallId,
      required String areaId}) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    try {
      await _db
          .collection('admin')
          .doc(areaId)
          .collection("halls")
          .doc(hallId)
          .delete();
      Get.back();
      Get.back();
      print("Hall Deleted SuccessFully");
    } on SocketException catch (e) {
      Get.back();
      Get.back();
      print("The error is ${e.toString()}");
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        duration: Duration(seconds: 3),
        content: Text(
          "No Internet Connection",
        ),
      ));
    } catch (e) {
      Get.back();
      Get.back();
      print("The Problem is : ${e.toString()}");
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        duration: Duration(seconds: 3),
        content: Text(
          "Something went Wrong Try Again later",
        ),
      ));
    }
  }

  Future<void> updateAreaByAdmin(
      {required BuildContext context,
      required var areaImage,
      required String areaId,
      required String areaname}) async {
    try {
      await _db.collection("admin").doc(areaId).update({
        "areaName": areaname.toLowerCase(),
        "areaImage": areaImage,
        "updateAt": Timestamp.now(),
      });
      Get.back();
    } on SocketException catch (e) {
      Get.back();
      print("The error is ${e.toString()}");
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        duration: Duration(seconds: 3),
        content: Text(
          "No Internet Connection",
        ),
      ));
    } catch (e) {
      Get.back();
      print("The Problem is : ${e.toString()}");
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        duration: Duration(seconds: 3),
        content: Text(
          "Something went Wrong Try Again later",
        ),
      ));
    }
  }

  Future<void> manualBooking(
      {required BuildContext context,
      required String hallid,
      required String areaid,
      required String hallownerid,
      required DateTime date}) async {
    try {
      var bookingDoc = await _db.collection("reserved_halls").doc();
      await _db.collection("reserved_halls").doc(bookingDoc.id).set({
        "bookingId": bookingDoc.id,
        "areaid": areaid,
        "hallid": hallid,
        "hallOwnerId": hallownerid,
        "Date": date,
      });
    } on SocketException catch (e) {
      print("The error is ${e.toString()}");
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        duration: Duration(seconds: 3),
        content: Text(
          "No Internet Connection",
        ),
      ));
    } catch (e) {
      print("The Problem is : ${e.toString()}");
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        duration: Duration(seconds: 3),
        content: Text(
          "Something went Wrong Try Again later",
        ),
      ));
    }
  }
}
