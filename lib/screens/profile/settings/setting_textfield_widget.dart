import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SettingTextFieldWidget extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final String textfieldhead;
  final bool isPassword;

  const SettingTextFieldWidget(
      {Key? key,
      required this.hintText,
      required this.textfieldhead,
      required this.controller,
      required this.isPassword})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          textfieldhead,
          style: TextStyle(
              fontFamily: 'RobotoRegular',
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xff4A6783)),
        ),
        SizedBox(
          height: 11.h,
        ),
        Container(
          height: 56.h,
          width: double.infinity,
          decoration: BoxDecoration(
              border: Border.all(width: 1.w, color: const Color(0xffCFD9E2)),
              borderRadius: BorderRadius.circular(5.r),
              color: const Color(0xffF7F8F9)),
          child: TextField(
            controller: controller,
            obscureText: isPassword,
            decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 20.w),
                hintText: hintText,
                border: InputBorder.none,
                hintStyle: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'RobotoRegular',
                    color: const Color(0xff9BABB6))),
          ),
        )
      ],
    );
  }
}
