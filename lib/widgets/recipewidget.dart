import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';

class ReceipeWidget extends StatefulWidget {
  final String image;
  final String title;
  final String content;
  const ReceipeWidget(
      {Key? key,
      required this.image,
      required this.title,
      required this.content})
      : super(key: key);

  @override
  State<ReceipeWidget> createState() => _ReceipeWidgetState();
}

class _ReceipeWidgetState extends State<ReceipeWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OptimizedCacheImage(
            imageUrl: widget.image,
            progressIndicatorBuilder: (context, url, downloadProgress) {
              return SizedBox(
                height: 113.h,
                width: 180.w,
              );
            },
            imageBuilder: (context, imageprovider) {
              return Container(
                height: 113.h,
                width: 180.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  image:
                      DecorationImage(image: imageprovider, fit: BoxFit.cover),
                ),
              );
            },
          ),
          SizedBox(
            height: 11.h,
          ),
          SizedBox(
            width: 177,
            child: RichText(
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              strutStyle: const StrutStyle(fontSize: 12.0),
              text: TextSpan(
                  style: TextStyle(
                      color: const Color(0xff3F414E),
                      fontFamily: 'HelveticaBold',
                      fontWeight: FontWeight.w700,
                      fontSize: 18.sp),
                  text: widget.title),
            ),
          ),
          /*
   
           */
          SizedBox(
            height: 6.h,
          ),
          SizedBox(
            width: 177.w,
            height: 20.h,
            child: RichText(
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              strutStyle: const StrutStyle(fontSize: 12.0),
              text: TextSpan(
                  style: TextStyle(
                      color: const Color(0xff999999),
                      fontFamily: 'RobotoRegular',
                      fontWeight: FontWeight.w400,
                      fontSize: 11.sp),
                  text: widget.content),
            ),
          ),
        ],
      ),
    );
  }
}
