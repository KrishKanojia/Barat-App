import 'dart:async';
import 'dart:convert';

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
  Future<LocationModel> fetchLocationArea() async {
    try {
      final response = await http.get(Uri.parse(AppUrl.locationGetAreas));
      print(response);
      if (response.statusCode == 200) {
        var data = await jsonDecode(response.body);
        print(data['data'][0]['areaName']);
        return LocationModel.fromJson(data);
      } else {
        throw Exception('Error');
      }
    } catch (e) {
      print('error fetching location : $e');
      return LocationModel.fromJson({'': ''});
    }
  }

  void postLocationByAdmin(var imageUrl, String areaname) async {
    //  ProgressDialog dialog = ProgressDialog(context: context);
    // dialog.show(max: 100, msg: "Please Wait ...");
    var areaDoc = await _db.collection("admin").doc();
    await _db.collection("admin").doc(areaDoc.id).set({
      "areaName": areaname.toLowerCase(),
      "areaImage": imageUrl,
      "id": areaDoc.id,
      "createdAt": Timestamp.now(),
      "updateAt": Timestamp.now(),
    });
    print("Area Uploaded SuccessFully");
    //  dialog.close();
  }

  var longitude = ' '.obs;
  var latitude = ' '.obs;
  var address = ' '.obs;
  late StreamSubscription<Position> streamSubscription;

  determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    streamSubscription =
        Geolocator.getPositionStream().listen((Position position) {
      latitude.value = 'Latitude : ${position.latitude}';
      longitude.value = 'Longitude : ${position.longitude}';
      getAddressFromLatLang(position);
    });
    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
  }

  Future<void> getAddressFromLatLang(Position position) async {
    List<Placemark> placemark =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark place = placemark[0];
    address.value = 'Address : ${place.locality},${place.country}';
  }

  Future<GetHallsByID> getHallApiById(var id) async {
    final response =
        await http.get(Uri.parse('http://192.168.1.104:2000/api/getHalls/$id'));
    // final response = await http.get(Uri.parse('${AppUrl.getHallsById.id}'));
    print('79  GetHallByID ${response.body}');
    if (response.statusCode == 200) {
      var data = await jsonDecode(response.body);
      return GetHallsByID.fromJson(data);
    } else {
      throw Exception('Error');
    }
  }

  Future<void> postbookHallsByUser({
    required BuildContext context,
    required String? userId,
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
    print("76 $userId");

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

    Future<HallOwnerModel> getHallOwner() async {
      final response = await http.get(Uri.parse(AppUrl.GetHallOwner));
      if (response.statusCode == 200) {
        print(response);
        var data = await jsonDecode(response.body);
        return HallOwnerModel.fromJson(data);
      } else {
        throw Exception('Error');
      }
    }
  }

  Future<void> deleteArea({
    required BuildContext context,
    required String areaId,
  }) async {
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
    print("Area Deleted SuccessFully");
  }

  Future<void> deleteHall(
      {required BuildContext context,
      required String? hallId,
      required String areaId}) async {
    await _db
        .collection('admin')
        .doc(areaId)
        .collection("halls")
        .doc(hallId)
        .delete();
    Get.back();
    print("Hall Deleted SuccessFully");
  }

  Future<void> updateAreaByAdmin(
      {required BuildContext context,
      required var areaImage,
      required String areaId,
      required String areaname}) async {
    await _db.collection("admin").doc(areaId).update({
      "areaName": areaname.toLowerCase(),
      "areaImage": areaImage,
      "updateAt": Timestamp.now(),
    });
    Get.back();
  }

  Future<void> manualBooking(
      {required BuildContext context,
      required String hallid,
      required String areaid,
      required String hallownerid,
      required DateTime date}) async {
    var bookingDoc = await _db.collection("reserved_halls").doc();
    await _db.collection("reserved_halls").doc(bookingDoc.id).set({
      "bookingId": bookingDoc.id,
      "areaid": areaid,
      "hallid": hallid,
      "hallOwnerId": hallownerid,
      "Date": date,
    });
  }
}
