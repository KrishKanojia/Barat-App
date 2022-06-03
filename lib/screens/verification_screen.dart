import 'dart:async';

import 'package:barat/screens/loginPage.dart';
import 'package:barat/services/credentialservices.dart';
import 'package:barat/utils/color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({Key? key}) : super(key: key);

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final name = Get.arguments[0]['name'];
  final fullname = Get.arguments[1]['fullname'];
  final phNo = Get.arguments[2]['phNo'];
  final email = Get.arguments[3]['email'];
  final password = Get.arguments[4]['password'];
  final routename = Get.arguments[5]['routename'];
  final UserCredential usercredential = Get.arguments[6]['usercredential'];
  bool isEmaiLVerified = false;
  bool canResendEmail = false;
  Timer? timer;
  final credentialServices = Get.find<CredentialServices>();

  Future _sendVerificationEmail() async {
    try {
      final User? userAuth = usercredential.user;
      // final user = FirebaseAuth.instance.userAuth;
      await userAuth!.sendEmailVerification();
      setState(() => canResendEmail = false);
      await Future.delayed(const Duration(seconds: 5));
      setState(() => canResendEmail = true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Verification Email Sent "),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }

  Future _checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();
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
      credentialServices.saveNewUserData(
        context: context,
        name: name,
        fullname: fullname,
        phNo: phNo,
        email: email,
        password: password,
        routename: routename,
        user: usercredential,
      );

      timer?.cancel();
    }
  }

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
  void dispose() {
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
                    canResendEmail == true ? _sendVerificationEmail() : () {};
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
