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
// import 'package:http/http.dart' as http;

import '../screens/HomePage.dart';

class CredentialServices extends GetxController {
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

  var isLoading = false.obs;
  bool get getisLoading => isLoading.value;
  var userUid = ' '.obs;
  var username = ' '.obs;
  var useremail = ' '.obs;
  String get getUserId => userUid.value;
  String get getusername => username.value;
  String get getuseremail => useremail.value;
  String adminUid = "mqDeynQAVabEqKSfwGqIVjQmUfC2";
  var isAdmin = false.obs;
  bool get getisAdmin => isAdmin.value;

  Future signIn(
      {required String email,
      required String password,
      required BuildContext context}) async {
    String errorMessage;
    var db = FirebaseFirestore.instance;
    isLoading.value = true;
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email.toLowerCase(), password: password);

      userUid.value = userCredential.user!.uid;

      await db
          .collection('admincredentials')
          .doc('mqDeynQAVabEqKSfwGqIVjQmUfC2')
          .get()
          .then((DocumentSnapshot DocumentSnapshot) async {
        Map<String, dynamic> data =
            DocumentSnapshot.data()! as Map<String, dynamic>;
        if (userCredential.user!.email == data["email"] &&
            password == data["password"]) {
          isAdmin.value = true;
          // print("The Value of Admin is ${userUid.value}");

          // print("Username is : $username , useremail is : $useremail");
          isLoading.value = false;
          username.value = data["name"];
          useremail.value = data["email"];
          Get.off(() => const AdminPage());
        } else {
          isAdmin.value = false;
          await db
              .collection("User")
              .doc(userUid.value)
              .get()
              .then((docSnasphot) {
            Map<String, dynamic> data =
                docSnasphot.data()! as Map<String, dynamic>;
            username.value = data["userName"];
            useremail.value = data["email"];
          });
          // username = data["userName"];
          // useremail = data["email"];
          isAdmin.value = false;
          isLoading.value = false;

          Get.off(() => const HomePage());
        }
      });
    } on FirebaseAuthException catch (e) {
      isLoading.value = false;

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
          isLoading.value = false;
          break;
        case "ERROR_WRONG_PASSWORD":
          errorMessage = "Your password is wrong.";
          isLoading.value = false;

          break;
        case "ERROR_USER_NOT_FOUND":
          errorMessage = "User with this email doesn't exist.";
          isLoading.value = false;

          break;
        case "ERROR_USER_DISABLED":
          errorMessage = "User with this email has been disabled.";
          isLoading.value = false;
          break;
        case "ERROR_TOO_MANY_REQUESTS":
          errorMessage = "Too many requests. Try again later.";
          isLoading.value = false;
          break;
        case "ERROR_OPERATION_NOT_ALLOWED":
          errorMessage = "Signing in with Email and Password is not enabled.";
          isLoading.value = false;
          break;
        default:
          errorMessage = "An undefined Error happened.";
      }
      isLoading.value = false;
      print("Is this is Error $errorMessage");
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

  Future registerAccount(
      {required String name,
      required String fullname,
      required String phNo,
      required String email,
      required String password,
      required BuildContext context,
      required String routename}) async {
    isLoading.value = true;

    try {
      UserCredential User = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      FirebaseFirestore.instance.collection("User").doc(User.user!.uid).set({
        "userName": name,
        "fullname": fullname,
        "userId": User.user!.uid,
        "email": email.toLowerCase(),
        "phoneNumber": phNo,
        "account_created": Timestamp.now(),
      });

      if (routename == '/create-hall-user') {
        isLoading.value = false;
        Get.back();
      } else if (routename == "/HomePage") {
        username.value = name;
        useremail.value = email;
        userUid.value = User.user!.uid;
        isLoading.value = false;
        Get.offAll(() => const LoginPage());
      }
    } on PlatformException catch (e) {
      isLoading.value = false;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
    } on FirebaseAuthException catch (e) {
      isLoading.value = false;
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            duration: Duration(seconds: 3),
            content: Text(
              'The password provided is too weak.',
            ),
          ),
        );
      } else if (e.code == 'email-already-in-use') {
        isLoading.value = false;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            duration: Duration(seconds: 3),
            content: Text(
              'The account already exists for that email.',
            ),
          ),
        );
        print('The account already exists for that email.');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: const Duration(seconds: 3),
            content: Text(
              '${e.message}',
            ),
          ),
        );
      }
    } catch (errorMsg) {
      isLoading.value = false;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 3),
          content: Text(
            errorMsg.toString(),
          ),
        ),
      );
    }
  }

  Future LogOutViaEmail() async {
    await auth.signOut();
    Get.off(() => const LoginPage());
  }

  Future signinWithGoogle() async {
    print("In Google Auth");
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    // Obtain the auth details from the request.
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;
    // Create a new credential.
    final OAuthCredential googleCredential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    // Sign in to Firebase with the Google [UserCredential].
    final UserCredential googleUserCredential =
        await FirebaseAuth.instance.signInWithCredential(googleCredential);

    // final GoogleSignInAccount? googleSignInAccount =
    //     await googleSignIn.signIn();
    // final GoogleSignInAuthentication googleSignInAuthentication =
    //     await googleSignInAccount!.authentication;

    // final AuthCredential authCredential = GoogleAuthProvider.credential(
    //   accessToken: googleSignInAuthentication.accessToken,
    //   idToken: googleSignInAuthentication.idToken,
    // );

    // final UserCredential userCredential =
    //     await FirebaseAuth.instance.signInWithCredential(authCredential);

    final User? user = googleUserCredential.user;

    assert(user!.uid != null);
    FirebaseFirestore.instance.collection("User").doc(user!.uid).set({
      "userName": user.displayName,
      "fullname": user.displayName,
      "userId": user.uid,
      "email": user.email!.toLowerCase(),
      "phoneNumber": user.phoneNumber,
      "account_created": Timestamp.now(),
    });
    userUid.value = user.uid;
    username.value = user.displayName!;
    useremail.value = user.email!;
    print(
        "Google Sign In => ${userUid.value}, user name : ${username.value}, email: ${useremail.value} ");
    Get.off(() => const HomePage());
  }

  Future SignOutGoogle() async {
    return googleSignIn.signOut();
  }

  // Future signIntoAccount(
  //     {required String email, required String password}) async {
  //   UserCredential userCredential =
  //       await auth.signInWithEmailAndPassword(email: email, password: password);

  //   userUid = userCredential.user!.uid;

  //   Get.off(() => const HomePage());
  //    print(userUid);
  // }
}
