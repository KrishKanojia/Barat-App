import 'package:barat/screens/loginPage.dart';
import 'package:barat/utils/color.dart';
import 'package:barat/widgets/reusableTextIconButton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/reusableTextField.dart';

class ForgetPassword extends StatefulWidget {
  static String route = 'forgot-password';

  const ForgetPassword({Key? key}) : super(key: key);

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final TextEditingController _email = TextEditingController();

  RegExp regExp = RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

  Future veriyEmail() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _email.text.trim().toString());
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(seconds: 5),
          content: Text("Password Reset Email Sent"),
        ),
      );

      Get.off(() => const LoginPage());
    } on FirebaseAuthException catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 5),
          content: Text(error.toString()),
        ),
      );
      Get.back();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 5),
          content: Text(e.toString()),
        ),
      );
      Get.back();
    }
  }

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: whiteColor,
      body: Form(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Email Your Email',
                    style: TextStyle(fontSize: 30, color: secondaryColor),
                  ),
                  SizedBox(
                    height: size.height * 0.01,
                  ),
                  ReusableTextField(
                    controller: _email,
                    hintText: 'Email',
                    keyboardType: TextInputType.text,
                  ),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(40)),
                      icon: const Icon(
                        Icons.email,
                        size: 32,
                      ),
                      label: const Text(
                        "Reset Password",
                        style: TextStyle(fontSize: 20.0),
                      ),
                      onPressed: () {
                        if (_email.text.trim().toString().isEmpty ||
                            !regExp.hasMatch(_email.text.trim().toString())) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            duration: Duration(seconds: 3),
                            content: Text(
                              "Invalid Email Address",
                            ),
                          ));
                        } else {
                          veriyEmail();
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  InkWell(
                    onTap: () => Get.off(() => const LoginPage()),
                    child: const Text(
                      'Sign In',
                      style: TextStyle(
                        color: background1Color,
                        fontWeight: FontWeight.bold,
                        fontSize: 24.0,
                      ),
                    ),
                  ), // I(
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
