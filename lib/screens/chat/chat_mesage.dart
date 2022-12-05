// ignore_for_file: avoid_unnecessary_containers

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:halenest/models/message_model.dart';
import 'package:halenest/models/user_model.dart';
import 'package:halenest/provider/user_provider.dart';
import 'package:halenest/resources/firestore_respository.dart';
import 'package:halenest/util/colors.dart';
import 'package:halenest/util/utils.dart';

import 'package:provider/provider.dart';

class ChatMessages extends StatefulWidget {
  final UserModel receiver;
  final String userImage;
  final String name;
  const ChatMessages(
      {Key? key,
      required this.userImage,
      required this.name,
      required this.receiver})
      : super(key: key);

  @override
  State<ChatMessages> createState() => _ChatMessagesState();
}

class _ChatMessagesState extends State<ChatMessages> {
  final ScrollController _controller = ScrollController();

  late UserModel sender;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final position = _controller.position.maxScrollExtent;
      _controller.jumpTo(position);
    });
  }

  void _scrollDown() {
    _controller.animateTo(
      _controller.position.maxScrollExtent,
      duration: const Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
    );
  }

  TextEditingController commentController = TextEditingController();

  Widget messageList() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("messages")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection(widget.receiver.uid)
          .orderBy("timestamp", descending: false)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        // _scrollDown();
        if (snapshot.data == null) {
          return const Center(child: CircularProgressIndicator());
        }
        {
          if (_controller.hasClients) {
            final position = _controller.position.maxScrollExtent;

            _controller.animateTo(
              position,
              duration: const Duration(seconds: 1),
              curve: Curves.fastOutSlowIn,
            );
            _scrollDown();
          }
          return ListView.builder(
            controller: _controller,
            padding: const EdgeInsets.all(10),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              return chatMessageItem(snapshot.data!.docs[index]);
            },
          );
        }
      },
    );
  }

  Widget chatMessageItem(DocumentSnapshot snapshot) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15.h),
      child: Container(
        alignment: snapshot['sendId'] == FirebaseAuth.instance.currentUser!.uid
            ? Alignment.centerRight
            : Alignment.centerLeft,
        child: snapshot['receiverId'] == FirebaseAuth.instance.currentUser!.uid
            ? senderLayout(snapshot)
            : receiverLayout(snapshot),
      ),
    );
  }

  Widget senderLayout(DocumentSnapshot snapshot) {
    Radius messageRadius = const Radius.circular(10);

    return Container(
      margin: const EdgeInsets.only(top: 0),
      constraints:
          BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.65),
      decoration: BoxDecoration(
        color: const Color(0xffF7F8F9),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(22.r),
          topRight: Radius.circular(8.r),
          bottomLeft: Radius.circular(22.r),
          bottomRight: Radius.circular(22.r),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: getSenderMessage(snapshot),

        // Text(
        //   message,

        // ),
      ),
    );
  }

  getSenderMessage(DocumentSnapshot snapshot) {
    return Text(snapshot['message'],
        style: const TextStyle(
            color: Color(0xff464646),
            fontSize: 16,
            fontFamily: 'RobotoRegular',
            fontWeight: FontWeight.w400));
  }

  getReceiverMessage(DocumentSnapshot snapshot) {
    return Text(snapshot['message'],
        style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontFamily: 'RobotoRegular',
            fontWeight: FontWeight.w400));
  }

  Widget receiverLayout(DocumentSnapshot snapshot) {
    Radius messageRadius = const Radius.circular(10);

    return Container(
      margin: const EdgeInsets.only(top: 12),
      constraints:
          BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.65),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.only(
          bottomRight: messageRadius,
          topRight: messageRadius,
          bottomLeft: messageRadius,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: getReceiverMessage(snapshot),
      ),
    );
  }

  sendMessage(email, followers, following, profilePhoto, uid, username) {
    var text = commentController.text;

    Message message = Message(
      receiverId: widget.receiver.uid,
      senderId: FirebaseAuth.instance.currentUser!.uid,
      message: text,
      timestamp: FieldValue.serverTimestamp(),
      type: 'text',
    );

    setState(() {
      sender = UserModel(
          email: email,
          followers: followers,
          following: following,
          profilePhoto: profilePhoto,
          uid: uid,
          username: username);
    });
    // _scrollController.animateTo(_scrollController.position.maxScrollExtent,
    //     duration: const Duration(milliseconds: 300), curve: Curves.bounceIn);

    FirebaseRespository().addMessageToDb(message, sender, widget.receiver);
  }

  _onEmojiSelected(Emoji emoji) {
    commentController
      ..text += emoji.emoji
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: commentController.text.length));
  }

  @override
  Widget build(BuildContext context) {
    UserProvider user = Provider.of<UserProvider>(context);

    return Scaffold(
        body: Container(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(right: 20.w, top: 70.h),
            child: Container(
              alignment: Alignment.centerLeft,
              width: double.infinity,
              height: 55.h,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BackButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Container(
                    height: 41.h,
                    width: 41.h,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: NetworkImage(widget.userImage),
                            fit: BoxFit.cover)),
                  ),
                  SizedBox(
                    width: 9.w,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.name),
                      SizedBox(
                        height: 5.h,
                      ),
                      // const Text(
                      //   'Online',
                      //   style: TextStyle(color: Color(0xff85939C)),
                      // )
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Padding(
          //   padding: EdgeInsets.symmetric(
          //     horizontal: 20.w,
          //   ),
          //   child: const Divider(
          //     thickness: 1,
          //     color: dividerColor,
          //   ),
          // ),
          Expanded(child: messageList()),
          Padding(
            padding: EdgeInsets.only(
                top: 15.0.h, bottom: 20.h, right: 20.h, left: 20.h),
            child: Container(
              height: 42.h,
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.r),
                  border:
                      Border.all(width: 0.5.w, color: const Color(0xffDDDEDF))),
              child: TextField(
                cursorColor: primaryColor,
                controller: commentController,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(bottom: 5.h),
                    hintText: 'Add comment...',
                    hintStyle: TextStyle(
                        color: const Color(0xffC5C7CA),
                        fontFamily: 'RobotoRegular',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400),
                    border: InputBorder.none,
                    suffixIcon: IconButton(
                        onPressed: () async {
                          setState(() {
                            if (commentController.text == "") {
                              showSnackBar('Write a message!', context);
                            } else {
                              _scrollDown();
                              sendMessage(
                                  user.getUser.email,
                                  user.getUser.followers,
                                  user.getUser.following,
                                  user.getUser.profilePhoto,
                                  user.getUser.uid,
                                  user.getUser.username);

                              // _scrollController.animateTo(
                              //     _scrollController.position.maxScrollExtent,
                              //     duration: const Duration(milliseconds: 300),
                              //     curve: Curves.easeOut);
                            }
                            // messages.add(commentController.text);
                            commentController.clear();
                            removeKeyboard(context);
                          });
                        },
                        icon: SvgPicture.asset('assets/icons/send.svg')),
                    prefixIcon: IconButton(
                        onPressed: () {},
                        icon: SvgPicture.asset('assets/icons/emoji.svg'))),
              ),
            ),
          )
        ],
      ),
    ));
  }
}
