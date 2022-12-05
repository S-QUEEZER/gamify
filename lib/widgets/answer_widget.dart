import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AnswerWidget extends StatefulWidget {
  final String image;
  final String answer;
  final String downvotes, upvotes, username;
  const AnswerWidget(
      {Key? key,
      required this.image,
      required this.answer,
      required this.downvotes,
      required this.upvotes,
      required this.username})
      : super(key: key);

  @override
  State<AnswerWidget> createState() => _AnswerWidgetState();
}

class _AnswerWidgetState extends State<AnswerWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 27.h,
        left: 14.w,
        right: 12.w,
      ),
      child: SizedBox(
        width: 348.w,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 34.h,
              width: 34.w,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: NetworkImage(widget.image), fit: BoxFit.cover)),
            ),
            SizedBox(
              width: 12.w,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.username,
                    style: TextStyle(
                      color: const Color(0xff000000),
                      fontFamily: 'RobotoRegular',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 3.h,
                  ),
                  Container(
                    color: Colors.white,
                    child: Text(
                      widget.answer,
                      style: TextStyle(
                        letterSpacing: 0.2,
                        wordSpacing: 0.2,
                        color: const Color(0xff262626),
                        fontFamily: 'RobotoRegular',
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
