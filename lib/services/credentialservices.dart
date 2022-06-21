import 'dart:convert';

import 'package:barat/Models/user_model.dart';
import 'package:barat/screens/admin.dart';
import 'package:barat/screens/loginPage.dart';
import 'package:barat/screens/order_confirm_list.dart';
import 'package:barat/screens/verification_screen.dart';
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
  FirebaseAuth auth = FirebaseAuth.instance;
  GoogleSignIn googleSignIn = GoogleSignIn();

  var isGoogleSignedIn = false.obs;
  bool get getisGoogleSignedIn => isGoogleSignedIn.value;
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
  var isEmailVerified = false.obs;
  bool get getisEmailVerified => isEmailVerified.value;

  Future signIn(
      {required String email,
      required String password,
      required BuildContext context}) async {
    String errorMessage;
    var db = FirebaseFirestore.instance;

    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email.toLowerCase(), password: password);

      bool isEmaiLVerified = FirebaseAuth.instance.currentUser!.emailVerified;
      if (!isEmaiLVerified) {
        isLoading.value = false;

        Get.to(
          () => VerificationScreen(
            email: email,
            password: password,
            usercredential: userCredential,
            routename: "/signin",
          ),
        );
      } else {
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
            print("The Value of Admin is ${isAdmin.value}");

            isLoading.value = false;
            username.value = data["name"];
            useremail.value = data["email"];

            Get.offAll(() => const AdminPage());
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
            isGoogleSignedIn.value = false;

            Get.off(() => const HomePage());
          }
        });
      }
    } on FirebaseAuthException catch (e) {
      isLoading.value = false;
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            duration: Duration(seconds: 3),
            content: Text(
              'No user found for that email.',
            ),
          ),
        );
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            duration: Duration(seconds: 3),
            content: Text(
              'Wrong password provided for that user.',
            ),
          ),
        );
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

  Future<void> saveNewUserData(
      {required String name,
      required String fullname,
      required String phNo,
      required String email,
      required String password,
      required BuildContext context,
      required String routename,
      required UserCredential user}) async {
    await FirebaseFirestore.instance
        .collection("User")
        .doc(user.user!.uid)
        .set({
      // Change username to Lowercase
      "userName": name,
      "fullname": fullname,
      "userId": user.user!.uid,
      "email": email,
      "phoneNumber": phNo,
      "account_created": Timestamp.now(),
    });
    // print("Save to Database");
    // if (routename == '/create-hall-user') {
    //   isLoading.value = false;
    //   Get.offAll(() => const HomePage());
    // } else if (routename == "/signup") {
    //   username.value = name;
    //   useremail.value = email;
    //   userUid.value = user.user!.uid;
    //   isLoading.value = false;
    //   Get.offAll(() => const LoginPage());
    // }
  }

  Future<void> registerAccount(
      {required String name,
      required String fullname,
      required String phNo,
      required String email,
      required String password,
      required BuildContext context,
      required String routename}) async {
    isLoading.value = true;
    bool isEmailVerified = false;

    try {
      bool isUserExist = await usernameExist(context: context, username: name);
      if (isUserExist == true) {
        UserCredential user = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        await saveNewUserData(
            context: context,
            email: email,
            name: name,
            fullname: fullname,
            password: password,
            phNo: phNo,
            routename: routename,
            user: user);
        isLoading.value = false;
        Get.to(
          () => VerificationScreen(
              name: name,
              fullname: fullname,
              phNo: phNo,
              email: email,
              password: password,
              routename: routename,
              usercredential: user),
        );
      } else {
        isLoading.value = false;
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            duration: Duration(seconds: 3),
            content: Text(
              'The account already exists for that email.',
            ),
          ),
        );
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

    // Get.off(() => const LoginPage());
  }

  Future signInWithGoogle() async {
    try {
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

      final User? googleuser = userCredential.user;
      assert(googleuser!.uid != null);
      isGoogleSignedIn.value = true;
      userUid.value = googleuser!.uid;
      username.value = googleuser.displayName!;
      useremail.value = googleuser.email!;
      print(
          "Google Sign In => ${userUid.value}, user name : ${username.value}, email: ${useremail.value} ");
      // assert(user!.uid != null);
      FirebaseFirestore.instance.collection("User").doc(googleuser.uid).set({
        "userName": googleuser.displayName.toString().toLowerCase(),
        "fullname": googleuser.displayName.toString().toLowerCase(),
        "userId": googleuser.uid,
        "email": googleuser.email!.toLowerCase(),
        "phoneNumber": googleuser.phoneNumber ?? "00000000000",
        "account_created": Timestamp.now(),
      });

      print(
          "Google Sign In => ${userUid.value}, user name : ${username.value}, email: ${useremail.value} ");
      Get.off(() => const HomePage());
      print("Google Sign In => $userUid");
    } catch (e) {
      print("This is Error ${e.toString()}");
    }
  }

  Future SignOutGoogle() async {
    await googleSignIn.signOut();
    // Get.off(() => const LoginPage());
  }

  Future<bool> usernameExist(
      {required String username, required BuildContext context}) async {
    try {
      QuerySnapshot userdata = await FirebaseFirestore.instance
          .collection('User')
          .where('userName', isEqualTo: username)
          .get();
      if (userdata.size > 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            duration: Duration(seconds: 3),
            content: Text(
              'Username Exist ',
            ),
          ),
        );
        return false;
      } else if (userdata.docs.isEmpty) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 3),
          content: Text(
            e.toString(),
          ),
        ),
      );
      return false;
    }
  }

  Future<void> signInWithUsername(
      {required String username,
      required String password,
      required BuildContext context}) async {
    late String useremail;
    isLoading.value = true;
    // String userName = username.replaceAll(' ', '').toLowerCase();
    RegExp regExp = RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

    try {
      if (!regExp.hasMatch(username)) {
        QuerySnapshot userdata = await FirebaseFirestore.instance
            .collection('User')
            .where('userName', isEqualTo: username)
            .get();
        if (userdata.size > 0) {
          userdata.docs.forEach((doc) {
            useremail = doc.get("email");
            print("Owner email is $useremail");
          });

          signIn(
            context: context,
            email: useremail,
            password: password,
          );
        } else {
          isLoading.value = false;

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              duration: Duration(seconds: 3),
              content: Text(
                'Invalid Username ',
              ),
            ),
          );
        }
      } else {
        signIn(
          context: context,
          email: username,
          password: password,
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 3),
          content: Text(
            e.toString(),
          ),
        ),
      );
    }
  }
}
