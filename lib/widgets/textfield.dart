import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:halenest/util/colors.dart';

class TextFieldContainer extends StatelessWidget {
  final String hinttext;
  final bool isPass;
  final TextEditingController controller;
  final TextInputType textInputType;

  const TextFieldContainer(
      {Key? key,
      required this.hinttext,
      this.isPass = false,
      required this.controller,
      required this.textInputType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 35.w),
      child: Container(
        height: 63.h,
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7.r),
            color: Colors.white,
            border: Border.all(color: const Color(0xffE7E7E7), width: 1.w)),
        child: TextField(
          cursorColor: primaryColor,
          obscureText: isPass,
          keyboardType: textInputType,
          controller: controller,
          decoration: InputDecoration(
              contentPadding:
                  EdgeInsets.only(left: 23.w, top: 18.h, bottom: 18.h),
              hintText: hinttext,
              hintStyle:
                  const TextStyle(fontSize: 14, fontFamily: 'RobotoRegular'),
              border: InputBorder.none),
        ),
      ),
    );
  }
}
