// ignore_for_file: unnecessary_null_comparison

import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:halenest/models/status_model.dart';
import 'package:halenest/provider/user_provider.dart';
import 'package:halenest/resources/status_methods.dart';
import 'package:halenest/screens/social/stories/confirmstoryscreen.dart';
import 'package:halenest/screens/social/stories/stories.dart';
import 'package:halenest/util/colors.dart';
import 'package:halenest/util/utils.dart';
import 'package:halenest/widgets/feedswidget.dart';
import 'package:halenest/widgets/stories_widget.dart';

import 'package:image_picker/image_picker.dart';

import 'package:provider/provider.dart';

class FeedsScreen extends StatefulWidget {
  const FeedsScreen({Key? key}) : super(key: key);

  @override
  State<FeedsScreen> createState() => _FeedsScreenState();
}

class _FeedsScreenState extends State<FeedsScreen> {
  //! UPLOAD STORY
  Uint8List? storyImage;

  selectImageForStories() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    // set state because we need to display the image we selected on the circle avatar
    setState(() {
      storyImage = im;
    });
    if (storyImage != null) {
      // ignore: use_build_context_synchronously
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return ConfirmStoryUpload(file: storyImage!);
      }));
    }
  }

  selectImageForStoriesCamera() async {
    Uint8List im = await pickImage(ImageSource.camera);
    // set state because we need to display the image we selected on the circle avatar
    setState(() {
      storyImage = im;
    });
    if (storyImage != null) {
      // ignore: use_build_context_synchronously
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return ConfirmStoryUpload(file: storyImage!);
      }));
    }
  }

  showOptionsDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        children: [
          SimpleDialogOption(
            onPressed: () {
              selectImageForStories();
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
              selectImageForStoriesCamera();
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

  Future<List<Status>> getStatus(
    BuildContext context,
  ) async {
    List<Status> statuses = await StatusRepository(
            auth: FirebaseAuth.instance, firestore: FirebaseFirestore.instance)
        .getStatus(
      context,
    );
    return statuses;
  }

  @override
  Widget build(BuildContext context) {
    UserProvider user = Provider.of<UserProvider>(context);
    return SingleChildScrollView(
      child: Column(
        children: [
          FutureBuilder<List<Status>>(
            future: getStatus(
              context,
            ),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              return (snapshot.hasData)
                  ? Container(
                      color: Colors.white,
                      // width: double.infinity,
                      height: 98.h,
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 18.0.w),
                            child: InkWell(
                              onTap: () {
                                showOptionsDialog(context);
                              },
                              child: Stack(children: [
                                Container(
                                  height: 64.h,
                                  width: 64.w,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Container(
                                      height: 60.h,
                                      width: 60.w,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              width: 2, color: Colors.white),
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                  user.getUser.profilePhoto!),
                                              fit: BoxFit.cover)),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: 100,
                                  left: 32,
                                  top: 35,
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 15,
                                    width: 15,
                                    color: Colors.blue,
                                    child: const Icon(
                                      Icons.add,
                                      size: 25,
                                      color: primaryColor,
                                    ),
                                  ),
                                )
                              ]),
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                                itemCount: snapshot.data!.length,
                                scrollDirection: Axis.horizontal,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  var statusData = snapshot.data![index];
                                  if (user.getUser.following
                                      .contains(statusData.uid)) {
                                    return InkWell(
                                      onTap: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return StatusScreen(
                                              status: statusData);
                                        }));
                                      },
                                      child: StoriesWidget(
                                        imageurl: statusData.profilePic,
                                        name: statusData.username,
                                      ),
                                    );
                                  } else {
                                    return Container();
                                  }
                                }),
                          ),
                        ],
                      ),
                    )
                  : Container();
            },
          ),

          Divider(color: dividerColor, height: 2.h),
          SizedBox(
            height: 14.h,
          ),
          //* Feeds Widget
          StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('feeds')
                  .orderBy("datetime", descending: true)
                  .limit(200)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                if (streamSnapshot.hasData) {
                  return ListView.builder(
                      scrollDirection: Axis.vertical,
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: streamSnapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final DocumentSnapshot documentSnapshot =
                            streamSnapshot.data!.docs[index];

                        return FeedsWidget(
                          bio: '',
                          postUid: documentSnapshot['uid'],
                          likes: documentSnapshot['likes'],
                          commenterProfileImg: user.getUser.profilePhoto!,
                          postId: documentSnapshot['postId'],
                          caption: documentSnapshot['description'],
                          likedBy: 'abc',
                          name: documentSnapshot['username'],
                          postImg: documentSnapshot['feedphoto'],
                          profileImg: documentSnapshot['profilePhoto'],
                          timeAgo: documentSnapshot['datetime'].toString(),
                          commentCount: '232', commentername: '',
                          // commentername: '',
                        );
                      });
                } else {
                  return const CircularProgressIndicator();
                }
              })
        ],
      ),
    );
  }
}
