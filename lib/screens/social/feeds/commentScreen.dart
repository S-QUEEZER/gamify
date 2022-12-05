// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api, prefer_typing_uninitialized_variables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:halenest/provider/user_provider.dart';
import 'package:halenest/resources/firestore_methods.dart';
import 'package:halenest/util/utils.dart';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CommentsScreen extends StatefulWidget {
  final postId;
  const CommentsScreen({Key? key, required this.postId}) : super(key: key);

  @override
  _CommentsScreenState createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final TextEditingController commentEditingController =
      TextEditingController();

  void postComment(String uid, String name, String profilePic) async {
    try {
      String res = await FirestoreMethods().postComment(
        widget.postId,
        commentEditingController.text,
        uid,
        name,
        profilePic,
      );

      if (res != 'success') {
        showSnackBar(res, context);
      }
      setState(() {
        commentEditingController.text = "";
      });
    } catch (err) {
      showSnackBar(err.toString(), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    UserProvider user = Provider.of<UserProvider>(context);
    // final User user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'Comments',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'RobotoRegular',
          ),
        ),
        centerTitle: false,
        leading: const BackButton(
          color: Colors.black,
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('feeds')
            .doc(widget.postId)
            .collection('comments')
            .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var documentSnapshot = snapshot.data!.docs[index];
                return Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  child: Row(
                    children: [
                      Container(
                        height: 34.h,
                        width: 34.w,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: NetworkImage(
                                documentSnapshot['profilePic'],
                              ),
                              fit: BoxFit.cover,
                            )),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                        text: '@${documentSnapshot['name']}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontFamily: 'RobotoRegular',
                                            fontSize: 12.sp,
                                            color: Colors.black)),
                                    TextSpan(
                                        text: ' ${documentSnapshot['text']}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontFamily: 'RobotoRegular',
                                            fontSize: 12.sp,
                                            color: Colors.black)),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  DateFormat.yMMMd().format(
                                    documentSnapshot['datePublished'].toDate(),
                                  ),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              });
        },
      ),
      // text input
      bottomNavigationBar: SafeArea(
        child: Container(
          height: kToolbarHeight,
          margin:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          padding: EdgeInsets.only(left: 16.w, right: 8.w),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(user.getUser.profilePhoto!),
                radius: 18.r,
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 16.w, right: 8.w),
                  child: TextField(
                    controller: commentEditingController,
                    decoration: InputDecoration(
                      hintText: 'Comment as ${user.getUser.username}',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  postComment(
                    user.getUser.uid,
                    user.getUser.username,
                    user.getUser.profilePhoto!,
                  );
                  removeKeyboard(context);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
                  child: const Text(
                    'Post',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
