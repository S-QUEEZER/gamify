// ignore_for_file: unused_field, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:halenest/login/forgetPassword.dart';
import 'package:halenest/login/signup.dart';
import 'package:halenest/login/verifyEmail.dart';
import 'package:halenest/resources/auth_methods.dart';
import 'package:halenest/screens/navBar.dart';
import 'package:halenest/util/colors.dart';
import 'package:halenest/util/utils.dart';
import 'package:halenest/widgets/textfield.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();
  bool _isLoading = false;
  @override
  void dispose() {
    super.dispose();
    _emailcontroller.dispose();
    _passwordcontroller.dispose();
  }

  void loginUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().signin(
        email: _emailcontroller.text, password: _passwordcontroller.text);
    bool isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    print(isEmailVerified);
    if (isEmailVerified == true) {
      if (res == 'success') {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const VerifyEmail(fromSignUpScreen: false),
            ),
            (route) => false);

        setState(() {
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
        showSnackBar(res, context);
      }
    } else {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => const VerifyEmail(fromSignUpScreen: true),
      ));
    }
  }

  void googleSignUp() async {
    try {
      String res = await AuthMethods().signInWithGoogle(context);

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const ButtonNavBar(),
        ),
      );
    } catch (error) {}
  }

  void facebookSignUp() async {
    try {
      String res = await AuthMethods().signInWithFacebook(context);
      if (res == "success") {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const ButtonNavBar(),
          ),
        );
      } else {
        showSnackBar(res, context);
      }
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 32.0.h, bottom: 31.h),
                child: Center(
                  child: Text(
                    "Hello!",
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 23.sp,
                        fontFamily: 'RobotoRegular'),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 74.w, right: 87.w),
                child: Container(
                  height: 222.h,
                  width: 266.w,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(
                              "assets/images/login_illustration.png"))),
                ),
              ),
              SizedBox(
                height: 49.h,
              ),
              TextFieldContainer(
                hinttext: 'Email Address',
                controller: _emailcontroller,
                textInputType: TextInputType.emailAddress,
              ),
              SizedBox(
                height: 20.h,
              ),
              TextFieldContainer(
                hinttext: 'Password',
                controller: _passwordcontroller,
                isPass: true,
                textInputType: TextInputType.text,
              ),
              SizedBox(
                height: 18.h,
              ),
              Padding(
                padding: EdgeInsets.only(left: 250.w, right: 30.w),
                child: InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const ForgetPassword();
                    }));
                  },
                  child: Text(
                    'Recover Password',
                    style: TextStyle(
                        color: primaryColor,
                        fontSize: 14.sp,
                        fontFamily: 'HelveticaRegular'),
                  ),
                ),
              ),
              SizedBox(
                height: 53.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 34.0.w),
                child: GestureDetector(
                  onTap: loginUser,
                  child: Container(
                    alignment: Alignment.center,
                    height: 58.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(7.r),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : Text(
                            "Let's Sign in now",
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 16.sp,
                                color: Colors.white,
                                fontFamily: 'ArialBold'),
                          ),
                  ),
                ),
              ),
              SizedBox(
                height: 48.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.w),
                child: Row(
                  children: [
                    const Image(image: AssetImage("assets/images/left.png")),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                      child: Text(
                        "Or continue with",
                        style: TextStyle(
                            fontFamily: "RobotoRegular", fontSize: 14.sp),
                      ),
                    ),
                    const Image(image: AssetImage("assets/images/right.png"))
                  ],
                ),
              ),
              SizedBox(
                height: 44.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 53.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: googleSignUp,
                      child: Container(
                        height: 59.h,
                        width: 84.w,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7.r),
                            border: Border.all(
                                color: const Color(0xffD3D3D3),
                                width: 1.w,
                                style: BorderStyle.solid),
                            image: const DecorationImage(
                                image: AssetImage("assets/images/google.png"))),
                      ),
                    ),
                    // InkWell(
                    //   onTap: facebookSignUp,
                    //   child: Container(
                    //     height: 59.h,
                    //     width: 84.w,
                    //     decoration: BoxDecoration(
                    //         borderRadius: BorderRadius.circular(7.r),
                    //         border: Border.all(
                    //             color: const Color(0xffD3D3D3),
                    //             width: 1.w,
                    //             style: BorderStyle.solid),
                    //         image: const DecorationImage(
                    //             image:
                    //                 AssetImage("assets/images/facebook.png"))),
                    //   ),
                    // ),
                    // Container(
                    //   height: 59.h,
                    //   width: 84.w,
                    //   decoration: BoxDecoration(
                    //       borderRadius: BorderRadius.circular(7.r),
                    //       border: Border.all(
                    //           color: const Color(0xffD3D3D3),
                    //           width: 1.w,
                    //           style: BorderStyle.solid),
                    //       image: const DecorationImage(
                    //           image: AssetImage("assets/images/apple.png"))),
                    // )
                  ],
                ),
              ),
              SizedBox(
                height: 40.h,
              ),
              GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignUpScreen()));
                    // ? navigate to the sign up screen
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Dont have an account? ',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: const Color(0xff453E4E),
                            fontSize: 14.sp,
                            fontFamily: 'RobotoRegular'),
                      ),
                      Text(
                        'Create now',
                        style: TextStyle(
                            color: primaryColor,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'HelveticaRegular'),
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
