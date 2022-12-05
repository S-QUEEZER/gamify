import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:halenest/models/user_model.dart';
import 'package:halenest/provider/user_provider.dart';
import 'package:halenest/resources/firestore_methods.dart';
import 'package:halenest/screens/chat/chat_contact_list.dart';
import 'package:halenest/screens/chat/chat_mesage.dart';
import 'package:halenest/screens/profile/settings/setting.dart';
import 'package:halenest/screens/social/blogs/blog_details.dart';
import 'package:halenest/screens/social/feeds/search_screen.dart';
import 'package:halenest/screens/social/forums/forum_detail.dart';
import 'package:halenest/util/colors.dart';
import 'package:halenest/util/utils.dart';
import 'package:halenest/widgets/forums_widget.dart';
import 'package:halenest/widgets/profile_widget.dart';
import 'package:halenest/widgets/recipewidget.dart';

import 'package:optimized_cached_image/optimized_cached_image.dart';

import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  final String username;
  final String bio;
  final String profileImg;
  final String uid;

  final UserModel? receiver;
  const ProfileScreen(
      {Key? key,
      required this.username,
      required this.bio,
      required this.profileImg,
      required this.uid,
      this.receiver})
      : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  final CollectionReference _feeds =
      FirebaseFirestore.instance.collection('feeds');

  late TabController _tabController;
  bool fixedScroll = false;
  var userData = {};
  int postLen = 0;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;
  bool isLoading = false;
  String bio = "";
  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();

      // get post lENGTH
      var postSnap = await FirebaseFirestore.instance
          .collection('feeds')
          .where('uid', isEqualTo: widget.uid)
          .get();

      postLen = postSnap.docs.length;
      userData = userSnap.data()!;
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

  List<Widget> tabbar = [
    const Text('Feeds'),
    const Text('Forums'),
    const Text('Receipes'),
  ];

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
    getData();
  }

  @override
  void dispose() {
    _tabController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserModel user = Provider.of<UserProvider>(context).getUser;
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: Text(
            'Profile',
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'RobotoRegular',
              fontWeight: FontWeight.w500,
              fontSize: 27.sp,
            ),
          ),
          centerTitle: false,
          actions: [
            Padding(
              padding: EdgeInsets.only(bottom: 10.0.h),
              child: Row(
                children: [
                  GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return const SearchScreen();
                        }));
                      },
                      child: SvgPicture.asset('assets/icons/search.svg')),
                  SizedBox(
                    width: 15.w,
                  ),
                  InkWell(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return const ChatScreen();
                        }));
                      },
                      child: SvgPicture.asset('assets/icons/chat.svg')),
                  SizedBox(
                    width: 20.w,
                  )
                ],
              ),
            )
          ],
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Divider(
                height: 0.9,
                color: dividerColor,
              ),
              SizedBox(
                height: 29.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 55.h,
                    width: 55.w,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: NetworkImage(widget.profileImg),
                            fit: BoxFit.cover)),
                  ),
                  ProfileWidget(subject: '$postLen posts'),
                  ProfileWidget(subject: '$followers followers'),
                  ProfileWidget(subject: '$following following'),
                ],
              ),
              SizedBox(
                height: 17.h,
              ),
              Row(
                children: [
                  Text(
                    widget.username,
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'RobotoRegular',
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w400),
                  ),
                  SizedBox(
                    width: 6.w,
                  ),
                  (widget.uid == FirebaseAuth.instance.currentUser!.uid)
                      ? GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return const SettingScreen();
                              },
                            ));
                          },
                          child: Row(
                            children: [
                              Text(
                                "Edit profile",
                                style: TextStyle(
                                    color: primaryColor,
                                    fontFamily: 'Blinker-Regular',
                                    fontWeight: FontWeight.w400,
                                    fontSize: 13.sp),
                              ),
                              const Icon(
                                Icons.edit,
                                color: primaryColor,
                                size: 15,
                              )
                            ],
                          ),
                        )
                      : Container(),
                ],
              ),
              SizedBox(
                height: 7.h,
              ),
              Text(bio,
                  style: TextStyle(
                      color: const Color(0xff393939),
                      fontFamily: 'RobotoRegular',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400)),
              SizedBox(
                height: 17.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //*follow or signout
                  widget.uid == FirebaseAuth.instance.currentUser!.uid
                      ? Container()
                      : InkWell(
                          onTap: () async {
                            await FirestoreMethods().followUser(
                              FirebaseAuth.instance.currentUser!.uid,
                              userData['uid'],
                            );

                            setState(() {
                              isFollowing = !isFollowing;
                              isFollowing ? followers++ : followers--;
                            });
                          },
                          child: Container(
                            alignment: Alignment.center,
                            height: 35.h,
                            width: 182.w,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.r),
                                color: const Color(0xff8E97FD)),
                            child: Text(
                              isFollowing ? 'Following' : 'Follow',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'RobotoRegular',
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        ),
                  //*messaging option
                  widget.uid == FirebaseAuth.instance.currentUser!.uid
                      ? Container()
                      : InkWell(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return ChatMessages(
                                  userImage: widget.profileImg,
                                  name: widget.username,
                                  receiver: widget.receiver!);
                            }));
                          },
                          child: Container(
                            alignment: Alignment.center,
                            height: 35.h,
                            width: 182.w,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.r),
                                color: const Color(0xffF7F8F9)),
                            child: Text(
                              "Message",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'RobotoRegular',
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        )
                ],
              ),
              SizedBox(
                height: 27.h,
              ),
              const Divider(
                height: 0.9,
                color: dividerColor,
              ),
              SizedBox(
                height: 8.h,
              ),
              SizedBox(
                height: 40,
                child: TabBar(
                    controller: _tabController,
                    indicatorColor: primaryColor,
                    labelColor: primaryColor,
                    labelStyle: TextStyle(fontSize: 16.sp),
                    unselectedLabelColor: const Color(0xff555555),
                    tabs: const [
                      Text('Feeds'),
                      Text('Forum'),
                      Text('Receipe'),
                    ]),
              ),
              const Divider(
                height: 0.9,
                color: dividerColor,
              ),
              const SizedBox(
                height: 27.5,
              ),
              Expanded(
                child: TabBarView(controller: _tabController, children: [
                  StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('feeds')
                          .where("uid", isEqualTo: widget.uid)
                          .snapshots(),
                      builder: (context,
                          AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                        if (streamSnapshot.hasData) {
                          return streamSnapshot.data!.docs.isNotEmpty
                              ? GridView.builder(
                                  itemCount: streamSnapshot.data!.docs.length,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          mainAxisSpacing: 18.h,
                                          crossAxisSpacing: 18.w,
                                          crossAxisCount: 3),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    final DocumentSnapshot documentSnapshot =
                                        streamSnapshot.data!.docs[index];
                                    return GestureDetector(
                                        onTap: () {
                                          // Navigator.push(context,
                                          //     MaterialPageRoute(builder: (context) {
                                          //   return BlogDetail(
                                          //     content: documentSnapshot['description'],
                                          //     image: documentSnapshot['feedphoto'],
                                          //     title: documentSnapshot['title'],
                                          //   );
                                          // }));
                                        },
                                        child: OptimizedCacheImage(
                                          imageUrl:
                                              documentSnapshot['feedphoto'][0],
                                          imageBuilder:
                                              (context, imageprovider) {
                                            return Container(
                                              width: 118.w,
                                              height: 126.h,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.r),
                                                  image: DecorationImage(
                                                      image: imageprovider,
                                                      fit: BoxFit.cover)),
                                            );
                                          },
                                        ));
                                  },
                                )
                              : const Center(
                                  child: Text('No posts yet'),
                                );
                        } else {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                      }),
                  StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('questions')
                          .where("uid", isEqualTo: widget.uid)
                          .snapshots(),
                      builder: (context,
                          AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                        if (streamSnapshot.hasData) {
                          return streamSnapshot.data!.docs.isNotEmpty
                              ? ListView.builder(
                                  physics: const BouncingScrollPhysics(),
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  itemCount: streamSnapshot.data!.docs.length,
                                  itemBuilder: (context, index) {
                                    final DocumentSnapshot documentSnapshot =
                                        streamSnapshot.data!.docs[index];

                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return ForumDetails(
                                            question:
                                                documentSnapshot['description'],
                                            skeptic:
                                                documentSnapshot['username'],
                                            totalreplies: '',
                                            questionId:
                                                documentSnapshot['postId'],
                                          );
                                        }));
                                      },
                                      child: ForumsWidget(
                                        question:
                                            documentSnapshot['description'],
                                        skeptic: documentSnapshot['username'],
                                        postId: documentSnapshot['postId'],
                                      ),
                                    );
                                  })
                              : Center(
                                  child: Container(
                                    child: const Text("No Posts yet"),
                                  ),
                                );
                        } else {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                      }),
                  StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('blogs')
                          .where("uid", isEqualTo: widget.uid)
                          .snapshots(),
                      builder: (context,
                          AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                        if (streamSnapshot.hasData) {
                          return streamSnapshot.data!.docs.isNotEmpty
                              ? GridView.builder(
                                  scrollDirection: Axis.vertical,
                                  itemCount: streamSnapshot.data!.docs.length,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          mainAxisSpacing: 0.h,
                                          crossAxisSpacing: 18.w,
                                          crossAxisCount: 2),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    final DocumentSnapshot documentSnapshot =
                                        streamSnapshot.data!.docs[index];
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return BlogDetail(
                                            likes: documentSnapshot['likes'],
                                            postId: documentSnapshot['postId'],
                                          );
                                        }));
                                      },
                                      child: ReceipeWidget(
                                        content:
                                            documentSnapshot['description'],
                                        image: documentSnapshot['feedphoto'],
                                        title: documentSnapshot['title'],
                                      ),
                                    );
                                  },
                                )
                              : const Center(
                                  child: Text('No posts yet'),
                                );
                        } else {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                      }),
                ]),
              )
            ],
          ),
        ),
      ),
    );
  }
}
