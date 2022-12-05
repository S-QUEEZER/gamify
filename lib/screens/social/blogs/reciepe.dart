// ignore_for_file: unused_field, avoid_unnecessary_containers

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:halenest/screens/social/blogs/blog_details.dart';
import 'package:halenest/widgets/recipewidget.dart';

class RecepieScreen extends StatefulWidget {
  const RecepieScreen({Key? key}) : super(key: key);

  @override
  State<RecepieScreen> createState() => _RecepieScreenState();
}

class _RecepieScreenState extends State<RecepieScreen> {
  final CollectionReference _blogs =
      FirebaseFirestore.instance.collection('blogs');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 24.0.h, left: 20.w),
            child: Text(
              "Recepies",
              style: TextStyle(
                  fontFamily: 'RobotoRegular',
                  fontWeight: FontWeight.w500,
                  fontSize: 22.sp,
                  color: Colors.black),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                left: 20.w,
                right: 20.w,
                top: 20.h,
              ),
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('blogs')
                      .orderBy("datetime", descending: true)
                      .snapshots(),
                  builder:
                      (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                    if (streamSnapshot.hasData) {
                      return GridView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: streamSnapshot.data!.docs.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            mainAxisSpacing: 0.h,
                            crossAxisSpacing: 18.w,
                            crossAxisCount: 2),
                        itemBuilder: (BuildContext context, int index) {
                          final DocumentSnapshot documentSnapshot =
                              streamSnapshot.data!.docs[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return BlogDetail(
                                  likes: documentSnapshot['likes'],
                                  postId: documentSnapshot['postId'],
                                );
                              }));
                            },
                            child: ReceipeWidget(
                              content: documentSnapshot['description'],
                              image: documentSnapshot['feedphoto'],
                              title: documentSnapshot['title'],
                            ),
                          );
                        },
                      );
                    } else {
                      return const CircularProgressIndicator();
                    }
                  }),
            ),
          ),
        ],
      )),
    );
  }
}
