import 'package:barat/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PasswordTextField extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool obscure;
  final String hintText;
  final bool? enabled;
  final bool readonly;
  final Function? onTap;

  const PasswordTextField({
    Key? key,
    required this.hintText,
    required this.controller,
    required this.keyboardType,
    this.enabled,
    this.obscure = false,
    this.readonly = false,
    required this.onTap,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: TextField(
        readOnly: readonly == true ? true : false,
        controller: controller,
        enabled: enabled ?? true,
        obscureText: obscure,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          counterStyle: const TextStyle(
            height: double.minPositive,
          ),
          suffixIcon: GestureDetector(
            onTap: () {
              onTap!();
            },
            child: obscure == true
                ? const Icon(Icons.visibility)
                : const Icon(Icons.visibility_off),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(color: borderColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(color: borderColor),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
          hintText: hintText,
          fillColor: primaryColor,
          hintStyle: const TextStyle(
              fontSize: 16, color: textColor, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
