// ignore_for_file: empty_catches

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:halenest/util/colors.dart';
import 'package:halenest/util/utils.dart';
import 'package:halenest/widgets/textfield.dart';

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
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(),
      ),
      body: Column(
        children: [
          Container(
            height: 320,
            width: 320,
            color: primaryColor,
          ),
          TextFieldContainer(
            hinttext: 'Email Address',
            controller: _emailcontroller,
            textInputType: TextInputType.emailAddress,
          ),
          SizedBox(
            height: 100.h,
          ),
          InkWell(
            onTap: () async {
              if (_emailcontroller.text.isNotEmpty) {
                try {
                  await FirebaseAuth.instance
                      .sendPasswordResetEmail(email: _emailcontroller.text);
                  // showSnackBar("Request sent", context);
                  // Navigator.pop(context);
                } on FirebaseAuthException catch (e) {
                  showSnackBar(e.toString(), context);
                }
              }
            },
            child: Container(
              alignment: Alignment.center,
              width: double.infinity,
              height: 50.h,
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: const Text("SEND"),
            ),
          )
        ],
      ),
    );
  }
}
