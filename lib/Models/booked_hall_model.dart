import 'package:cloud_firestore/cloud_firestore.dart';

class BookedHallModel {
  // BookedHallModel(
  //     {required listimages,
  //     required ownerName,
  //     required ownerContact,
  //     required ownerEmail,
  //     required hallAddress,
  //     required guestsQuantity,
  //     required clientname,
  //     required clientemail,
  //     required totalPayment,
  //     required date,
  //     required hallname,
  //     required eventplanner,
  //     required cateringServices,
  //     required ismyhall,
  //     required bookingId,
  //     required feedback,
  //     required event});
  List? listimages;
  String? ownerName;
  String? ownerContact;
  String? ownerEmail;
  String? hallAddress;
  var guestsQuantity;
  String? clientname;
  String? clientemail;
  var totalPayment;
  late DateTime date;
  String? hallname;
  bool? eventplanner;
  bool? cateringServices;

  String? bookingId;
  String? feedback;
  String? event;

  BookedHallModel.fromMap(dynamic data) {
    listimages = data["images"] ?? ' ';
    ownerName = data["ownername"].toUpperCase() ?? ' ';
    ownerContact = data["ownercontact"] ?? ' ';
    ownerEmail = data["owneremail"] ?? ' ';
    hallAddress = data["halladdress"];
    guestsQuantity = data["GuestsQuantity"] ?? 0.0;
    clientname = data["clientname"] ?? ' ';
    clientemail = data["clientemail"] ?? ' ';
    totalPayment = data["TotalPaynment"] ?? 0.0;
    date = data["Date"].toDate() ?? ' ';
    hallname = data["hallname"] ?? ' ';
    eventplanner = data["EventPlaner"] ?? ' ';
    cateringServices = data["CateringServices"] ?? ' ';

    bookingId = data["bookingId"] ?? ' ';
    feedback = data["feedback"] ?? ' ';
    event = data["event"] ?? ' ';
  }
}
