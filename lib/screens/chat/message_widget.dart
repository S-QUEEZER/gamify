import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';

class MessagesCard extends StatefulWidget {
  final String imagepath;
  final String name;
  final String lastMessage;
  final String time;
  final String senderUid, receiverUid;

  const MessagesCard({
    Key? key,
    required this.imagepath,
    required this.lastMessage,
    required this.name,
    required this.time,
    required this.senderUid,
    required this.receiverUid,
  }) : super(key: key);

  @override
  State<MessagesCard> createState() => _MessagesCardState();
}

class _MessagesCardState extends State<MessagesCard> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("messages")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection(widget.receiverUid)
          .orderBy("timestamp", descending: true)
          .snapshots(),
      // stream: FirebaseFirestore.instance
      //     .collection('lastmessages')
      //     .doc(widget.senderUid)
      //     .collection(widget.receiverUid)
      //     .doc(widget.receiverUid)
      //     .snapshots(),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          var documentSnapshot = snapshot.data!.docs;
          return Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 25.h, right: 24.w, left: 23.w),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        OptimizedCacheImage(
                          imageUrl: widget.imagepath,
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) {
                            return SizedBox(
                              height: 41.h,
                              width: 41.w,
                            );
                          },
                          imageBuilder: (context, imageProvider) {
                            return Container(
                              height: 41.h,
                              width: 41.w,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: imageProvider, fit: BoxFit.cover)),
                            );
                          },
                        ),
                        SizedBox(
                          width: 18.w,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.name,
                                  style: TextStyle(
                                      fontSize: 16.sp,
                                      fontFamily: 'RobotoRegular',
                                      fontWeight: FontWeight.w500),
                                ),
                                SizedBox(
                                  height: 6.h,
                                ),
                                SizedBox(
                                  width: 150.w,
                                  child: Text(
                                    documentSnapshot[0]['message']!,
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontFamily: 'RobotoRegular',
                                      fontWeight: FontWeight.w400,
                                      color: const Color(0xff85939C),
                                      fontSize: 14.sp,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              width: 80.w,
                            ),
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: 26.h,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 50.0.w),
                      child: Container(
                        width: double.infinity,
                        height: 1.h,
                        decoration: BoxDecoration(
                            border: Border.all(
                          width: 1.w,
                          color: const Color(0xffD4E3E7),
                        )),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                  left: 300.w,
                  child: Text(
                    DateFormat.yMMMd().format(
                      documentSnapshot[0]['timestamp'].toDate(),
                    ),
                    style: TextStyle(
                        color: const Color(0xff7F869E),
                        fontFamily: 'RobotoFamily',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400),
                  ))
            ],
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
