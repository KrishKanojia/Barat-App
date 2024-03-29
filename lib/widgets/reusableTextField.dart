import 'package:barat/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ReusableTextField extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool obscure;
  final String hintText;
  final bool? enabled;
  final bool readonly;

  const ReusableTextField({
    Key? key,
    required this.hintText,
    required this.controller,
    required this.keyboardType,
    this.enabled,
    this.obscure = false,
    this.readonly = false,
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

class CustomTextEditing extends StatelessWidget {
  final String hintText;
  final TextEditingController textEditingController;

  const CustomTextEditing(
      {Key? key, required this.hintText, required this.textEditingController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textEditingController,
      decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(color: Colors.transparent),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(color: Colors.transparent),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 25),
          fillColor: const Color(
            0xffF5F5F5,
          ),
          hintText: hintText,
          hintStyle:
              const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
    );
  }
}
