// ignore_for_file: use_build_context_synchronously, must_be_immutable, deprecated_member_use, sort_child_properties_last

import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:halenest/provider/user_provider.dart';
import 'package:halenest/resources/firestore_methods.dart';
import 'package:halenest/resources/status_methods.dart';
import 'package:halenest/screens/chat/chat_contact_list.dart';
import 'package:halenest/screens/navBar.dart';
import 'package:halenest/screens/social/blogs/reciepe.dart';
import 'package:halenest/screens/social/blogs/write_blog.dart';
import 'package:halenest/screens/social/feeds/feeds.dart';
import 'package:halenest/screens/social/feeds/search_screen.dart';
import 'package:halenest/screens/social/forums/forum.dart';
import 'package:halenest/screens/social/stories/confirmstoryscreen.dart';
import 'package:halenest/util/colors.dart';
import 'package:halenest/util/utils.dart';

import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class SocialScreen extends StatefulWidget {
  const SocialScreen({Key? key}) : super(key: key);

  @override
  State<SocialScreen> createState() => _SocialScreenState();
}

class _SocialScreenState extends State<SocialScreen> {
  List<XFile> multipleImages = [];

  Future<List<XFile>> multiImagePicker() async {
    List<XFile>? images = await ImagePicker().pickMultiImage();
    if (images.isNotEmpty) {
      return images;
    }
    return [];
  }

  //! UPLOAD STORY

  Uint8List? storyImage;

  selectImageForStories() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    // set state because we need to display the image we selected on the circle avatar
    setState(() {
      storyImage = im;
    });
    if (storyImage != null) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return ConfirmStoryUpload(file: storyImage!);
      }));
    }
  }

  bool isLoading = false;

  File? storyVideo;
  // Uint8List? storyPhoto;
  TextEditingController descriptionController = TextEditingController();
  TextEditingController questionController = TextEditingController();
  bool isFeedLoading = false;

  final List<File> _image = [];
  final picker = ImagePicker();
  Uint8List? blogThumbnail;

  selectStoryImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    // set state because we need to display the image we selected on the circle avatar
    setState(() {
      blogThumbnail = im;
    });
  }

  void uploadFeed(
      {required String email,
      required String uid,
      required String username,
      required String profilePhoto}) async {
    setState(() {
      isFeedLoading = true;
    });
    showSnackBar("Uploading", context);
    String res = await FirestoreMethods().uploadFeed(
        feedphoto: multipleImages,
        description: descriptionController.text,
        email: email,
        username: username,
        profilePhoto: profilePhoto,
        uid: uid);
    if (res != 'success') {
      showSnackBar(res, context);
    } else {
      showSnackBar('Posted!', context);
    }
    setState(() {
      isFeedLoading = false;
    });
  }

  void uploadQuestion(
      {required String email,
      required String uid,
      required String username,
      required String profilePhoto}) async {
    setState(() {
      isLoading = true;
    });

    String res = await FirestoreMethods().uploadQuestion(
        description: questionController.text,
        email: email,
        username: username,
        profilePhoto: profilePhoto,
        uid: uid);
    if (res != 'success') {
      showSnackBar(res, context);
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const ButtonNavBar(),
        ),
      );
      showSnackBar('Posted!', context);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
    descriptionController.dispose();
    questionController.dispose();
  }

  selectFeedImageFromGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _image.add(File(pickedFile!.path));
    });
    if (pickedFile?.path == null) retrieveLostData();
  }

  selectFeedImageFromCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    setState(() {
      _image.add(File(pickedFile!.path));
    });
    if (pickedFile?.path == null) retrieveLostData();
  }

  Future<void> retrieveLostData() async {
    final LostData response = await picker.getLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        _image.add(File(response.file!.path));
      });
    } else {
      print(response.file);
    }
  }

  showOptionsDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        children: [
          SimpleDialogOption(
            onPressed: () {
              selectFeedImageFromGallery();
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
              selectFeedImageFromCamera();
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
  Widget build(BuildContext context) {
    UserProvider user = Provider.of<UserProvider>(context);
    // UserModel user = Provider.of<UserProvider>(context).getUser;
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          backgroundColor: backgroundColor,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(130.h),
            child: AppBar(
              centerTitle: false,
              automaticallyImplyLeading: false,
              elevation: 0.2,
              backgroundColor: Colors.white,
              title: Padding(
                padding: EdgeInsets.only(bottom: 10.0.h),
                child: Text(
                  'Social',
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'RobotoRegular',
                    fontWeight: FontWeight.w500,
                    fontSize: 27.sp,
                  ),
                ),
              ),
              actions: [
                Padding(
                  padding: EdgeInsets.only(bottom: 10.0.h),
                  child: Row(
                    children: [
                      GestureDetector(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return const SearchScreen();
                            }));
                          },
                          child: SvgPicture.asset('assets/icons/search.svg')),
                      SizedBox(
                        width: 15.w,
                      ),
                      InkWell(
                          onTap: () {
                            showModalBottomSheet(
                                backgroundColor: Colors.transparent,
                                context: context,
                                builder: (context) {
                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                          height: 317.h,
                                          decoration: const BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                      top:
                                                          Radius.circular(20))),
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 20.0.h,
                                                horizontal: 38.w),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Publish Post',
                                                  style: TextStyle(
                                                    color:
                                                        const Color(0xff363636),
                                                    fontWeight: FontWeight.w600,
                                                    fontFamily: 'RobotoRegular',
                                                    fontSize: 16.sp,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 1.h,
                                                ),
                                                Text(
                                                  'Upload the photo that you want to post',
                                                  style: TextStyle(
                                                    color:
                                                        const Color(0xffBBBBBB),
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily: 'RobotoRegular',
                                                    fontSize: 12.sp,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 24.h,
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    Navigator.pop(context);
                                                    showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return Dialog(
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10.r)),
                                                            child: SizedBox(
                                                              height: 365.h,
                                                              width: double
                                                                  .infinity,
                                                              child: Padding(
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        vertical: 20
                                                                            .h,
                                                                        horizontal:
                                                                            13.w),
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      'Publish Post',
                                                                      style:
                                                                          TextStyle(
                                                                        color: const Color(
                                                                            0xff363636),
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                        fontFamily:
                                                                            'RobotoRegular',
                                                                        fontSize:
                                                                            16.sp,
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      height:
                                                                          1.h,
                                                                    ),
                                                                    Text(
                                                                      'Upload the photo that you want to post',
                                                                      style:
                                                                          TextStyle(
                                                                        color: const Color(
                                                                            0xffBBBBBB),
                                                                        fontWeight:
                                                                            FontWeight.w400,
                                                                        fontFamily:
                                                                            'RobotoRegular',
                                                                        fontSize:
                                                                            12.sp,
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      height:
                                                                          16.h,
                                                                    ),
                                                                    Container(
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      height:
                                                                          213.h,
                                                                      width: double
                                                                          .infinity,
                                                                      decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius.circular(5
                                                                              .r),
                                                                          border: Border.all(
                                                                              width: 1.w,
                                                                              color: const Color(0xffDDDEDF))),
                                                                      child:
                                                                          Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: [
                                                                          GestureDetector(
                                                                            onTap:
                                                                                () async {
                                                                              multipleImages = await multiImagePicker();
                                                                              if (multipleImages.isNotEmpty) {
                                                                                setState(() {});
                                                                              }
                                                                            },

                                                                            // showOptionsDialog(context),
                                                                            child:
                                                                                Container(
                                                                              alignment: Alignment.center,
                                                                              height: 60.h,
                                                                              width: 60.w,
                                                                              decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xffF7F8F9)),
                                                                              child: const Icon(
                                                                                Icons.add,
                                                                                color: Color(0xff9BABB6),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                33.h,
                                                                          ),
                                                                          Padding(
                                                                            padding:
                                                                                EdgeInsets.symmetric(horizontal: 60.w),
                                                                            child:
                                                                                Text(
                                                                              'Click add button to upload an image Note: max size is 1 MB',
                                                                              textAlign: TextAlign.center,
                                                                              style: TextStyle(
                                                                                color: const Color(0xffBBBBBB),
                                                                                fontWeight: FontWeight.w400,
                                                                                fontFamily: 'RobotoRegular',
                                                                                fontSize: 14.sp,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      height:
                                                                          11.h,
                                                                    ),
                                                                    GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        Navigator.pop(
                                                                            context);
                                                                        showDialog(
                                                                            context:
                                                                                context,
                                                                            builder:
                                                                                (context) {
                                                                              return Dialog(
                                                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                                                                                insetPadding: EdgeInsets.only(left: 13.w, right: 13.w),
                                                                                child: SizedBox(
                                                                                  width: double.infinity,
                                                                                  height: 239.h,
                                                                                  child: Padding(
                                                                                    padding: EdgeInsets.symmetric(horizontal: 11.w, vertical: 11.h),
                                                                                    child: Column(
                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                      children: [
                                                                                        Text(
                                                                                          'Publish Post',
                                                                                          style: TextStyle(
                                                                                            color: const Color(0xff363636),
                                                                                            fontWeight: FontWeight.w600,
                                                                                            fontFamily: 'RobotoRegular',
                                                                                            fontSize: 16.sp,
                                                                                          ),
                                                                                        ),
                                                                                        SizedBox(
                                                                                          height: 1.h,
                                                                                        ),
                                                                                        Text(
                                                                                          'Upload the photo that you want to post',
                                                                                          style: TextStyle(
                                                                                            color: const Color(0xffBBBBBB),
                                                                                            fontWeight: FontWeight.w400,
                                                                                            fontFamily: 'RobotoRegular',
                                                                                            fontSize: 12.sp,
                                                                                          ),
                                                                                        ),
                                                                                        SizedBox(
                                                                                          height: 17.h,
                                                                                        ),
                                                                                        Row(
                                                                                          children: [
                                                                                            Container(
                                                                                              height: 63.h,
                                                                                              width: 72.w,
                                                                                              child: Image.file(
                                                                                                File(multipleImages[0].path),
                                                                                                fit: BoxFit.cover,
                                                                                              ),
                                                                                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.r), border: Border.all(width: 1.w, color: const Color(0xffDDDEDF))),
                                                                                            ),
                                                                                            SizedBox(
                                                                                              width: 11.w,
                                                                                            ),
                                                                                            Container(
                                                                                              height: 63.h,
                                                                                              width: 282.w,
                                                                                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.r), border: Border.all(width: 1.w, color: const Color(0xffDDDEDF))),
                                                                                              child: TextField(
                                                                                                controller: descriptionController,
                                                                                                style: TextStyle(
                                                                                                  color: Colors.black,
                                                                                                  fontWeight: FontWeight.w400,
                                                                                                  fontFamily: 'RobotoRegular',
                                                                                                  fontSize: 14.sp,
                                                                                                ),
                                                                                                maxLines: 9999,
                                                                                                decoration: InputDecoration(
                                                                                                    hintText: 'write something...',
                                                                                                    hintStyle: TextStyle(
                                                                                                      color: const Color(0xffBBBBBB),
                                                                                                      fontWeight: FontWeight.w400,
                                                                                                      fontFamily: 'RobotoRegular',
                                                                                                      fontSize: 14.sp,
                                                                                                    ),
                                                                                                    border: InputBorder.none),
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                        SizedBox(
                                                                                          height: 8.h,
                                                                                        ),
                                                                                        Padding(
                                                                                          padding: EdgeInsets.only(left: 83.0.w),
                                                                                          child: Container(
                                                                                            height: 45.h,
                                                                                            width: 282.w,
                                                                                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.r), border: Border.all(width: 1.w, color: const Color(0xffDDDEDF))),
                                                                                            child: TextField(
                                                                                              style: TextStyle(
                                                                                                color: Colors.black,
                                                                                                fontWeight: FontWeight.w400,
                                                                                                fontFamily: 'RobotoRegular',
                                                                                                fontSize: 14.sp,
                                                                                              ),
                                                                                              maxLines: 9999,
                                                                                              decoration: InputDecoration(
                                                                                                  hintText: 'write tags eg. #fitness...',
                                                                                                  hintStyle: TextStyle(
                                                                                                    color: const Color(0xffBBBBBB),
                                                                                                    fontWeight: FontWeight.w400,
                                                                                                    fontFamily: 'RobotoRegular',
                                                                                                    fontSize: 14.sp,
                                                                                                  ),
                                                                                                  border: InputBorder.none),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                        SizedBox(
                                                                                          height: 13.h,
                                                                                        ),
                                                                                        Padding(
                                                                                          padding: EdgeInsets.only(left: 301.w),
                                                                                          child: GestureDetector(
                                                                                            onTap: () {
                                                                                              uploadFeed(email: user.getUser.email, uid: user.getUser.uid, username: user.getUser.username, profilePhoto: user.getUser.profilePhoto!);
                                                                                              Navigator.pop(context);
                                                                                            },
                                                                                            child: !isFeedLoading
                                                                                                ? Container(
                                                                                                    alignment: Alignment.center,
                                                                                                    height: 34.h,
                                                                                                    width: 88.w,
                                                                                                    decoration: BoxDecoration(color: primaryColor, borderRadius: BorderRadius.circular(4.r)),
                                                                                                    child: Text(
                                                                                                      'Post',
                                                                                                      style: TextStyle(fontFamily: 'RobotoRegular', fontSize: 14.sp, fontWeight: FontWeight.w500, color: Colors.white),
                                                                                                    ),
                                                                                                  )
                                                                                                : const CircularProgressIndicator(),
                                                                                          ),
                                                                                        )
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              );
                                                                            });
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        alignment:
                                                                            Alignment.center,
                                                                        height:
                                                                            46.h,
                                                                        width: double
                                                                            .infinity,
                                                                        decoration: BoxDecoration(
                                                                            color:
                                                                                primaryColor,
                                                                            borderRadius:
                                                                                BorderRadius.circular(6.r)),
                                                                        child:
                                                                            Text(
                                                                          'Move Forward',
                                                                          style: TextStyle(
                                                                              color: Colors.white,
                                                                              fontFamily: 'RobotoRegular',
                                                                              fontSize: 14.sp,
                                                                              fontWeight: FontWeight.w500),
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        });
                                                  },
                                                  child: Container(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    height: 44.h,
                                                    width: double.infinity,
                                                    decoration: BoxDecoration(
                                                        color: primaryColor,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(6.r)),
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 13.w),
                                                      child: Text(
                                                        'Post a picture',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontFamily:
                                                              'RobotoRegular',
                                                          fontSize: 14.sp,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 10.h,
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    Navigator.pop(context);
                                                    showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return Dialog(
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10.r)),
                                                            insetPadding:
                                                                EdgeInsets.only(
                                                                    left: 13.w,
                                                                    right:
                                                                        13.w),
                                                            child: SizedBox(
                                                              width: double
                                                                  .infinity,
                                                              height: 239.h,
                                                              child: Padding(
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        horizontal: 11
                                                                            .w,
                                                                        vertical:
                                                                            11.h),
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      'Ask question',
                                                                      style:
                                                                          TextStyle(
                                                                        color: const Color(
                                                                            0xff363636),
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                        fontFamily:
                                                                            'RobotoRegular',
                                                                        fontSize:
                                                                            16.sp,
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      height:
                                                                          1.h,
                                                                    ),
                                                                    Text(
                                                                      'Type hashtags in question to get better reach',
                                                                      style:
                                                                          TextStyle(
                                                                        color: const Color(
                                                                            0xffBBBBBB),
                                                                        fontWeight:
                                                                            FontWeight.w400,
                                                                        fontFamily:
                                                                            'RobotoRegular',
                                                                        fontSize:
                                                                            12.sp,
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      height:
                                                                          17.h,
                                                                    ),
                                                                    Container(
                                                                      height:
                                                                          97.h,
                                                                      width:
                                                                          351.w,
                                                                      decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius.circular(5
                                                                              .r),
                                                                          border: Border.all(
                                                                              width: 1.w,
                                                                              color: const Color(0xffDDDEDF))),
                                                                      child:
                                                                          TextField(
                                                                        controller:
                                                                            questionController,
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              Colors.black,
                                                                          fontWeight:
                                                                              FontWeight.w400,
                                                                          fontFamily:
                                                                              'RobotoRegular',
                                                                          fontSize:
                                                                              14.sp,
                                                                        ),
                                                                        maxLines:
                                                                            9999,
                                                                        decoration: InputDecoration(
                                                                            hintText: 'Ask your question...',
                                                                            hintStyle: TextStyle(
                                                                              color: const Color(0xffBBBBBB),
                                                                              fontWeight: FontWeight.w400,
                                                                              fontFamily: 'RobotoRegular',
                                                                              fontSize: 14.sp,
                                                                            ),
                                                                            border: InputBorder.none),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      height:
                                                                          15.h,
                                                                    ),
                                                                    Padding(
                                                                      padding: EdgeInsets.only(
                                                                          left:
                                                                              263.w),
                                                                      child:
                                                                          GestureDetector(
                                                                        //* add question method
                                                                        onTap: () => uploadQuestion(
                                                                            email:
                                                                                user.getUser.email,
                                                                            uid: user.getUser.uid,
                                                                            username: user.getUser.username,
                                                                            profilePhoto: user.getUser.profilePhoto!),
                                                                        child:
                                                                            Container(
                                                                          alignment:
                                                                              Alignment.center,
                                                                          height:
                                                                              34.h,
                                                                          width:
                                                                              88.w,
                                                                          decoration: BoxDecoration(
                                                                              color: primaryColor,
                                                                              borderRadius: BorderRadius.circular(4.r)),
                                                                          child: isLoading
                                                                              ? Text(
                                                                                  'Post',
                                                                                  style: TextStyle(fontFamily: 'RobotoRegular', fontSize: 14.sp, fontWeight: FontWeight.w500, color: Colors.white),
                                                                                )
                                                                              : const CircularProgressIndicator(),
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        });
                                                  },
                                                  child: Container(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    height: 44.h,
                                                    width: double.infinity,
                                                    decoration: BoxDecoration(
                                                        color: const Color(
                                                            0xffF7F8F9),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(6.r)),
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 13.w),
                                                      child: Text(
                                                        'Post a question',
                                                        style: TextStyle(
                                                          color: const Color(
                                                              0xff9BABB6),
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontFamily:
                                                              'RobotoRegular',
                                                          fontSize: 14.sp,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 10.h,
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    Navigator.pop(context);
                                                    Navigator.push(context,
                                                        MaterialPageRoute(
                                                            builder: (context) {
                                                      return const WriteBlog();
                                                    }));
                                                  },
                                                  child: Container(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    height: 44.h,
                                                    width: double.infinity,
                                                    decoration: BoxDecoration(
                                                        color: const Color(
                                                            0xffF7F8F9),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(6.r)),
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 13.w),
                                                      child: Text(
                                                        'Post a recepie',
                                                        style: TextStyle(
                                                          color: const Color(
                                                              0xff9BABB6),
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontFamily:
                                                              'RobotoRegular',
                                                          fontSize: 14.sp,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 10.h,
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return Dialog(
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10.r)),
                                                            insetPadding:
                                                                EdgeInsets.only(
                                                                    left: 13.w,
                                                                    right:
                                                                        13.w),
                                                            child: SizedBox(
                                                              width: double
                                                                  .infinity,
                                                              height: 365.h,
                                                              child: Padding(
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        horizontal: 11
                                                                            .w,
                                                                        vertical:
                                                                            11.h),
                                                                child: Column(
                                                                  children: [
                                                                    Text(
                                                                      'Publish Post',
                                                                      style:
                                                                          TextStyle(
                                                                        color: const Color(
                                                                            0xff363636),
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                        fontFamily:
                                                                            'RobotoRegular',
                                                                        fontSize:
                                                                            16.sp,
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      height:
                                                                          1.h,
                                                                    ),
                                                                    Text(
                                                                      'Upload the photo that you want to post',
                                                                      style:
                                                                          TextStyle(
                                                                        color: const Color(
                                                                            0xffBBBBBB),
                                                                        fontWeight:
                                                                            FontWeight.w400,
                                                                        fontFamily:
                                                                            'RobotoRegular',
                                                                        fontSize:
                                                                            12.sp,
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      height:
                                                                          16.h,
                                                                    ),
                                                                    Container(
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      height:
                                                                          213.h,
                                                                      width: double
                                                                          .infinity,
                                                                      decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius.circular(5
                                                                              .r),
                                                                          border: Border.all(
                                                                              width: 1.w,
                                                                              color: const Color(0xffDDDEDF))),
                                                                      child:
                                                                          Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: [
                                                                          InkWell(
                                                                            onTap:
                                                                                () {
                                                                              selectStoryImage();
                                                                            },
                                                                            child:
                                                                                Container(
                                                                              alignment: Alignment.center,
                                                                              height: 60.h,
                                                                              width: 60.w,
                                                                              decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xffF7F8F9)),
                                                                              child: const Icon(
                                                                                Icons.add,
                                                                                color: Color(0xff9BABB6),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                33.h,
                                                                          ),
                                                                          Padding(
                                                                            padding:
                                                                                EdgeInsets.symmetric(horizontal: 60.w),
                                                                            child:
                                                                                Text(
                                                                              'Click add button to upload an image Note: max size is 1 MB',
                                                                              textAlign: TextAlign.center,
                                                                              style: TextStyle(
                                                                                color: const Color(0xffBBBBBB),
                                                                                fontWeight: FontWeight.w400,
                                                                                fontFamily: 'RobotoRegular',
                                                                                fontSize: 14.sp,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      height:
                                                                          11.h,
                                                                    ),
                                                                    InkWell(
                                                                      onTap:
                                                                          () {
                                                                        if (blogThumbnail ==
                                                                            null) {
                                                                          StatusRepository(firestore: FirebaseFirestore.instance, auth: FirebaseAuth.instance).uploadStatus(
                                                                              username: user.getUser.username,
                                                                              profilePic: user.getUser.profilePhoto!,
                                                                              statusImage: blogThumbnail!,
                                                                              context: context);
                                                                        }
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        alignment:
                                                                            Alignment.center,
                                                                        height:
                                                                            46.h,
                                                                        width: double
                                                                            .infinity,
                                                                        decoration: BoxDecoration(
                                                                            color:
                                                                                primaryColor,
                                                                            borderRadius:
                                                                                BorderRadius.circular(6.r)),
                                                                        child:
                                                                            Text(
                                                                          'Upload',
                                                                          style: TextStyle(
                                                                              color: Colors.white,
                                                                              fontFamily: 'RobotoRegular',
                                                                              fontSize: 14.sp,
                                                                              fontWeight: FontWeight.w500),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        });
                                                  },
                                                  child: Container(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    height: 44.h,
                                                    width: double.infinity,
                                                    decoration: BoxDecoration(
                                                        color: const Color(
                                                            0xffF7F8F9),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(6.r)),
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 13.w),
                                                      child: Text(
                                                        'Post a story',
                                                        style: TextStyle(
                                                          color: const Color(
                                                              0xff9BABB6),
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontFamily:
                                                              'RobotoRegular',
                                                          fontSize: 14.sp,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )),
                                    ],
                                  );
                                });
                          },
                          child: SvgPicture.asset('assets/icons/upload.svg')),
                      SizedBox(
                        width: 15.w,
                      ),
                      InkWell(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return const ChatScreen();
                            }));
                          },
                          child: SvgPicture.asset('assets/icons/chat.svg')),
                      SizedBox(
                        width: 20.w,
                      )
                    ],
                  ),
                )
              ],
              bottom: TabBar(
                  labelPadding:
                      EdgeInsets.only(left: 0.w, right: 30.w, bottom: 20),
                  indicatorPadding:
                      EdgeInsets.only(left: 0.w, right: 30.w, bottom: 2),
                  indicator:
                      CircleTabIndicator(color: primaryColor, radius: 3.r),
                  isScrollable: false,
                  labelColor: primaryColor,
                  labelStyle: const TextStyle(fontSize: 16),
                  unselectedLabelColor: const Color(0xff555555),
                  tabs: const [
                    SizedBox(child: Text("Feeds")),
                    Text("Forum"),
                    Text("Blogs"),
                  ]),
            ),
          ),
          body: const TabBarView(children: [
            FeedsScreen(),
            ForumScreen(),
            RecepieScreen(),
          ])),
    );
  }
}

class CircleTabIndicator extends Decoration {
  final Color color;
  double radius;
  CircleTabIndicator({required this.color, required this.radius});
  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _CirclePainter(color: color, radius: radius);
  }
}

class _CirclePainter extends BoxPainter {
  final double radius;
  late Color color;
  _CirclePainter({required this.color, required this.radius});
  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration cfg) {
    late Paint paint;
    paint = Paint()..color = color;
    paint = paint..isAntiAlias = true;
    final Offset circleOffset =
        offset + Offset(cfg.size!.width / 2, cfg.size!.height - radius);
    canvas.drawCircle(circleOffset, radius, paint);
  }
}
