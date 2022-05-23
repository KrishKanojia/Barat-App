import 'dart:async';
import 'dart:convert';

import 'package:barat/Models/get_halls_by_i_d.dart';
import 'package:barat/Models/hall_owner_model.dart';
import 'package:barat/Models/location_model.dart';
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
    var areaDoc = await FirebaseFirestore.instance.collection("admin").doc();
    await FirebaseFirestore.instance.collection("admin").doc(areaDoc.id).set({
      "areaName": areaname,
      "areaImage": imageUrl,
      "id": areaDoc.id,
      "createdAt": Timestamp.now(),
      "updateAt": Timestamp.now(),
    });
    print("Area Uploaded SuccessFully");
    //  dialog.close();
  }

  // void postLocationByAdmin(var imageUrl, String areaName) async {
  //   var headers = {'Content-Type': 'application/json'};
  //   var request = http.Request('POST', Uri.parse(AppUrl.createArea));
  //   request.body = json.encode({"areaName": areaName, "areaImage": imageUrl});
  //   request.headers.addAll(headers);

  //   http.StreamedResponse response = await request.send();

  //   if (response.statusCode == 200) {
  //     print(await response.stream.bytesToString());
  //   } else {
  //     print(response.reasonPhrase);
  //   }
  // }

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
  // Future<void> postHallsByAdmin(
  //     List listImages,
  //     String areaId,
  //     String hallOwnerId,
  //     String OwnerName,
  //     String hallName,
  //     int OwnerContact,
  //     String OwnerEmail,
  //     String HallAddress,
  //     int HallCapacity,
  //     int PricePerHead,
  //     int CateringPerHead,
  //     bool EventPlanner) async {
  //   var headers = {'Content-Type': 'application/json'};
  //   var request = http.Request(
  //       'POST', Uri.parse('http://192.168.1.104:2000/api/halls/createHalls'));
  //   request.body = json.encode({
  //     "images": listImages,
  //     "areaId": areaId,
  //     "hallOwnerId": hallOwnerId,
  //     "OwnerName": OwnerName,
  //     "hallName": hallName,
  //     "OwnerContact": OwnerContact,
  //     "OwnerEmail": OwnerEmail,
  //     "HallAddress": HallAddress,
  //     "HallCapacity": HallCapacity,
  //     "PricePerHead": PricePerHead,
  //     "CateringPerHead": CateringPerHead,
  //     "EventPlanner": EventPlanner,
  //   });
  //   request.headers.addAll(headers);

  //   http.StreamedResponse response = await request.send();

  //   if (response.statusCode == 200) {
  //     print(await response.stream.bytesToString());
  //   } else {
  //     print(response.reasonPhrase);
  //   }
  // }

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

  Future<void> postbookHallsByUser(
      String userId,
      String date,
      String time,
      int guestsQuantity,
      bool eventPlaner,
      bool cateringServices,
      int totalPayment,
      String hallOwnerId) async {
    print("76 $userId");

    var headers = {'Content-Type': 'application/json'};
    var request = http.Request('POST', Uri.parse(AppUrl.postbookHallsByUser));
    request.body = json.encode({
      "userId": userId,
      "Date": date,
      "Time": time,
      "GuestsQuantity": guestsQuantity,
      "EventPlaner": eventPlaner,
      "CateringServices": cateringServices,
      "TotalPaynment": totalPayment,
      "hallOwnerId": hallOwnerId
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }

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
