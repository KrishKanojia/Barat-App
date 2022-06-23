import 'package:barat/utils/constants.dart';
import 'package:flutter/material.dart';

class BuildPasswordField extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool obscure;
  final String hintText;
  final String titleText;
  final bool? enabled;
  final bool readonly;
  final Function? onTap;

  const BuildPasswordField({
    Key? key,
    required this.hintText,
    required this.controller,
    required this.keyboardType,
    required this.titleText,
    this.enabled,
    this.obscure = false,
    this.readonly = false,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Password',
          style: kLabelStyle,
        ),
        const SizedBox(height: 5.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            cursorColor: Colors.white,
            obscureText: obscure,
            controller: controller,
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              suffixIcon: GestureDetector(
                onTap: () {
                  onTap!();
                },
                child: obscure == true
                    ? const Icon(
                        Icons.visibility,
                        color: Colors.white,
                      )
                    : const Icon(
                        Icons.visibility_off,
                        color: Colors.white,
                      ),
              ),
              prefixIcon: const Icon(
                Icons.lock,
                color: Colors.white,
              ),
              hintText: 'Enter your Password',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }
}
