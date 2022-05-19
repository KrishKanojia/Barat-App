import 'dart:convert';

import 'package:barat/Models/user_model.dart';
import 'package:barat/screens/admin.dart';
import 'package:barat/screens/loginPage.dart';
import 'package:barat/screens/order_confirm_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

import '../screens/HomePage.dart';

class CredentialServices {
  // static var client = http.Client();

  // final box = GetStorage();
  // void signUpPost(String userName, String fullName, String userEmail,
  //     String phoneNumber, String password, int userRoll) async {
  //   // try {
  //   //   var response = await http.post(
  //   //       Uri.parse('https://reqres.in/api/register'),
  //   //       body: {'email': email, 'password': password});
  //   //   if (response.statusCode == 200) {
  //   //     print(response.body.toString());
  //   //     Get.off(() => const HomePage());
  //   //     print('account created Succesfully');
  //   //   } else {
  //   //     print("Account is not Created");
  //   //   }
  //   // } catch (e) {
  //   //   print(e.toString());
  //   // }

  //   try {
  //     var headers = {'Content-Type': 'application/json'};
  //     var request = http.Request(
  //         'POST', Uri.parse('http://192.168.20.28:2000/api/user/Register'));
  //     request.body = json.encode({
  //       "UserName": userName,
  //       "FullName": fullName,
  //       "UserEmail": userEmail,
  //       "phoneNumber": phoneNumber,
  //       "password": password,
  //       "userRoll": userRoll
  //     });
  //     request.headers.addAll(headers);

  //     http.StreamedResponse response = await request.send();

  //     if (response.statusCode == 200) {
  //       box.write('responseSignUp', response.toString());
  //       print(await response.stream.bytesToString());
  //       userRoll == 1
  //           ? Get.off(() => const HomePage())
  //           : Get.to(() => const OrderConfirmList());
  //     } else {
  //       print(response.reasonPhrase);
  //     }
  //   } catch (e) {
  //     print(e.toString());
  //   }
  // }

  // Future<UserModel?> loginPost(String userName, String password) async {
  //   // try {
  //   //   var response = await http.post(Uri.parse('https://reqres.in/api/login'),
  //   //       body: {'email': email, 'password': password});
  //   //   if (response.statusCode == 200) {
  //   //     print(response.body.toString());
  //   //     Get.off(() => const HomePage());
  //   //     print('account created Succesfully');
  //   //   } else {
  //   //     print("Account is not Created");
  //   //   }
  //   // } catch (e) {
  //   //   print(e.toString());
  //   // }

  //   try {
  //     // var headers = {'Content-Type': 'application/json'};
  //     // var request = http.Request(
  //     //     'POST', Uri.parse('http://192.168.20.28:2000/api/user/login'));
  //     // request.body = json.encode({"UserName": userName, "password": password});
  //     // request.headers.addAll(headers);
  //     //
  //     // // http.StreamedResponse response = await request.send();
  //     // http.StreamedResponse response = await request.send();
  //     //
  //     // if (response.statusCode == 200) {
  //     //   // print(await response.stream.bytesToString());
  //     //   box.write('responseLogin', response.toString());
  //     //   print(await response.stream.bytesToString());
  //     //   Get.off(() => const HomePage());
  //     // } else {
  //     //   print(response.reasonPhrase);
  //     // }

  //     // -----------------------------------------------------------------------
  //     var url = 'http://192.168.20.28:2000/api/user/login';
  //     Map data = {
  //       "UserName": userName,
  //       "password": password,
  //     };
  //     //encode Map to JSON
  //     var body = json.encode(data);

  //     var response = await client.post(Uri.parse(url),
  //         headers: {"Content-Type": "application/json"}, body: body);

  //     if (response.statusCode == 200) {
  //       var jsonString = jsonDecode(response.body);
  //       print(jsonString['data']['userRoll']);
  //       var userRole = await jsonString['data']['userRoll'];
  //       userRole == 0
  //           ? Get.off(() => const AdminPage())
  //           : userRole == 2
  //               ? Get.off(() => const OrderConfirmList())
  //               : Get.off(() => const HomePage());

  //       // var eee = json.decode(jsonString);
  //       // return UserModel(jsonString);
  //       // return jsonString;
  //     } else {
  //       //show error message
  //       return null;
  //     }
  //     // -----------------------------------------------------------------------
  //   } catch (e) {
  //     print(e.toString());
  //   }
  //   return null;
  // }

  FirebaseAuth auth = FirebaseAuth.instance;
  GoogleSignIn googleSignIn = GoogleSignIn();

  late String userUid;
  String get getUserId => userUid;

  Future signIn(
      {required String email,
      required String password,
      required BuildContext context}) async {
    String errorMessage;

    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);

      userUid = userCredential.user!.uid;
      FirebaseFirestore.instance
          .collection('admincredentials')
          .doc('h5Qk4puK8RstLGoS6Ssw')
          .get()
          .then((DocumentSnapshot DocumentSnapshot) {
        Map<String, dynamic> data =
            DocumentSnapshot.data()! as Map<String, dynamic>;
        if (userCredential.user!.email == data["email"] ||
            password == data["password"]) {
          Get.off(() => const AdminPage());
        } else {
          Get.off(() => const HomePage());
        }
      });
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 3),
          content: Text(
            '${e.message}',
          ),
        ),
      );
    } catch (error) {
      switch (error.toString()) {
        case "ERROR_INVALID_EMAIL":
          errorMessage = "Your email address appears to be malformed.";
          break;
        case "ERROR_WRONG_PASSWORD":
          errorMessage = "Your password is wrong.";
          break;
        case "ERROR_USER_NOT_FOUND":
          errorMessage = "User with this email doesn't exist.";
          break;
        case "ERROR_USER_DISABLED":
          errorMessage = "User with this email has been disabled.";
          break;
        case "ERROR_TOO_MANY_REQUESTS":
          errorMessage = "Too many requests. Try again later.";
          break;
        case "ERROR_OPERATION_NOT_ALLOWED":
          errorMessage = "Signing in with Email and Password is not enabled.";
          break;
        default:
          errorMessage = "An undefined Error happened.";
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 3),
          content: Text(
            errorMessage,
          ),
        ),
      );
    }
  }

  // Future signIntoAccount(
  //     {required String email, required String password}) async {
  //   UserCredential userCredential =
  //       await auth.signInWithEmailAndPassword(email: email, password: password);

  //   userUid = userCredential.user!.uid;

  //   Get.off(() => const HomePage());
  //    print(userUid);
  // }

  Future registerAccount(
      {required String username,
      required String fullname,
      required String phNo,
      required String email,
      required String password,
      required BuildContext context}) async {
    try {
      UserCredential User = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      FirebaseFirestore.instance.collection("User").doc(User.user!.uid).set({
        "userName": username,
        "fullname": fullname,
        "userId": User.user!.uid,
        "email": email,
        "phoneNumber": phNo,
      });

      Get.off(() => const HomePage());
    } on PlatformException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  Future LogOutViaEmail() async {
    await auth.signOut();
    Get.off(() => const LoginPage());
  }

  Future signinWithGoogle() async {
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount!.authentication;

    final AuthCredential authCredential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(authCredential);

    final User? user = userCredential.user;
    assert(user!.uid != null);
    userUid = user!.uid;
    print("Google Sign In => $userUid");
  }

  Future SignOutGoogle() async {
    return googleSignIn.signOut();
  }
}
