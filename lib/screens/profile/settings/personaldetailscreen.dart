// ignore_for_file: use_build_context_synchronously

import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:halenest/provider/user_provider.dart';
import 'package:halenest/resources/auth_methods.dart';
import 'package:halenest/screens/profile/settings/change_password.dart';
import 'package:halenest/screens/profile/settings/setting_textfield_widget.dart';
import 'package:halenest/screens/profile/settings/setting_widget.dart';
import 'package:halenest/util/utils.dart';

import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class PesonalDetailScreen extends StatefulWidget {
  const PesonalDetailScreen({Key? key}) : super(key: key);

  @override
  State<PesonalDetailScreen> createState() => _PesonalDetailScreenState();
}

class _PesonalDetailScreenState extends State<PesonalDetailScreen> {
  bool isLoading = false;
  Uint8List? _image;
  void uploadPfp() async {
    // set loading to true
    try {
      if (_image != null) {
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
          showSnackBar('Profile Picture Changed', context);
        } else {
          setState(() {
            isLoading = false;
          });
          // show the error
          showSnackBar(res, context);
        }
      }
    } catch (error) {
      showSnackBar("Some error occured", context);
    }
  }

  selectImageFromGallery() async {
    Uint8List im = await pickImage(
      ImageSource.gallery,
    );
    // set state because we need to display the image we selected on the circle avatar
    setState(() {
      _image = im;
    });

    try {
      if (_image != null) {
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
          showSnackBar('Profile Picture Changed', context);
        } else {
          setState(() {
            isLoading = false;
          });
          // show the error
          showSnackBar(res, context);
        }
      }
    } catch (error) {
      showSnackBar("Some error occured", context);
    }
  }

  selectImageFromCamera() async {
    Uint8List im = await pickImage(
      ImageSource.camera,
    );
    // set state because we need to display the image we selected on the circle avatar
    setState(() {
      _image = im;
    });

    try {
      if (_image != null) {
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
          showSnackBar('Profile Picture Changed', context);
        } else {
          setState(() {
            isLoading = false;
          });
          // show the error
          showSnackBar(res, context);
        }
      }
    } catch (error) {
      showSnackBar("Some error occured", context);
    }
  }

  showOptionsDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        children: [
          SimpleDialogOption(
            onPressed: () {
              selectImageFromGallery();
              Navigator.pop(context);
            },
            child: Row(
              children: const [
                Icon(Icons.image),
                Padding(
                  padding: EdgeInsets.all(7.0),
                  child: Text(
                    'Gallery',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
          SimpleDialogOption(
            onPressed: () {
              selectImageFromCamera();
              Navigator.pop(context);
            },
            child: Row(
              children: const [
                Icon(Icons.camera_alt),
                Padding(
                  padding: EdgeInsets.all(7.0),
                  child: Text(
                    'Camera',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.of(context).pop(),
            child: Row(
              children: const [
                Icon(Icons.cancel),
                Padding(
                  padding: EdgeInsets.all(7.0),
                  child: Text(
                    'Cancel',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  final TextEditingController passwordcontroller = TextEditingController();
  final TextEditingController usernamecontroller = TextEditingController();
  final TextEditingController biocontroller = TextEditingController();
  final user = FirebaseAuth.instance.currentUser!;
  final userDetails = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid);
  changeDetails(
      String bio, String newBio, String username, String newUsername) {
    if (newBio == bio) {
    } else {
      userDetails.update({"bio": newBio});
    }
    if (newUsername == username) {
    } else {
      userDetails.update({"username": newUsername});
    }
  }

  @override
  Widget build(BuildContext context) {
    UserProvider user = Provider.of<UserProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Personal Details',
          style: TextStyle(
              color: const Color(0xff002851),
              fontFamily: 'RobotoRegular',
              fontSize: 18.sp,
              fontWeight: FontWeight.w500),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Color(0xff002851),
            )),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.0.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  showOptionsDialog(context);
                },
                child: Container(
                  height: 69.h,
                  width: 69.w,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      image: DecorationImage(
                          image: NetworkImage(user.getUser.profilePhoto!),
                          fit: BoxFit.cover)),
                ),
              ),
              SizedBox(
                height: 59.h,
              ),
              SettingTextFieldWidget(
                isPassword: false,
                hintText: user.getUser.username,
                textfieldhead: 'Username',
                controller: usernamecontroller,
              ),
              SizedBox(
                height: 31.h,
              ),
              SettingTextFieldWidget(
                isPassword: false,
                hintText: user.getUser.bio! == "" ? "Bio" : user.getUser.bio!,
                textfieldhead: 'Bio',
                controller: biocontroller,
              ),
              SizedBox(
                height: 31.h,
              ),
              InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const PasswordChangeScreen();
                    }));
                  },
                  child: const SettingWidget(settingname: "Change Password")),
              GestureDetector(
                  onTap: () {
                    changeDetails(user.getUser.bio!, biocontroller.text,
                        user.getUser.username, usernamecontroller.text);
                    Navigator.pop(context);
                  },
                  child: const Text("Save Details"))
            ],
          ),
        ),
      ),
    );
  }
}
