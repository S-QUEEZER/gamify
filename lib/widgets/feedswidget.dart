import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:halenest/models/user_model.dart';
import 'package:halenest/provider/user_provider.dart';
import 'package:halenest/resources/firestore_methods.dart';
import 'package:halenest/screens/profile/profile.dart';
import 'package:halenest/screens/social/feeds/commentScreen.dart';
import 'package:halenest/util/colors.dart';
import 'package:halenest/util/utils.dart';
import 'package:halenest/widgets/picturescreen.dart';

import 'package:provider/provider.dart';

class FeedsWidget extends StatefulWidget {
  final String name, profileImg, caption, commentCount, likedBy, timeAgo;
  final List<dynamic> postImg;
  final String postUid;
  final List likes;
  final bio;
  final String postId;

  final String commentername;
  final String commenterProfileImg;

  const FeedsWidget({
    Key? key,
    required this.bio,
    required this.caption,
    required this.commentCount,
    required this.likedBy,
    required this.name,
    required this.postImg,
    required this.profileImg,
    required this.timeAgo,
    required this.postId,
    required this.commentername,
    required this.commenterProfileImg,
    required this.likes,
    required this.postUid,
  }) : super(key: key);

  @override
  State<FeedsWidget> createState() => _FeedsWidgetState();
}

class _FeedsWidgetState extends State<FeedsWidget> {
  int commentLen = 0;
  int currentIndex = 0;
  @override
  void initState() {
    super.initState();
    getComments();
  }

  void getComments() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('feeds')
          .doc(widget.postId)
          .collection('comments')
          .get();
      commentLen = snap.docs.length;
    } catch (error) {
      print(error);
    }
    setState(() {});
  }

  deletePost(String postId) async {
    try {
      await FirestoreMethods().deletePost(postId);
    } catch (err) {
      showSnackBar(
        err.toString(),
        context,
      );
    }
  }

  late TabController _tabController;
  bool fixedScroll = false;
  var userData = {};
  int postLen = 0;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;
  bool isLoading = false;
  String bio = "";
  String email = "";

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.postUid)
          .get();

      // get post lENGTH
      var postSnap = await FirebaseFirestore.instance
          .collection('feeds')
          .where('uid', isEqualTo: widget.postUid)
          .get();

      postLen = postSnap.docs.length;
      userData = userSnap.data()!;
      email = userSnap.data()!['email'].toString();
      followers = userSnap.data()!['followers'].length;
      following = userSnap.data()!['following'].length;
      bio = userSnap.data()!['bio'];
      isFollowing = userSnap
          .data()!['followers']
          .contains(FirebaseAuth.instance.currentUser!.uid);
      setState(() {});
    } catch (e) {
      showSnackBar(
        e.toString(),
        context,
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  TextEditingController commentController = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    commentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserProvider user = Provider.of<UserProvider>(context);
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.r),
        child: Container(
          height: 495.h,
          width: 374.w,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(11.r),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 14.h),
            child: Column(
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return ProfileScreen(
                                    username: widget.name,
                                    bio: widget.bio,
                                    profileImg: widget.profileImg,
                                    uid: widget.postUid);
                              }));
                            },
                            child: Container(
                              height: 41.h,
                              width: 41.w,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: NetworkImage(widget.profileImg),
                                      fit: BoxFit.cover)),
                            ),
                          ),
                          SizedBox(
                            width: 14.w,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return ProfileScreen(
                                    receiver: UserModel(
                                        email: email,
                                        followers: [],
                                        following: [],
                                        profilePhoto: widget.profileImg,
                                        uid: widget.postUid,
                                        username: widget.name),
                                    username: widget.name,
                                    bio: widget.bio,
                                    profileImg: widget.profileImg,
                                    uid: widget.postUid);
                              }));
                            },
                            child: RichText(
                              overflow: TextOverflow.ellipsis,
                              strutStyle: const StrutStyle(fontSize: 12.0),
                              text: TextSpan(
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'RobotoBold',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16.sp),
                                  text: widget.name),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        (widget.postUid != user.getUser.uid)
                            ? Container()
                            : IconButton(
                                onPressed: () {
                                  showDialog(
                                    useRootNavigator: false,
                                    context: context,
                                    builder: (context) {
                                      return Dialog(
                                        child: ListView(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 16),
                                            shrinkWrap: true,
                                            children: [
                                              'Delete',
                                            ]
                                                .map(
                                                  (e) => InkWell(
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                vertical: 12,
                                                                horizontal: 16),
                                                        child: Text(e),
                                                      ),
                                                      onTap: () {
                                                        deletePost(
                                                          widget.postId
                                                              .toString(),
                                                        );
                                                        // remove the dialog box
                                                        Navigator.of(context)
                                                            .pop();
                                                      }),
                                                )
                                                .toList()),
                                      );
                                    },
                                  );
                                },
                                icon: const Icon(
                                  Icons.more_vert,
                                ))
                        //* : add kar na hai
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 20.h,
                ),
                const Divider(
                  height: 0.5,
                  color: Color(0xffDDDEDF),
                ),
                SizedBox(
                  height: 17.h,
                ),
                SizedBox(
                  height: 268.h,
                  child: PageView.builder(
                    onPageChanged: (int index) {
                      setState(() {
                        currentIndex = index;
                      });
                    },
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.postImg.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return PictureScreen(
                              imageUrl: widget.postImg[index],
                            );
                          }));
                        },
                        child: Container(
                          // alignment: Alignment.bottomLeft,
                          height: 268.h,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(11.r),
                              image: DecorationImage(
                                  image: NetworkImage(widget.postImg[index]),
                                  fit: BoxFit.cover)),
                          child: Padding(
                            padding: EdgeInsets.only(left: 15.w, bottom: 18.h),
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: 16.h,
                                    right: 14.w,
                                  ),
                                  child: Align(
                                    alignment: Alignment.topRight,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: List.generate(
                                        widget.postImg.length,
                                        (index) => Container(
                                          height: 4.h,
                                          width:
                                              currentIndex == index ? 4.w : 4.w,
                                          margin:
                                              const EdgeInsets.only(right: 5),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20.r),
                                              color: currentIndex == index
                                                  ? Colors.white
                                                  : const Color(0xffE0E0E0)),
                                        ),
                                        //  buildDot(index, context dotNumber),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 200.0.h),
                                  child: Align(
                                    alignment: Alignment.bottomLeft,
                                    child: Row(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            FirestoreMethods().updateLikes(
                                                widget.postId,
                                                FirebaseAuth
                                                    .instance.currentUser!.uid,
                                                widget.likes,
                                                context);
                                          },
                                          child: (!widget.likes.contains(
                                                  FirebaseAuth.instance
                                                      .currentUser!.uid))
                                              ? SvgPicture.asset(
                                                  "assets/icons/likes.svg",
                                                )
                                              : SvgPicture.asset(
                                                  "assets/icons/fill_likes.svg",
                                                ),
                                        ),
                                        SizedBox(
                                          width: 6.w,
                                        ),
                                        Text(
                                          widget.likes.length.toString(),
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'Inter-Regular',
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        SizedBox(
                                          width: 28.w,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Navigator.push(context,
                                                MaterialPageRoute(
                                                    builder: (context) {
                                              return CommentsScreen(
                                                  postId: widget.postId);
                                            }));
                                          },
                                          child: SvgPicture.asset(
                                              "assets/icons/comments.svg"),
                                        ),
                                        SizedBox(
                                          width: 6.w,
                                        ),
                                        Text(
                                          commentLen.toString(),
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'Inter-Regular',
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: 16.h,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 40,
                  child: RichText(
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    strutStyle: const StrutStyle(fontSize: 12.0),
                    text: TextSpan(
                        style: TextStyle(
                            color: const Color(0xff262626),
                            fontFamily: 'RobotoRegular',
                            fontWeight: FontWeight.w400,
                            fontSize: 16.sp),
                        text: widget.caption),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Container(
                    height: 42.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.r),
                        border: Border.all(
                            width: 0.5.w, color: const Color(0xffDDDEDF))),
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
                                await FirestoreMethods().postComment(
                                    widget.postId,
                                    commentController.text,
                                    user.getUser.uid,
                                    user.getUser.username,
                                    widget.commenterProfileImg);
                                commentController.clear();
                              },
                              icon: SvgPicture.asset('assets/icons/send.svg')),
                          prefixIcon: IconButton(
                              onPressed: () {},
                              icon:
                                  SvgPicture.asset('assets/icons/emoji.svg'))),
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
