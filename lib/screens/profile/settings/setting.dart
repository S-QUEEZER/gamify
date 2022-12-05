import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:halenest/login/signin.dart';

import 'package:halenest/provider/user_provider.dart';
import 'package:halenest/screens/profile/settings/change_password.dart';
import 'package:halenest/screens/profile/settings/personaldetailscreen.dart';
import 'package:halenest/screens/profile/settings/setting_widget.dart';
import 'package:provider/provider.dart';

import '../../../resources/auth_methods.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    UserProvider user = Provider.of<UserProvider>(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 40),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  height: 58.h,
                  width: 58.w,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(9.r),
                      color: Colors.black,
                      image: DecorationImage(
                          image: NetworkImage(user.getUser.profilePhoto!),
                          fit: BoxFit.cover)),
                ),
                SizedBox(
                  width: 12.w,
                ),
                Column(
                  children: [
                    Text(
                      user.getUser.username,
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontFamily: 'RobotoRegular',
                          fontSize: 16.sp,
                          color: const Color(0xff001032)),
                    )
                  ],
                )
              ],
            ),
            SizedBox(
              height: 26.h,
            ),
            const Divider(
              thickness: 1,
              color: Color(0xffE8E8E8),
            ),
            SizedBox(
              height: 22.h,
            ),
            GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return const PesonalDetailScreen();
                    },
                  ));
                },
                child: const SettingWidget(settingname: "Personal details")),
            GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return const PasswordChangeScreen();
                    },
                  ));
                },
                child: const SettingWidget(settingname: "Change password")),
            const Divider(
              thickness: 1,
              color: Color(0xffE8E8E8),
            ),
            SizedBox(
              height: 22.h,
            ),
            GestureDetector(
              onTap: () {
                AuthMethods().signout();
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const SignInScreen();
                }));
              },
              child: const SettingWidget(settingname: "Sign out"),
            )
          ],
        ),
      ),
    );
  }
}
