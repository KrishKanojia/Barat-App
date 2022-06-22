import 'dart:async';

import 'package:async/async.dart';
import 'package:barat/screens/HomePage.dart';
import 'package:barat/screens/admin.dart';
import 'package:barat/screens/loginPage.dart';
import 'package:barat/services/credentialservices.dart';
import 'package:barat/utils/color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class VerificationScreen extends StatefulWidget {
  final name;
  final fullname;
  final phNo;
  final email;
  final password;
  final routename;
  final usercredential;
  VerificationScreen({
    this.name = " ",
    this.fullname = " ",
    this.phNo = " ",
    required this.email,
    required this.password,
    required this.routename,
    required this.usercredential,
  });
  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  bool isEmaiLVerified = false;
  bool canResendEmail = false;
  Timer? timer;
  final credentialServices = Get.find<CredentialServices>();

  Future _sendVerificationEmail() async {
    try {
      final User? userAuth = widget.usercredential.user;
      // final user = FirebaseAuth.instance.userAuth;
      await userAuth!.sendEmailVerification();
      setState(() => canResendEmail = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Verification Email Sent "),
        ),
      );
      await Future.delayed(const Duration(seconds: 5), () {
        setState(() => canResendEmail = true);
      });
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 5),
          content: Text(" ${e.message}"),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 5),
          content: Text("Dont Send Message ${e.toString()}"),
        ),
      );
    }
  }

  Future _checkEmailVerified() async {
    try {
      await FirebaseAuth.instance.currentUser?.reload();
      setState(() {
        isEmaiLVerified = FirebaseAuth.instance.currentUser!.emailVerified;
      });

      if (isEmaiLVerified) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            duration: Duration(seconds: 5),
            content: Text("Email has been Verified"),
          ),
        );
        if (widget.routename == '/signin') {
          credentialServices.userUid.value = widget.usercredential.user!.uid;
          credentialServices.username.value =
              FirebaseAuth.instance.currentUser!.displayName!;
          credentialServices.useremail.value = widget.email;

          Get.offAll(() => const HomePage());
        } else if (widget.routename == "/signup") {
          Get.offAll(() => const LoginPage());
        } else if (widget.routename == '/create-hall-user') {
          Get.off(() => const AdminPage());
        }

        timer?.cancel();
      }
    } catch (e) {
      //  ScaffoldMessenger.of(context).showSnackBar(
      //    SnackBar(
      //     duration:const Duration(seconds: 5),
      //     content: Text(e.toString()),
      //   ),
      // );
      print(e.toString());
    }
  }

  @override
  @override
  void initState() {
    isEmaiLVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    if (!isEmaiLVerified) {
      _sendVerificationEmail();
      timer = Timer.periodic(
        const Duration(seconds: 3),
        (_) => _checkEmailVerified(),
      );
    }
    super.initState();
  }

  @override
  void dispose() async {
    timer?.cancel();
    super.dispose();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
          width: size.width,
          color: primaryColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "A verification email has been sent to your email.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black, fontSize: 20.0),
              ),
              const SizedBox(height: 25.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50)),
                  icon: const Icon(
                    Icons.email,
                    size: 32,
                  ),
                  label: const Text(
                    "Resent Email",
                    style: TextStyle(fontSize: 24.0),
                  ),
                  onPressed: () {
                    print("Resend 1 {$canResendEmail}");
                    canResendEmail == true
                        ? {_sendVerificationEmail()}
                        : print("Send $canResendEmail");
                  },
                ),
              ),
              const SizedBox(height: 25.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50.0),
                child: InkWell(
                  onTap: () {
                    if (widget.routename == '/signin') {
                      FirebaseAuth.instance.signOut();
                      Get.back();
                    } else if (widget.routename == "/signup") {
                      FirebaseAuth.instance.signOut();
                      Get.offAll(() => const LoginPage());
                    } else if (widget.routename == '/create-hall-user') {
                      Get.off(() => const AdminPage());
                    }
                  },
                  child: const Text(
                    "Cancel",
                    style: TextStyle(
                      fontSize: 24.0,
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
