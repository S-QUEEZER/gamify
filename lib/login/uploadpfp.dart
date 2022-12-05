// ignore_for_file: use_build_context_synchronously

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:halenest/resources/auth_methods.dart';
import 'package:halenest/screens/navBar.dart';
import 'package:halenest/util/colors.dart';
import 'package:halenest/util/utils.dart';

import 'package:image_picker/image_picker.dart';

class UploadPhotoScreen extends StatefulWidget {
  const UploadPhotoScreen({Key? key}) : super(key: key);

  @override
  State<UploadPhotoScreen> createState() => _UploadPhotoScreenState();
}

class _UploadPhotoScreenState extends State<UploadPhotoScreen> {
  Uint8List? _image;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    void uploadPfp() async {
      // set loading to true
      setState(() {
        isLoading = true;
      });

      // signup user using our authmethodds
      String res = await AuthMethods().uploadPhoto(file: _image!);
      // if string returned is sucess, user has been created
      if (res == "success") {
        setState(() {
          isLoading = false;
        });
        // navigate to the home screen
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const ButtonNavBar()),
        );
      } else {
        setState(() {
          isLoading = false;
        });
        // show the error
        showSnackBar(res, context);
      }
    }

    void skipPfp() async {
      // set loading to true
      setState(() {
        isLoading = true;
      });

      // signup user using our authmethodds
      String res = await AuthMethods().skipPhoto();
      // if string returned is sucess, user has been created
      if (res == "success") {
        setState(() {
          isLoading = false;
        });
        // navigate to the home screen
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const ButtonNavBar()),
        );
      } else {
        setState(() {
          isLoading = false;
        });
        // show the error
        showSnackBar(res, context);
      }
    }

    selectImage() async {
      Uint8List im = await pickImage(ImageSource.gallery);
      // set state because we need to display the image we selected on the circle avatar
      setState(() {
        _image = im;
      });
    }

    // UserProvider user = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 15.0.w),
            child: InkWell(
              onTap: () => skipPfp(),
              child: const Text(
                'SKIP',
                style: TextStyle(color: primaryColor),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 25.w, right: 20.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Upload your profile picture',
              style: TextStyle(
                  color: const Color(0xff181725),
                  fontFamily: 'RobotoRegular',
                  fontSize: 26.sp,
                  fontWeight: FontWeight.w400),
            ),
            SizedBox(
              height: 83.h,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Stack(
                  children: [
                    _image != null
                        ? CircleAvatar(
                            radius: 64,
                            backgroundImage: MemoryImage(_image!),
                            backgroundColor: Colors.red,
                          )
                        : const CircleAvatar(
                            radius: 64,
                            backgroundImage: NetworkImage(
                                'https://i.stack.imgur.com/l60Hf.png'),
                            backgroundColor: Colors.red,
                          ),
                    Positioned(
                      bottom: -10,
                      left: 80,
                      child: IconButton(
                        onPressed: selectImage,
                        icon: const Icon(Icons.add_a_photo),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 183.h,
                ),
                GestureDetector(
                  onTap: () => uploadPfp(),
                  child: Container(
                    alignment: Alignment.center,
                    height: 58.h,
                    width: 359.w,
                    decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(14.r)),
                    child: isLoading == true
                        ? Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            'Set profile picture',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'ArialBold',
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
