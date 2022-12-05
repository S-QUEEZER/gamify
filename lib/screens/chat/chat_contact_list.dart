import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:halenest/constants/chat.dart';
import 'package:halenest/models/user_model.dart';
import 'package:halenest/provider/user_provider.dart';
import 'package:halenest/screens/chat/chat_mesage.dart';
import 'package:halenest/screens/chat/message_widget.dart';
import 'package:halenest/screens/profile/profile.dart';
import 'package:halenest/util/colors.dart';

import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  var isShow = false;
  TextEditingController searchContact = TextEditingController();
  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');
  @override
  Widget build(BuildContext context) {
    UserProvider user = Provider.of<UserProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              children: [
                SizedBox(
                  height: 50.h,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 25.h, bottom: 5.h),
                  child: SizedBox(
                    height: 55,
                    width: double.infinity,
                    child: Padding(
                      padding: EdgeInsets.only(left: 23.0.w, right: 24.w),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Chat',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 25.sp,
                                fontFamily: 'RobotoRegular',
                                color: const Color(0xff3F4765)),
                          ),
                          Row(
                            children: [
                              const SizedBox(
                                width: 6,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return ProfileScreen(
                                      bio: user.getUser.bio!,
                                      profileImg: user.getUser.profilePhoto!,
                                      uid: user.getUser.uid,
                                      username: user.getUser.username,
                                    );
                                  }));
                                },
                                child: CachedNetworkImage(
                                  fadeOutDuration:
                                      const Duration(microseconds: 200),
                                  imageUrl: user.getUser.profilePhoto!,
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    width: 26.w,
                                    height: 26.h,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 1.h,
                  color: const Color(0xffECEDEE),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: 23.w, right: 22.w, top: 23.h, bottom: 29.h),
                  child: Container(
                    width: double.infinity,
                    height: 50.h,
                    decoration: BoxDecoration(
                        color: const Color(0xffF7F8F9),
                        borderRadius: BorderRadius.circular(7.r),
                        border: Border.all(
                            color: const Color(0xffD4E3E7), width: 1.w)),
                    child: TextField(
                      controller: searchContact,
                      cursorColor: primaryColor,
                      textAlign: TextAlign.left,
                      onChanged: (String value) {
                        setState(() {
                          if (searchContact.text.isNotEmpty) {
                            isShow = true;
                          } else {
                            isShow = false;
                          }
                        });
                      },
                      decoration: InputDecoration(
                          suffixIcon: GestureDetector(
                            child: Padding(
                              padding: EdgeInsets.only(
                                  right: 0.w, top: 13.h, bottom: 13.h),
                              child: SvgPicture.asset(
                                  "assets/images/vectorsearch.svg",
                                  height: 10.h,
                                  width: 10.h,
                                  color: primaryColor),
                            ),
                          ),
                          contentPadding: EdgeInsets.only(
                              left: 17.w, bottom: 10.h, top: 8.h),
                          hintText: 'Search people...',
                          hintStyle: TextStyle(
                              fontSize: 14.sp, fontFamily: 'RobotoRegular'),
                          border: InputBorder.none),
                    ),
                  ),
                ),
                (!isShow)
                    ? StreamBuilder(
                        stream: users.where('contacts',
                            arrayContainsAny: [user.getUser.uid]).snapshots(),
                        builder:
                            ((context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasData) {
                            return snapshot.data!.docs.isNotEmpty
                                ? ListView.builder(
                                    padding: EdgeInsets.zero,
                                    physics: const BouncingScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: snapshot.data!.docs.length,
                                    itemBuilder: (context, index) {
                                      var chat = chatsData[index];
                                      var documentSnapshot =
                                          snapshot.data!.docs[index];
                                      UserModel receiver = UserModel(
                                          email: documentSnapshot['email'],
                                          followers:
                                              documentSnapshot['followers'],
                                          following:
                                              documentSnapshot['following'],
                                          profilePhoto:
                                              documentSnapshot['profilePhoto'],
                                          uid: documentSnapshot['uid'],
                                          username:
                                              documentSnapshot['username']);
                                      return InkWell(
                                        onTap: () {
                                          Navigator.push(context,
                                              MaterialPageRoute(
                                                  builder: (context) {
                                            return ChatMessages(
                                              name:
                                                  documentSnapshot['username'],
                                              userImage: documentSnapshot[
                                                  'profilePhoto'],
                                              receiver: receiver,
                                            );
                                          }));
                                        },
                                        child: MessagesCard(
                                          receiverUid: documentSnapshot['uid'],
                                          senderUid: user.getUser.uid,
                                          imagepath:
                                              documentSnapshot['profilePhoto'],
                                          lastMessage: chat.lastMessage,
                                          name: documentSnapshot['username'],
                                          time: chat.time,
                                        ),
                                      );
                                    },
                                  )
                                : Column(
                                    children: [
                                      SizedBox(
                                        height: 80.h,
                                      ),
                                      Center(
                                        child: Container(
                                          width: 242.w,
                                          height: 366.h,
                                          decoration: const BoxDecoration(
                                              image: DecorationImage(
                                                  image: AssetImage(
                                                      "assets/images/chat_messages.png"))),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 90.h,
                                      ),
                                      Text(
                                        "You have not sent or receivedany  messages till now",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: const Color(0xff85939C),
                                            fontFamily: 'RobotoRegular',
                                            fontSize: 18.sp,
                                            fontWeight: FontWeight.w400),
                                      )
                                    ],
                                  );
                          } else {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                        }))
                    : StreamBuilder(
                        stream: users.where('contacts',
                            arrayContainsAny: [user.getUser.uid]).snapshots(),
                        builder:
                            ((context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasData) {
                            return snapshot.data!.docs.isNotEmpty
                                ? ListView.builder(
                                    padding: EdgeInsets.zero,
                                    physics: const BouncingScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: snapshot.data!.docs.length,
                                    itemBuilder: (context, index) {
                                      var chat = chatsData[index];
                                      var documentSnapshot =
                                          snapshot.data!.docs[index];
                                      UserModel receiver = UserModel(
                                          email: documentSnapshot['email'],
                                          followers:
                                              documentSnapshot['followers'],
                                          following:
                                              documentSnapshot['following'],
                                          profilePhoto:
                                              documentSnapshot['profilePhoto'],
                                          uid: documentSnapshot['uid'],
                                          username:
                                              documentSnapshot['username']);
                                      if (documentSnapshot['username']
                                          .toString()
                                          .startsWith(searchContact.text)) {
                                        return InkWell(
                                          onTap: () {
                                            Navigator.push(context,
                                                MaterialPageRoute(
                                                    builder: (context) {
                                              return ChatMessages(
                                                name: documentSnapshot[
                                                    'username'],
                                                userImage: documentSnapshot[
                                                    'profilePhoto'],
                                                receiver: receiver,
                                              );
                                            }));
                                          },
                                          child: MessagesCard(
                                            receiverUid:
                                                documentSnapshot['uid'],
                                            senderUid: user.getUser.uid,
                                            imagepath: documentSnapshot[
                                                'profilePhoto'],
                                            lastMessage: chat.lastMessage,
                                            name: documentSnapshot['username'],
                                            time: chat.time,
                                          ),
                                        );
                                      } else {
                                        return Container();
                                      }
                                    },
                                  )
                                : Column(
                                    children: [
                                      SizedBox(
                                        height: 80.h,
                                      ),
                                      Center(
                                        child: Container(
                                          width: 242.w,
                                          height: 366.h,
                                          decoration: const BoxDecoration(
                                              image: DecorationImage(
                                                  image: AssetImage(
                                                      "assets/images/chat_messages.png"))),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 90.h,
                                      ),
                                      Text(
                                        "You have not sent or receivedany  messages till now",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: const Color(0xff85939C),
                                            fontFamily: 'RobotoRegular',
                                            fontSize: 18.sp,
                                            fontWeight: FontWeight.w400),
                                      )
                                    ],
                                  );
                          } else {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                        })),
                SizedBox(
                  height: 100.h,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
