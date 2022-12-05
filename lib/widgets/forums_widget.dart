import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:halenest/util/colors.dart';

class ForumsWidget extends StatefulWidget {
  final String question;
  final String skeptic;
  final String postId;

  const ForumsWidget(
      {Key? key,
      required this.question,
      required this.skeptic,
      required this.postId})
      : super(key: key);

  @override
  State<ForumsWidget> createState() => _ForumsWidgetState();
}

class _ForumsWidgetState extends State<ForumsWidget> {
  int commentLen = 0;

  @override
  void initState() {
    super.initState();
    getComments();
  }

  void getComments() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('questions')
          .doc(widget.postId)
          .collection('answers')
          .get();
      commentLen = snap.docs.length;
    } catch (error) {
      print(error);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.0.h),
      child: Container(
        width: 374.w,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.r),
        ),
        child: Padding(
          padding: EdgeInsets.only(
              top: 14.0.h, bottom: 17.h, left: 14.w, right: 14.w),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 200.w,
                    child: RichText(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      strutStyle: const StrutStyle(fontSize: 12.0),
                      text: TextSpan(
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'RobotoBold',
                              fontWeight: FontWeight.w400,
                              fontSize: 14.sp),
                          text: widget.question),
                    ),
                  ),
                  Text(
                    '@${widget.skeptic}',
                    style: TextStyle(
                        color: const Color(0xff999999),
                        fontFamily: 'RobotoRegular',
                        fontWeight: FontWeight.w500,
                        fontSize: 14.sp),
                  ),
                ],
              ),
              SizedBox(
                height: 14.w,
              ),
              // SizedBox(
              //   width: double.infinity,
              //   height: 42.h,
              //   child: RichText(
              //     maxLines: 2,
              //     overflow: TextOverflow.ellipsis,
              //     strutStyle: const StrutStyle(fontSize: 12.0),
              //     text: TextSpan(
              //         style: TextStyle(
              //             color: const Color(0xff262626),
              //             fontFamily: 'RobotoRegular',
              //             fontWeight: FontWeight.w400,
              //             fontSize: 16.sp),
              //         text: widget.answer),
              //   ),
              // ),
              SizedBox(
                height: 14.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
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
                      SizedBox(
                        width: 10.w,
                      ),
                      Container(
                        alignment: Alignment.center,
                        height: 33.h,
                        width: 100.w,
                        decoration: BoxDecoration(
                            color: const Color(0xffF6F6F6),
                            borderRadius: BorderRadius.circular(21.r)),
                        child: Text(
                          'See more',
                          style: TextStyle(
                              color: primaryColor,
                              fontFamily: 'RobotoRegular',
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        commentLen.toString(),
                        style: TextStyle(
                          color: primaryColor,
                          fontFamily: 'RobotoRegular',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(
                        width: 4.w,
                      ),
                      const Icon(
                        Icons.edit,
                        color: primaryColor,
                      )
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
