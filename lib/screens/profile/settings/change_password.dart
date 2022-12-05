// ignore_for_file: use_build_context_synchronously

import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:halenest/provider/user_provider.dart';
import 'package:halenest/screens/profile/settings/setting_textfield_widget.dart';
import 'package:halenest/util/utils.dart';

import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../resources/auth_methods.dart';

class PasswordChangeScreen extends StatefulWidget {
  const PasswordChangeScreen({Key? key}) : super(key: key);

  @override
  State<PasswordChangeScreen> createState() => _PasswordChangeScreenState();
}

class _PasswordChangeScreenState extends State<PasswordChangeScreen> {
  bool isLoading = false;
  Uint8List? _image;

  Future<bool> _changePassword(
      String currentPassword, String newPassword) async {
    bool success = false;

    //Create an instance of the current user.
    var user = FirebaseAuth.instance.currentUser!;
    //Must re-authenticate user before updating the password. Otherwise it may fail or user get signed out.

    final cred = EmailAuthProvider.credential(
        email: user.email!, password: currentPassword);
    await user.reauthenticateWithCredential(cred).then((value) async {
      await user.updatePassword(newPassword).then((_) {
        success = true;
        showSnackBar('Password Changed', context);
      }).catchError((error) {
        print(error);
      });
    }).catchError((err) {
      showSnackBar(err.toString(), context);
    });

    return success;
  }

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

  final TextEditingController newpassword = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController confirmpassword = TextEditingController();
  final user = FirebaseAuth.instance.currentUser!;
  final userDetails = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid);

  @override
  Widget build(BuildContext context) {
    UserProvider user = Provider.of<UserProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Change Password',
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
                isPassword: true,
                hintText: 'Enter your current Password',
                textfieldhead: 'Old Password',
                controller: password,
              ),
              SizedBox(
                height: 31.h,
              ),
              SettingTextFieldWidget(
                isPassword: true,
                hintText: 'Enter a new password',
                textfieldhead: 'New Password',
                controller: newpassword,
              ),
              SizedBox(
                height: 31.h,
              ),
              GestureDetector(
                  onTap: () {
                    _changePassword(password.text, newpassword.text);
                  },
                  child: const Text("Change password"))
            ],
          ),
        ),
      ),
    );
  }
}
