import 'dart:async';

import 'package:async/async.dart';
import 'package:barat/screens/HomePage.dart';
import 'package:barat/screens/loginPage.dart';
import 'package:barat/services/credentialservices.dart';
import 'package:barat/utils/color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
        Get.offAll(() => const HomePage());
      } else {
        credentialServices.saveNewUserData(
          context: context,
          name: widget.name,
          fullname: widget.fullname,
          phNo: widget.phNo,
          email: widget.email,
          password: widget.password,
          routename: widget.routename,
          user: widget.usercredential,
        );
      }

      timer?.cancel();
    }
  }

  @override
  // TODO: implement mounted

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
                    FirebaseAuth.instance.signOut();
                    Get.back();
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
