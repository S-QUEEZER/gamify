// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:halenest/login/signin.dart';
import 'package:halenest/login/verifyEmail.dart';
import 'package:halenest/resources/auth_methods.dart';
import 'package:halenest/screens/navBar.dart';
import 'package:halenest/util/colors.dart';
import 'package:halenest/util/terms.dart';
import 'package:halenest/util/utils.dart';
import 'package:halenest/widgets/textfield.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();
  final TextEditingController _usernamecontroller = TextEditingController();
  bool _isLoading = false;
  // Uint8List? photoUrl;

  void signupUser() async {
    setState(() {
      _isLoading = true;
    });
    if (isChecked == true) {
      try {
        String res = await AuthMethods().signUp(
            username: _usernamecontroller.text.trim(),
            email: _emailcontroller.text.trim(),
            password: _passwordcontroller.text.trim(),
            bio: '');
        if (res == "success") {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const VerifyEmail(fromSignUpScreen: true),
            ),
          );
        } else {
          showSnackBar(res, context);
        }
      } catch (error) {}
    } else {
      showSnackBar("Accept terms and conditions", context);
    }
    setState(() {
      _isLoading = false;
    });
  }

  void googleSignUp() async {
    if (isChecked == true) {
      try {
        String res = await AuthMethods().signInWithGoogle(context);

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const ButtonNavBar(),
          ),
        );
      } catch (error) {}
    } else {
      showSnackBar("Accept terms and conditions", context);
    }
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
  void dispose() {
    super.dispose();
    _emailcontroller.dispose();
    _passwordcontroller.dispose();
    _usernamecontroller.dispose();
  }

  bool? isChecked = false;

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
                padding: EdgeInsets.only(left: 133.w, right: 97.w),
                child: Container(
                  height: 192.h,
                  width: 198.w,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(
                            "assets/images/login_illustration.png",
                          ),
                          fit: BoxFit.cover)),
                ),
              ),
              SizedBox(
                height: 49.h,
              ),
              TextFieldContainer(
                hinttext: 'User Name',
                controller: _usernamecontroller,
                textInputType: TextInputType.text,
              ),
              SizedBox(
                height: 20.h,
              ),
              TextFieldContainer(
                hinttext: 'Email Address',
                controller: _emailcontroller,
                isPass: false,
                textInputType: TextInputType.emailAddress,
              ),
              SizedBox(
                height: 20.h,
              ),
              TextFieldContainer(
                isPass: true,
                hinttext: 'Password',
                controller: _passwordcontroller,
                textInputType: TextInputType.text,
              ),
              SizedBox(
                height: 20.h,
              ),
              Padding(
                padding: EdgeInsets.only(left: 20.0.w),
                child: SizedBox(
                  child: Row(
                    children: [
                      Checkbox(
                          activeColor: primaryColor,
                          value: isChecked,
                          onChanged: (newbool) {
                            setState(() {
                              isChecked = newbool;
                            });
                          }),
                      // SizedBox(
                      //   width: 10.w,
                      // ),
                      Row(
                        children: [
                          Text(
                            "I agree to the",
                            style: TextStyle(
                                color: const Color(0xffB5B5B5),
                                fontFamily: 'RobotoRegular',
                                fontWeight: FontWeight.w400,
                                fontSize: 14.sp),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return const TermsAndConditions();
                              }));
                            },
                            child: Text(
                              "Terms and Conditions",
                              style: TextStyle(
                                  color: primaryColor,
                                  fontFamily: 'RobotoRegular',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14.sp),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 34.0.w),
                child: GestureDetector(
                  //* signup user
                  onTap: signupUser,
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
                            "Let's Sign up now",
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
                height: 38.h,
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
                height: 34.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 53.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () {
                        googleSignUp();
                      },
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
                    // SizedBox(
                    //   width: 35.w,
                    // ),
                    // InkWell(
                    //   onTap: () {
                    //     facebookSignUp();
                    //   },
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
                    // SizedBox(
                    //   width: 35.w,
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
                height: 20.h,
              ),
              GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignInScreen()));
                    // ? navigate to the sign up screen
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account? ',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: const Color(0xff453E4E),
                            fontSize: 14.sp,
                            fontFamily: 'RobotoRegular'),
                      ),
                      Text(
                        'Sign in',
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
