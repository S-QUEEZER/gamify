import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:halenest/login/uploadpfp.dart';
import 'package:halenest/screens/navBar.dart';
import 'package:halenest/util/colors.dart';

class VerifyEmail extends StatefulWidget {
  final bool fromSignUpScreen;
  const VerifyEmail({Key? key, required this.fromSignUpScreen})
      : super(key: key);

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  Timer? timer;
  bool isEmailVerified = false;
  bool canResend = true;

  @override
  void initState() {
    super.initState();
    //* user needs to be created before.
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    if (!isEmailVerified) {
      sendVerificationEmail();
      timer = Timer.periodic(
          const Duration(seconds: 2), (_) => checkEmailVerficiation());
    }
  }

  Future sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();
      setState(() {
        canResend = false;
      });
      await Future.delayed(const Duration(seconds: 2));
      setState(() {
        canResend = true;
      });
    } catch (error) {
      print(error);
    }
  }

  Future checkEmailVerficiation() async {
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });
    if (isEmailVerified) timer?.cancel();
  }

  Future deleteAccount() async {
    final user = FirebaseAuth.instance.currentUser!;
    await FirebaseFirestore.instance.collection('users').doc(user.uid).delete();
    await user.delete();
    await FirebaseAuth.instance.signOut();
    Navigator.pop(context);
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  }

  @override
  Widget build(BuildContext context) => isEmailVerified
      ? widget.fromSignUpScreen
          ? const UploadPhotoScreen()
          : const ButtonNavBar()
      : Scaffold(
          body: Container(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 70.w, right: 87.92.w),
                    child: Container(
                      height: 240.31.h,
                      width: 248.08.w,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("assets/images/verify.png"))),
                    ),
                  ),
                  const SizedBox(
                    height: 66.67,
                  ),
                  Text(
                    "Verify Email",
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'SourceSansPro-Bold',
                        fontWeight: FontWeight.w700,
                        fontSize: 40.sp),
                  ),
                  SizedBox(
                    height: 38.h,
                  ),
                  Text(
                    "Click the link that we have sent on you email.Please check in you spam folder also",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: const Color(0xff7C7C7C),
                        fontFamily: 'SourceSansPro-Regular',
                        fontWeight: FontWeight.w400,
                        fontSize: 16.sp),
                  ),
                  SizedBox(
                    height: 134.h,
                  ),
                  InkWell(
                    onTap: () {
                      deleteAccount();
                    },
                    child: Container(
                      height: 67.h,
                      width: double.infinity,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(63.r)),
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                            fontSize: 18.sp,
                            color: Colors.white,
                            fontFamily: "GilroyBold"),
                      ),
                    ),
                  )
                  // TextButton(
                  //   onPressed: () {
                  //     setState(() {
                  //       isEmailVerified = true;
                  //     });
                  //   },
                  //   child: const Text("Re Send"),
                  // ),
                  // TextButton(
                  //   onPressed: () {
                  //     deleteAccount();
                  //   },
                  //   child: const Text("Cancel"),
                  // )
                ],
              ),
            ),
          ),
        );
}
