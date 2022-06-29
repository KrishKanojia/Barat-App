import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../screens/HomePage.dart';

class RatingService {
  Future<void> giveFeeback({
    required String? areaid,
    required String? hallid,
    required String? bookingid,
    required String? feedback,
    required double? rating,
  }) async {
    print(
        "Hallid  $areaid  areaid  $hallid  bookingid  $bookingid  feedback  $feedback  rating  $rating");
    var db = FirebaseFirestore.instance;
    var hallrating = 0.0;

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
              int countRating = querySnapshot.docs.length;
              //  Read All Ratings From User
              querySnapshot.docs.forEach((DocumentSnapshot docSnapshot) {
                Map<String, dynamic> data =
                    docSnapshot.data() as Map<String, dynamic>;
                singleratings += double.parse(data["rating"].toString());
              });
              singleratings += rating!;

              //  Calculate Total Rating
              hallrating = singleratings / countRating;
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
    } catch (e) {
      print("Error is : $e");
    }
  }
}
