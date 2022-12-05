// ignore_for_file: use_build_context_synchronously, unused_field, avoid_unnecessary_containers

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:halenest/provider/user_provider.dart';
import 'package:halenest/resources/firestore_methods.dart';
import 'package:halenest/screens/social/forums/forum_detail.dart';
import 'package:halenest/util/colors.dart';
import 'package:halenest/util/utils.dart';
import 'package:halenest/widgets/forums_widget.dart';

import 'package:provider/provider.dart';

class ForumScreen extends StatefulWidget {
  const ForumScreen({Key? key}) : super(key: key);

  @override
  State<ForumScreen> createState() => _ForumScreenState();
}

class _ForumScreenState extends State<ForumScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  TextEditingController questionSearchController = TextEditingController();
  bool isShow = true;

  @override
  void initState() {
    super.initState();
    questionController.addListener(() {
      setState(() {});
      _tabController = TabController(length: 2, vsync: this);
    });
  }

  uploadQuestion(
      {required String email,
      required String username,
      required String profilePhoto,
      required String uid}) async {
    setState(() {
      isLoading = true;
    });
    String res = await FirestoreMethods().uploadQuestion(
        description: questionController.text,
        email: email,
        username: username,
        profilePhoto: profilePhoto,
        uid: uid);
    if (res != "success") {
      showSnackBar(res, context);
    } else {
      setState(() {
        isLoading = true;
      });
      showSnackBar('Question Posted!', context);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    _tabController?.dispose();

    super.dispose();
  }

  final CollectionReference _questions =
      FirebaseFirestore.instance.collection('questions');
  TextEditingController questionController = TextEditingController();
  TextEditingController queryController = TextEditingController();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    UserProvider user = Provider.of<UserProvider>(context);
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          isLoading
              ? const LinearProgressIndicator(
                  color: primaryColor,
                )
              : Container(
                  height: 87.h,
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0.w),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 24.h,
                        ),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: [

                        //   ],
                        // ),
                        SizedBox(
                          height: 40,
                          child: TabBar(
                              controller: _tabController,
                              labelColor: Colors.white,
                              // indicatorColor: Colors.transparent,
                              labelStyle: TextStyle(fontSize: 16.sp),
                              unselectedLabelColor: const Color(0xff9BABB6),
                              indicator: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6.r),
                                  color: primaryColor),
                              tabs: [
                                Text(
                                  'Ask a question',
                                  style: TextStyle(
                                      // color: Colors.white,
                                      fontFamily: 'RobotoRegular',
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  'Ans a question',
                                  style: TextStyle(
                                      // color: const Color(0xff9BABB6),
                                      fontFamily: 'RobotoRegular',
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500),
                                ),
                              ]),
                        ),

                        // SizedBox(
                        //   height: 16.h,
                        // ),
                      ],
                    ),
                  ),
                ),
          Expanded(
              child: TabBarView(controller: _tabController, children: [
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    Container(
                      height: 52.h,
                      width: double.infinity,
                      color: Colors.white,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 21.0.w),
                        child: Container(
                            height: 52.h,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6.r),
                                color: const Color(0xffF7F8F9)),
                            child: TextField(
                              cursorColor: primaryColor,
                              controller: questionController,
                              decoration: InputDecoration(
                                suffixIcon: questionController.text.isNotEmpty
                                    ? IconButton(
                                        onPressed: () {
                                          uploadQuestion(
                                              email: user.getUser.email,
                                              username: user.getUser.username,
                                              profilePhoto:
                                                  user.getUser.profilePhoto!,
                                              uid: user.getUser.uid);
                                          questionController.clear();
                                        },
                                        icon: const Icon(
                                          Icons.send,
                                          color: Colors.black,
                                        ))
                                    : null,
                                contentPadding:
                                    EdgeInsets.only(bottom: 5.h, left: 10.w),
                                hintText: 'Post a question...',
                                hintStyle: TextStyle(
                                    color: const Color(0xff9BABB6),
                                    fontFamily: 'RobotoRegular',
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400),
                                border: InputBorder.none,
                              ),
                            )),
                      ),
                    ),
                    SizedBox(
                      height: 24.h,
                    ),
                    Divider(
                      height: 0.3.h,
                      color: const Color(0xffDDDEDF),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.w, vertical: 13.h),
                      child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('questions')
                              .where("uid", isEqualTo: user.getUser.uid)
                              .snapshots(),
                          builder: (context,
                              AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                            if (streamSnapshot.hasData) {
                              return streamSnapshot.data!.docs.isNotEmpty
                                  ? ListView.builder(
                                      physics: const BouncingScrollPhysics(),
                                      shrinkWrap: true,
                                      scrollDirection: Axis.vertical,
                                      itemCount:
                                          streamSnapshot.data!.docs.length,
                                      itemBuilder: (context, index) {
                                        final DocumentSnapshot
                                            documentSnapshot =
                                            streamSnapshot.data!.docs[index];

                                        return GestureDetector(
                                          onTap: () {
                                            Navigator.push(context,
                                                MaterialPageRoute(
                                                    builder: (context) {
                                              return ForumDetails(
                                                question: documentSnapshot[
                                                    'description'],
                                                skeptic: documentSnapshot[
                                                    'username'],
                                                totalreplies: '',
                                                questionId:
                                                    documentSnapshot['postId'],
                                              );
                                            }));
                                          },
                                          child: ForumsWidget(
                                            question:
                                                documentSnapshot['description'],
                                            skeptic:
                                                documentSnapshot['username'],
                                            postId: documentSnapshot['postId'],
                                          ),
                                        );
                                      })
                                  : Center(
                                      child: Container(
                                        child: const Text("No Posts yet"),
                                      ),
                                    );
                            } else {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                          }),
                    ),
                  ],
                ),
              ),
            ),

            //*2nd tabbar
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    Container(
                      height: 52.h,
                      width: double.infinity,
                      color: Colors.white,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 21.0.w),
                        child: Container(
                            height: 52.h,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6.r),
                                color: const Color(0xffF7F8F9)),
                            child: TextField(
                              cursorColor: primaryColor,
                              controller: questionSearchController,
                              onChanged: (String query) {
                                setState(() {
                                  if (questionSearchController
                                      .text.isNotEmpty) {
                                    isShow = false;
                                  } else {
                                    isShow = true;
                                  }
                                });
                              },
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.only(bottom: 5.h, left: 10.w),
                                hintText: 'Search topics to answer',
                                hintStyle: TextStyle(
                                    color: const Color(0xff9BABB6),
                                    fontFamily: 'RobotoRegular',
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400),
                                border: InputBorder.none,
                              ),
                            )),
                      ),
                    ),
                    SizedBox(
                      height: 24.h,
                    ),
                    Divider(
                      height: 0.3.h,
                      color: const Color(0xffDDDEDF),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.w, vertical: 13.h),
                      child: (isShow)
                          ? StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection('questions')
                                  .where("uid", isNotEqualTo: user.getUser.uid)
                                  .snapshots(),
                              builder: (context,
                                  AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                                if (streamSnapshot.hasData) {
                                  return streamSnapshot.data!.docs.isNotEmpty
                                      ? ListView.builder(
                                          physics:
                                              const BouncingScrollPhysics(),
                                          shrinkWrap: true,
                                          scrollDirection: Axis.vertical,
                                          itemCount:
                                              streamSnapshot.data!.docs.length,
                                          itemBuilder: (context, index) {
                                            final DocumentSnapshot
                                                documentSnapshot =
                                                streamSnapshot
                                                    .data!.docs[index];

                                            return GestureDetector(
                                              onTap: () {
                                                Navigator.push(context,
                                                    MaterialPageRoute(
                                                        builder: (context) {
                                                  return ForumDetails(
                                                    question: documentSnapshot[
                                                        'description'],
                                                    skeptic: documentSnapshot[
                                                        'username'],
                                                    totalreplies: '',
                                                    questionId:
                                                        documentSnapshot[
                                                            'postId'],
                                                  );
                                                }));
                                              },
                                              child: ForumsWidget(
                                                question: documentSnapshot[
                                                    'description'],
                                                skeptic: documentSnapshot[
                                                    'username'],
                                                postId:
                                                    documentSnapshot['postId'],
                                              ),
                                            );
                                          })
                                      : Center(
                                          child: Container(
                                            child: const Text("No Posts yet"),
                                          ),
                                        );
                                } else {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                }
                              })
                          : StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection('questions')
                                  .where("uid", isNotEqualTo: user.getUser.uid)
                                  .snapshots(),
                              builder: (context,
                                  AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                                if (streamSnapshot.hasData) {
                                  return streamSnapshot.data!.docs.isNotEmpty
                                      ? ListView.builder(
                                          physics:
                                              const BouncingScrollPhysics(),
                                          shrinkWrap: true,
                                          scrollDirection: Axis.vertical,
                                          itemCount:
                                              streamSnapshot.data!.docs.length,
                                          itemBuilder: (context, index) {
                                            final DocumentSnapshot
                                                documentSnapshot =
                                                streamSnapshot
                                                    .data!.docs[index];

                                            return (documentSnapshot[
                                                        'description']
                                                    .toString()
                                                    .toLowerCase()
                                                    .contains(
                                                        questionSearchController
                                                            .text
                                                            .toLowerCase()))
                                                ? GestureDetector(
                                                    onTap: () {
                                                      Navigator.push(context,
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (context) {
                                                        return ForumDetails(
                                                          question:
                                                              documentSnapshot[
                                                                  'description'],
                                                          skeptic:
                                                              documentSnapshot[
                                                                  'username'],
                                                          totalreplies: '',
                                                          questionId:
                                                              documentSnapshot[
                                                                  'postId'],
                                                        );
                                                      }));
                                                    },
                                                    child: ForumsWidget(
                                                      question:
                                                          documentSnapshot[
                                                              'description'],
                                                      skeptic: documentSnapshot[
                                                          'username'],
                                                      postId: documentSnapshot[
                                                          'postId'],
                                                    ),
                                                  )
                                                : Container();
                                          })
                                      : Center(
                                          child: Container(
                                            child: const Text("No Posts yet"),
                                          ),
                                        );
                                } else {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                }
                              }),
                    ),
                  ],
                ),
              ),
            ),
          ]))
        ],
      ),
    );
  }
}
