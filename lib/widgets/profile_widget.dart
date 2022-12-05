import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileWidget extends StatefulWidget {
  final String subject;
  const ProfileWidget({Key? key, required this.subject}) : super(key: key);

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 38.h,
      width: 96.w,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.r),
          border: Border.all(color: const Color(0xffF3F3F3), width: 1.w)),
      child: Text(
        widget.subject,
        style: TextStyle(
            fontFamily: 'RobotoRegular',
            fontSize: 12.sp,
            fontWeight: FontWeight.w600),
      ),
    );
  }
}
