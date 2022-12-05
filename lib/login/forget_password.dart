// ignore_for_file: empty_catches

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:halenest/util/colors.dart';
import 'package:halenest/util/utils.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({Key? key}) : super(key: key);

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final TextEditingController _emailcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back_ios_new,
              color: Color(0xff181725),
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 50.h,
              ),
              Text(
                "Enter Email",
                style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'SourceSansPro-Regular',
                    color: const Color(0xff181725)),
              ),
              SizedBox(
                height: 17.w,
              ),
              Container(
                height: 59.h,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7.r),
                    border: Border.all(color: dividerColor, width: 1.w)),
                child: TextField(
                  controller: _emailcontroller,
                  cursorColor: primaryColor,
                  decoration: InputDecoration(
                      hintStyle: TextStyle(
                          fontFamily: 'RobotoRegular',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xff7C7C7C)),
                      contentPadding: EdgeInsets.only(left: 16.w, top: 18.h),
                      hintText: 'Email address..',
                      suffixIcon: const Icon(
                        Icons.mail_outline,
                        color: primaryColor,
                      ),
                      border: InputBorder.none),
                ),
              )
            ],
          ),
        ),
        floatingActionButton: InkWell(
          onTap: () async {
            if (_emailcontroller.text.isNotEmpty) {
              try {
                await FirebaseAuth.instance
                    .sendPasswordResetEmail(email: _emailcontroller.text);
                showSnackBar("Request sent", context);
                Navigator.pop(context);
              } on FirebaseAuthException catch (e) {
                showSnackBar(e.code.toString(), context);
              }
            }
          },
          child: Container(
            height: 54.h,
            width: 54.w,
            decoration: const BoxDecoration(
                shape: BoxShape.circle, color: primaryColor),
            child: const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
            ),
          ),
        ));
  }
}
