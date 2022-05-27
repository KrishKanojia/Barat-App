import 'package:barat/screens/loginPage.dart';
import 'package:barat/services/credentialservices.dart';
import 'package:barat/utils/color.dart';
import 'package:barat/widgets/reusableBigText.dart';
import 'package:barat/widgets/reusableTextField.dart';
import 'package:barat/widgets/reusableTextIconButton.dart';
import 'package:barat/widgets/reusablealreadytext.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final CredentialServices credentialServices = CredentialServices();
  final TextEditingController _username = TextEditingController();
  final TextEditingController _fullname = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  RegExp regExp = RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
  int userRoll = 1;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _username.dispose();
    _fullname.dispose();
    _phone.dispose();
    _email.dispose();
    _password.dispose();
  }

  void validation(BuildContext context) async {
    if (_username.text.trim().isEmpty &&
        _email.text.trim().isEmpty &&
        _password.text.trim().isEmpty &&
        _phone.text.trim().isEmpty &&
        _fullname.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("All Field Are Empty"),
        ),
      );
    } else if (_fullname.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("FullName is Empty"),
        ),
      );
    } else if (_phone.text.trim().length > 13 ||
        _phone.text.toString().trim().length < 11) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Invalid Phone Number"),
        ),
      );
    } else if (_email.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Email Is Empty"),
        ),
      );
    } else if (!regExp.hasMatch(_email.text.trim())) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please Try Vaild Email"),
        ),
      );
    } else if (_password.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Password Is Empty"),
        ),
      );
    } else if (_password.text.trim().length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Password  Is Too Short"),
        ),
      );
    } else {
      credentialServices.registerAccount(
          context: context,
          email: _email.text.toString(),
          fullname: _fullname.text.toString(),
          password: _password.text.toString(),
          phNo: _phone.text.toString(),
          name: _username.text.toString(),
          routename: "/HomePage");
    }
  }

  @override
  Widget build(BuildContext context) {
    print("32   $userRoll");
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffoldKey,
      body: SingleChildScrollView(
        child: Center(
          child: Form(
            key: _formKey,
            child: Container(
              width: 500,
              color: primaryColor,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height),
                child: Container(
                    margin: const EdgeInsets.all(50),
                    decoration: BoxDecoration(
                        color: whiteColor,
                        borderRadius: BorderRadius.circular(8)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: ReusableBigText(
                            text: 'Sign Up',
                          ),
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        ReusableTextField(
                          controller: _username,
                          hintText: 'username',
                          keyboardType: TextInputType.text,
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        ReusableTextField(
                          controller: _fullname,
                          hintText: 'Full Name',
                          keyboardType: TextInputType.text,
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        // TextFormField(
                        //   controller: _phone,
                        //   maxLength: 11,
                        //   decoration: const InputDecoration.collapsed(
                        //     hintText: 'Phone: +9233546586',
                        //   ),
                        //   // hintText: 'Phone: +9233546586',
                        //   keyboardType: TextInputType.text,
                        // ),
                        ReusableTextField(
                          controller: _phone,
                          hintText: 'Phone: +9233546586',
                          keyboardType: TextInputType.text,
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        ReusableTextField(
                          controller: _email,
                          hintText: 'E-mail',
                          keyboardType: TextInputType.text,
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        ReusableTextField(
                          controller: _password,
                          hintText: 'Password',
                          keyboardType: TextInputType.visiblePassword,
                          obscure: true,
                        ),
                        SizedBox(
                          height: height * 0.02,
                        ),
                        Obx(
                          () => InkWell(
                            onTap: () async {
                              // credentialServices.signUpPost(
                              //     _username.text,
                              //     _fullname.text,
                              //     _email.text,
                              //     _phone.text,
                              //     _password.text,
                              //     userRoll);
                              credentialServices.getisLoading == false
                                  ? validation(context)
                                  : () {
                                      print(
                                          "Nothing Happen in register Screen");
                                    };
                            },
                            child: credentialServices.getisLoading == false
                                ? const ReusableTextIconButton(
                                    text: "SignUp",
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
                                          offset: const Offset(0,
                                              3), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    child: const Padding(
                                        padding: EdgeInsets.all(14.0),
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                          ),
                                        )),
                                  ),
                          ),
                        ),
                        ReusableAlreadyText(
                          text: "Login",
                          onClick: () => Get.off(() => const LoginPage()),
                        ),
                      ],
                    )),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
