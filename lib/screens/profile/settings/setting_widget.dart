import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SettingWidget extends StatelessWidget {
  final String settingname;

  const SettingWidget({Key? key, required this.settingname}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 25.h),
      child: SizedBox(
        height: 35.h,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  height: 35.h,
                  width: 35.w,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4.r),
                      color: const Color(0xffF6F7FE)),
                ),
                SizedBox(
                  width: 14.h,
                ),
                Text(
                  settingname,
                  style: TextStyle(
                      color: const Color(0xff002851),
                      fontFamily: 'RobotoRegular',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400),
                )
              ],
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Color(0xff200E32),
            )
          ],
        ),
      ),
    );
  }
}
