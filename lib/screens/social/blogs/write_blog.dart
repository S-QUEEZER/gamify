// ignore_for_file: use_build_context_synchronously

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:halenest/models/user_model.dart';
import 'package:halenest/provider/user_provider.dart';
import 'package:halenest/resources/firestore_methods.dart';
import 'package:halenest/screens/navBar.dart';
import 'package:halenest/util/colors.dart';
import 'package:halenest/util/utils.dart';


import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class WriteBlog extends StatefulWidget {
  const WriteBlog({Key? key}) : super(key: key);

  @override
  State<WriteBlog> createState() => _WriteBlogState();
}

class _WriteBlogState extends State<WriteBlog> {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  bool isLoading = false;
  Uint8List? blogThumbnail;

  void uploadBlog(
      {required String username,
      required String uid,
      required String profilePhoto,
      required String email}) async {
    setState(() {
      isLoading = true;
    });
    String res = await FirestoreMethods().uploadBlog(
        feedphoto: blogThumbnail!,
        description: contentController.text,
        email: email,
        username: username,
        title: titleController.text,
        profilePhoto: profilePhoto,
        uid: uid);
    if (res != 'success') {
      showSnackBar(res, context);
      setState(() {
        isLoading = false;
      });
    } else {
      isLoading = false;
      clearImage();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const ButtonNavBar(),
        ),
      );
      showSnackBar('Posted!', context);
    }
  }

  void clearImage() {
    setState(() {
      blogThumbnail = null;
    });
  }

  selectImageFromGallery() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    // set state because we need to display the image we selected on the circle avatar
    setState(() {
      blogThumbnail = im;
    });
  }

  selectImageFromCamera() async {
    Uint8List im = await pickImage(ImageSource.camera);
    // set state because we need to display the image we selected on the circle avatar
    setState(() {
      blogThumbnail = im;
    });
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

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    contentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserModel user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 40.0.h, right: 20.w, left: 20.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              isLoading
                  ? const LinearProgressIndicator(
                      color: primaryColor,
                    )
                  : Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: TextField(
                        controller: titleController,
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          letterSpacing: 0.2,
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Title",
                            hintStyle: TextStyle(
                                color: const Color(0xffBBBBBB),
                                fontFamily: 'RobotoRegular',
                                fontSize: 23.sp,
                                fontWeight: FontWeight.w400)),
                        scrollPadding: const EdgeInsets.all(20.0),
                        keyboardType: TextInputType.multiline,
                      ),
                    ),
              SizedBox(
                  height: 631,
                  child: TextField(
                    controller: contentController,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Write your recepie...",
                        hintStyle: TextStyle(
                            color: const Color(0xffBBBBBB),
                            fontFamily: 'RobotoRegular',
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w400)),
                    scrollPadding: const EdgeInsets.all(20.0),
                    keyboardType: TextInputType.multiline,
                    maxLines: 99999,
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: () => showOptionsDialog(context),
                      icon: SvgPicture.asset('assets/icons/attachment.svg')),
                  Row(
                    children: [
                      SizedBox(
                        width: 7.w,
                      ),
                      GestureDetector(
                        onTap: () {
                          if (blogThumbnail != null) {
                            uploadBlog(
                                username: user.username,
                                uid: user.uid,
                                profilePhoto: user.profilePhoto!,
                                email: user.email);
                          } else {
                            showSnackBar("Select an Image", context);
                          }
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: 88.h,
                          height: 34.w,
                          decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(4.r)),
                          child: Text(
                            'Post',
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'RobotoRegular',
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
      resizeToAvoidBottomInset: true,
    );
  }
}
