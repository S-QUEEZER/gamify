// ignore_for_file: avoid_print, no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:halenest/provider/user_provider.dart';
import 'package:halenest/screens/chat/chat_contact_list.dart';
import 'package:halenest/screens/social/social.dart';
import 'package:halenest/screens/trending/trending.dart';
import 'package:halenest/util/colors.dart';

import 'package:provider/provider.dart';

class ButtonNavBar extends StatefulWidget {
  const ButtonNavBar({Key? key}) : super(key: key);

  @override
  State<ButtonNavBar> createState() => _ButtonNavBarState();
}

class _ButtonNavBarState extends State<ButtonNavBar> {
  int currentindex = 2;
  int pressedButtonNo = 2;
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  @override
  void initState() {
    super.initState();
    addData();
  }

  addData() async {
    UserProvider _userProvider =
        Provider.of<UserProvider>(context, listen: false);
    await _userProvider.refreshUser();
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      const ChatScreen(),
      const SocialScreen(),
      const TrendingScreen(),
    ];
    final items = <Widget>[
      SvgPicture.asset(
        "assets/icons/chat.svg",
        color: (pressedButtonNo == 0) ? Colors.white : const Color(0xffC4C4C4),
      ),
      // Icon(Icons.add,
      //     color:
      //         (pressedButtonNo == 0) ? Colors.white : const Color(0xffC4C4C4)),
      SvgPicture.asset(
        "assets/icons/social.svg",
        color: (pressedButtonNo == 1) ? Colors.white : const Color(0xffC4C4C4),
      ),
      SvgPicture.asset(
        "assets/icons/home.svg",
        color: (pressedButtonNo == 2) ? Colors.white : const Color(0xffC4C4C4),
      ),
    ];

    return Scaffold(
      extendBody: true,
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: currentindex,
        height: 60.0,
        items: items,
        color: Colors.white, //navbar color
        backgroundColor: Colors.transparent,
        buttonBackgroundColor: primaryColor,

        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 300),
        onTap: (index) {
          setState(() {
            currentindex = index;
            pressedButtonNo = index;
          });
        },
        letIndexChange: (index) => true,
      ),
      body: screens[currentindex],
    );
  }
}
