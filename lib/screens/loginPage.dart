import 'package:barat/screens/forget_password.dart';
import 'package:barat/screens/signUpPage.dart';
import 'package:barat/screens/verification_screen.dart';
import 'package:barat/services/credentialservices.dart';
import 'package:barat/utils/color.dart';
import 'package:barat/utils/constants.dart';
import 'package:barat/widgets/buildPasswordField.dart';
import 'package:barat/widgets/buildTextField.dart';
import 'package:barat/widgets/password_TextField.dart';
import 'package:barat/widgets/reusableTextField.dart';
import 'package:barat/widgets/reusableTextIconButton.dart';
import 'package:barat/widgets/reusablealreadytext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  Widget _buildForgotPasswordBtn() {
    return Container(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () => Get.to(() => const ForgetPassword()),
        child: Text(
          'Forgot Password?',
          style: kLabelStyle,
        ),
      ),
    );
  }

  Widget _buildLoginBtn() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          primary: Colors.white,
        ),
        onPressed: () {
          if (credentialServices.getisLoading == false) {
            if (_username.text.trim().toString().isEmpty &&
                _password.text.trim().toString().isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                duration: Duration(seconds: 3),
                content: Text(
                  "Field is Empty",
                ),
              ));
            } else {
              credentialServices.signInWithUsername(
                username: _username.text.trim().toString().toLowerCase(),
                password: _password.text.trim().toString(),
                context: context,
              );
            }
          } else {
            print("Nothing Happening in Progess Indicator");
          }
        },
        child: const Padding(
          padding: EdgeInsets.all(15.0),
          child: Text(
            'LOGIN',
            style: TextStyle(
              color: secondaryColor,
              letterSpacing: 1.5,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'OpenSans',
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: [
              Container(
                  height: height,
                  width: width,
                  decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          background1Color,
                          secondaryColor,
                        ],
                        stops: [0.2, 0.9],
                      ),
                      color: whiteColor,
                      borderRadius: BorderRadius.circular(8)),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40.0,
                    ),
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Text('data')
                        SizedBox(
                          height: height * 0.05,
                        ),
                        FittedBox(
                          child: Image.asset(
                            'images/logo1.png',
                            width: 180,
                            height: 180,
                            fit: BoxFit.fill,
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        Row(
                          children: const [
                            Text(
                              'Sign In',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 30.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20.0),
                        BuildTextFormField(
                          controller: _username,
                          hintText: 'Enter your Email',
                          keyboardType: TextInputType.text,
                          titleText: 'Email',
                        ),

                        const SizedBox(height: 20.0),

                        BuildPasswordField(
                          controller: _password,
                          hintText: 'Enter your Password',
                          keyboardType: TextInputType.visiblePassword,
                          titleText: 'Password',
                          obscure: obserText,
                          onTap: () {
                            setState(() {
                              obserText = !obserText;
                            });
                          },
                        ),

                        _buildForgotPasswordBtn(),

                        Obx(
                          () => InkWell(
                            onTap: () {
                              // Get.off(() => '/sign-in');
                            },
                            child: credentialServices.getisLoading == false
                                ? _buildLoginBtn()
                                // const ReusableTextIconButton(
                                //     text: "Login",
                                //   )
                                : Container(
                                    width: double.infinity,
                                    height: height / 14,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadiusDirectional.circular(15),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 2,
                                          blurRadius: 7,
                                          offset: const Offset(0,
                                              3), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    child: const Center(
                                      child: CircularProgressIndicator(
                                        color: secondaryColor,
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
                            width: double.infinity,
                            height: height / 14,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadiusDirectional.circular(20),
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
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'images/google_signin.png',
                                    width: 18,
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    "Sign in with Google",
                                    style: TextStyle(
                                        fontSize: 18.sp,
                                        color: secondaryColor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        ReusableAlreadyText(
                          text: 'Signup',
                          onClick: () => Get.off(() => const SignUpPage()),
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
