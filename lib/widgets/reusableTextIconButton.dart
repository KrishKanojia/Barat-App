import 'package:barat/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReusableTextIconButton extends StatelessWidget {
  final String text;
  final double margin;
  final Color color;

  // final Function onClick;

  const ReusableTextIconButton(
      {Key? key,
      required this.text,
      this.color = background1Color,
      this.margin = 45})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      height: height / 14,
      margin: EdgeInsets.symmetric(horizontal: margin.w),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadiusDirectional.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 7,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
            ),
            const Icon(Icons.arrow_forward_ios_sharp),
          ],
        ),
      ),
    );
  }
}
