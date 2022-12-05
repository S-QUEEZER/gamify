import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StoriesWidget extends StatefulWidget {
  final String name, imageurl;
  const StoriesWidget({Key? key, required this.imageurl, required this.name})
      : super(key: key);

  @override
  State<StoriesWidget> createState() => _StoriesWidgetState();
}

class _StoriesWidgetState extends State<StoriesWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 15.w,
        top: 17.h,
        bottom: 16.h,
      ),
      child: Container(
        height: 64.h,
        width: 64.w,
        decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
                tileMode: TileMode.clamp,
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [Color(0xff5B6CFF), Color(0xffEF44FE)])),
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Container(
            height: 60.h,
            width: 60.w,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(width: 2, color: Colors.white),
                image: DecorationImage(
                    image: NetworkImage(widget.imageurl), fit: BoxFit.cover)),
          ),
        ),
      ),
    );
  }
}
