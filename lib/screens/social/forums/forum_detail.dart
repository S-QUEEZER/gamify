// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:halenest/provider/user_provider.dart';
import 'package:halenest/resources/firestore_methods.dart';
import 'package:halenest/util/utils.dart';
import 'package:halenest/widgets/answer_widget.dart';

import 'package:provider/provider.dart';

import '../../../util/colors.dart';

class ForumDetails extends StatefulWidget {
  final String question;
  final String skeptic;
  final String totalreplies;
  final String questionId;

  const ForumDetails({
    Key? key,
    required this.question,
    required this.skeptic,
    required this.totalreplies,
    required this.questionId,
  }) : super(key: key);

  @override
  State<ForumDetails> createState() => _ForumDetailsState();
}

class _ForumDetailsState extends State<ForumDetails> {
  bool isLoading = false;
  uploadAnswer(
      String username, String uid, String email, String userPhoto) async {
    setState(() {
      isLoading = true;
    });
    String res = await FirestoreMethods().postAnswer(
        widget.questionId, answerController.text, uid, username, userPhoto);
    if (res != "success") {
      showSnackBar('Fill all the fields', context);
    } else {
      Navigator.pop(context);
      showSnackBar('Posted!', context);
      setState(() {
        isLoading = false;
      });
    }
  }

  TextEditingController answerController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    UserProvider user = Provider.of<UserProvider>(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0.w, vertical: 50.h),
          child: Container(
            width: 374.w,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(5.r)),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    top: 23.h,
                    left: 14.w,
                    right: 18.w,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.question,
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'RobotoBold',
                            fontWeight: FontWeight.w400,
                            fontSize: 20.sp),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Row(
                        children: [
                          // Text(
                          //   '121',
                          //   style: TextStyle(
                          //     color: primaryColor,
                          //     fontFamily: 'RobotoRegular',
                          //     fontSize: 18.sp,
                          //     fontWeight: FontWeight.w500,
                          //   ),
                          // ),
                          SizedBox(
                            width: 4.w,
                          ),
                          // const Icon(
                          //   Icons.edit,
                          //   size: 15,
                          //   color: primaryColor,
                          // )
                        ],
                      ),
                    ],
                  ),
                ),
                const Divider(
                  color: dividerColor,
                  thickness: 0.3,
                ),
                SizedBox(
                  height: 10.h,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(user.getUser.profilePhoto!),
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    Container(
                      alignment: Alignment.center,
                      width: double.infinity,
                      child: Column(
                        children: [
                          Text(
                            '${user.getUser.username}, can you answer this question?',
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'RobotoRegular',
                                fontSize: 14.sp,
                                wordSpacing: 1,
                                fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          Text(
                            'People are searching for an answer to this question',
                            style: TextStyle(
                                color: const Color(0xff939598),
                                fontFamily: 'RobotoRegular',
                                fontSize: 13.sp,
                                wordSpacing: 1,
                                fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            height: 15.h,
                          ),
                          GestureDetector(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return Dialog(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.r)),
                                      insetPadding: EdgeInsets.only(
                                          left: 13.w, right: 13.w),
                                      child: SizedBox(
                                        width: double.infinity,
                                        height: 239.h,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 11.w, vertical: 11.h),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Write Answer',
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
                                                'Type hashtags in question to get better reach',
                                                style: TextStyle(
                                                  color:
                                                      const Color(0xffBBBBBB),
                                                  fontWeight: FontWeight.w400,
                                                  fontFamily: 'RobotoRegular',
                                                  fontSize: 12.sp,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 17.h,
                                              ),
                                              Container(
                                                height: 97.h,
                                                width: 351.w,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5.r),
                                                    border: Border.all(
                                                        width: 1.w,
                                                        color: const Color(
                                                            0xffDDDEDF))),
                                                child: TextField(
                                                  controller: answerController,
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily: 'RobotoRegular',
                                                    fontSize: 14.sp,
                                                  ),
                                                  maxLines: 9999,
                                                  decoration: InputDecoration(
                                                      hintText:
                                                          'Write your answer',
                                                      hintStyle: TextStyle(
                                                        color: const Color(
                                                            0xffBBBBBB),
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontFamily:
                                                            'RobotoRegular',
                                                        fontSize: 14.sp,
                                                      ),
                                                      border: InputBorder.none),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 15.h,
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: 263.w),
                                                child: GestureDetector(
                                                  //* add answer method
                                                  onTap: () => uploadAnswer(
                                                      user.getUser.username,
                                                      user.getUser.uid,
                                                      user.getUser.email,
                                                      user.getUser
                                                          .profilePhoto!),
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    height: 34.h,
                                                    width: 88.w,
                                                    decoration: BoxDecoration(
                                                        color: primaryColor,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(4.r)),
                                                    child: Text(
                                                      'Post',
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'RobotoRegular',
                                                          fontSize: 14.sp,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.white),
                                                    ),
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
                              alignment: Alignment.center,
                              height: 33.h,
                              width: 100.w,
                              decoration: BoxDecoration(
                                  color: primaryColor,
                                  borderRadius: BorderRadius.circular(21.r)),
                              child: Text(
                                'Answer',
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
                    SizedBox(
                      height: 15.h,
                    ),
                    Divider(
                      color: dividerColor,
                      thickness: 0.5.w,
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('questions')
                            .doc(widget.questionId)
                            .collection('answers')
                            .snapshots(),
                        builder: (context,
                            AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                          if (streamSnapshot.hasData) {
                            return streamSnapshot.data!.docs.isNotEmpty
                                ? ListView.builder(
                                    padding: EdgeInsets.zero,
                                    physics: const BouncingScrollPhysics(),
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    itemCount: streamSnapshot.data!.docs.length,
                                    itemBuilder: (context, index) {
                                      final DocumentSnapshot documentSnapshot =
                                          streamSnapshot.data!.docs[index];
                                      return AnswerWidget(
                                        username: documentSnapshot['name'],
                                        answer: documentSnapshot['text'],
                                        downvotes: '121',
                                        upvotes: '121',
                                        image: documentSnapshot['profilePic'],
                                      );
                                    })
                                : const Text('No answers yet ');
                          } else {
                            return const CircularProgressIndicator();
                          }
                        }),
                    SizedBox(
                      height: 30.h,
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
