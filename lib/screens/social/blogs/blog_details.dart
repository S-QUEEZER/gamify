// ignore_for_file: avoid_unnecessary_containers

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:halenest/resources/firestore_methods.dart';
import 'package:halenest/util/colors.dart';

import 'package:optimized_cached_image/optimized_cached_image.dart';

class BlogDetail extends StatefulWidget {
  final String postId;
  final List likes;

  const BlogDetail({Key? key, required this.postId, required this.likes})
      : super(key: key);

  @override
  State<BlogDetail> createState() => _BlogDetailState();
}

class _BlogDetailState extends State<BlogDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: const BackButton(
            color: Colors.black,
          ),
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('blogs')
              .where('postId', isEqualTo: widget.postId)
              .limit(1)
              .snapshots(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              var documentSnapshot = snapshot.data!.docs[0];
              return Container(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        OptimizedCacheImage(
                          imageUrl: documentSnapshot['feedphoto'],
                          imageBuilder: (context, imageprovider) {
                            return Container(
                              height: 234.79,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.r),
                                  image: DecorationImage(
                                      image: imageprovider, fit: BoxFit.cover)),
                            );
                          },
                        ),
                        SizedBox(
                          height: 28.21.h,
                        ),
                        Text(
                          documentSnapshot['title'],
                          style: TextStyle(
                              color: const Color(0xff3F414E),
                              fontFamily: 'HelveticaBold',
                              fontWeight: FontWeight.w700,
                              fontSize: 18.sp),
                        ),
                        SizedBox(
                          height: 13.h,
                        ),
                        Text(
                          documentSnapshot['description'],
                          style: TextStyle(
                              color: const Color(0xff262626),
                              fontFamily: 'RobotoRegular',
                              fontWeight: FontWeight.w400,
                              fontSize: 14.sp),
                        ),
                        SizedBox(
                          height: 30.h,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 290.w,
                            ),
                            Row(
                              children: [
                                Column(
                                  children: [
                                    IconButton(
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                      icon: SvgPicture.asset(
                                          'assets/icons/upvote.svg'),
                                      onPressed: () {
                                        FirestoreMethods().updateBlogLikes(
                                            widget.postId,
                                            FirebaseAuth
                                                .instance.currentUser!.uid,
                                            documentSnapshot['likes'],
                                            context);
                                      },
                                    ),
                                    Text(
                                      documentSnapshot['likes']
                                          .length
                                          .toString(),
                                      style: TextStyle(
                                          color: primaryColor,
                                          fontFamily: 'RobotoRegular',
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w400),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  width: 16.sp,
                                ),
                              ],
                            )
                          ],
                        ),
                        SizedBox(
                          height: 30.h,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            } else {
              return const CircularProgressIndicator();
            }
          },
        ));
  }
}
