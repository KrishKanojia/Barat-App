import 'package:barat/screens/forget_password.dart';
import 'package:barat/screens/signUpPage.dart';
import 'package:barat/screens/verification_screen.dart';
import 'package:barat/services/credentialservices.dart';
import 'package:barat/utils/color.dart';
import 'package:barat/widgets/password_TextField.dart';
import 'package:barat/widgets/reusableTextField.dart';
import 'package:barat/widgets/reusableTextIconButton.dart';
import 'package:barat/widgets/reusablealreadytext.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  static const routeName = '/login-page';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final box = GetStorage();
  bool obserText = true;
  // final CredentialServices credentialServices = CredentialServices();
  final credentialServices = Get.put(CredentialServices());
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();
  // final String username = "admin@gmail.com";
  // final int password = 12345;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _username.dispose();
    _password.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: 500,
            color: primaryColor,
            child: ConstrainedBox(
              constraints:
                  BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
              child: Container(
                  margin: const EdgeInsets.all(50),
                  decoration: BoxDecoration(
                      color: whiteColor,
                      borderRadius: BorderRadius.circular(8)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Text('data')
                      SizedBox(
                          width: height * 0.4,
                          child: const Image(
                              image: AssetImage('images/logo1.png'))),
                      SizedBox(
                        height: height * 0.01,
                      ),

                      ReusableTextField(
                        controller: _username,
                        hintText: 'Username or Email',
                        keyboardType: TextInputType.text,
                      ),
                      SizedBox(
                        height: height * 0.01,
                      ),
                      PasswordTextField(
                        controller: _password,
                        hintText: 'Password',
                        keyboardType: TextInputType.visiblePassword,
                        obscure: obserText,
                        onTap: () {
                          setState(() {
                            obserText = !obserText;
                          });
                        },
                      ),
                      SizedBox(
                        height: height * 0.01,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 20,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                InkWell(
                                  onTap: () => Get.to(() => ForgetPassword()),
                                  child: const Text(
                                    "Forget Password?",
                                    style: TextStyle(
                                      color: secondaryColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                )
                              ]),
                        ),
                      ),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      Obx(
                        () => InkWell(
                          onTap: () {
                            // if (_username.text.toString() ==
                            //         username.toString() &&
                            //     _password.text.toString() ==
                            //         password.toString()) {
                            //   Get.off(() => const AdminPage());
                            // } else {
                            //   credentialServices.loginPost(
                            //       _username.text.toString(),
                            //       _password.text.toString());
                            // }
                            // credentialServices.loginPost(
                            //     _username.text.toString(),
                            //     _password.text.toString());
                            if (credentialServices.getisLoading == false) {
                              if (_username.text.trim().toString().isEmpty &&
                                  _password.text.trim().toString().isEmpty) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  duration: Duration(seconds: 3),
                                  content: Text(
                                    "Field is Empty",
                                  ),
                                ));
                              } else {
                                credentialServices.signInWithUsername(
                                  username: _username.text
                                      .trim()
                                      .toString()
                                      .toLowerCase(),
                                  password: _password.text.trim().toString(),
                                  context: context,
                                );
                              }
                            } else {
                              print("Nothing Happening in Progess Indicator");
                            }

                            // Get.off(() => '/sign-in');
                          },
                          child: credentialServices.getisLoading == false
                              ? const ReusableTextIconButton(
                                  text: "Login",
                                )
                              : Container(
                                  width: width,
                                  height: height / 14,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 45.0),
                                  decoration: BoxDecoration(
                                    color: secondaryColor,
                                    borderRadius:
                                        BorderRadiusDirectional.circular(15),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 2,
                                        blurRadius: 7,
                                        offset: const Offset(
                                            0, 3), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: const Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                        ),
                      ),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      InkWell(
                        onTap: () {
                          credentialServices.signInWithGoogle();
                        },
                        child: Container(
                          width: width,
                          height: height / 14,
                          margin: EdgeInsets.symmetric(horizontal: 45.w),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadiusDirectional.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 7,
                                offset: const Offset(
                                    0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Image.asset(
                                  'images/google_signin.png',
                                  width: 18,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  "Sign in with Google",
                                  style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      ReusableAlreadyText(
                        text: 'Signup',
                        onClick: () =>
                            // Get.off(() => const VerificationScreen())
                            Get.off(() => const SignUpPage()),
                      ),
                    ],
                  )),
            ),
          ),
        ),
      ),
    );
  }
}
