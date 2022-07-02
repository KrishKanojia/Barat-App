import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../screens/HomePage.dart';

class RatingService {
  Future<void> giveFeeback({
    required String? areaid,
    required String? hallid,
    required String? bookingid,
    required String? feedback,
    required double? rating,
    required BuildContext context,
  }) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    var db = FirebaseFirestore.instance;
    var hallrating = 0.0;
    int countRating = 0;
    var hallReference =
        db.collection("admin").doc(areaid).collection("halls").doc(hallid);

    var bookingReference =
        db.collection("bookings").where('hallid', isEqualTo: hallid);

    var feedbackReference = db.collection("bookings").doc(bookingid);

    try {
      await db.runTransaction((transaction) async {
        return await transaction
            .get(hallReference)
            .then((DocumentSnapshot docSnapshot) async {
          if (!docSnapshot.exists) {
            throw "Group document Does not exist";
          } else {
            print("We are in else Statement to Read All Ratings");
            Map<String, dynamic> hallData =
                docSnapshot.data() as Map<String, dynamic>;

            double singleratings = 0.0;
            await bookingReference.get().then((querySnapshot) {
              //  Read All Ratings From User
              querySnapshot.docs.forEach((DocumentSnapshot docSnapshot) {
                Map<String, dynamic> data =
                    docSnapshot.data() as Map<String, dynamic>;
                //

                var ratingVal = double.parse(data["rating"].toString());
                if (ratingVal != 0) {
                  print("The ratings  are  ${ratingVal}");
                  singleratings += ratingVal;
                  countRating++;
                }
              });
              singleratings += rating!;

              //  Calculate Total Rating
              hallrating = singleratings / (countRating + 1);
              print("Total count ${countRating}");
            });

            // Update hall Rating
            transaction.update(hallReference, {
              'hallrating': hallrating,
            });

            // Update Feedback User
            transaction.update(feedbackReference, {
              "feedback": feedback,
              "rating": rating,
            });
          }
        });
      }).whenComplete(() {
        print("Rating completed successfully");
        Get.offAll(() => const HomePage());
      });
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
}
