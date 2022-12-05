import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:halenest/models/status_model.dart';
import 'package:halenest/models/user_model.dart';
import 'package:halenest/provider/user_provider.dart';
import 'package:halenest/resources/status_methods.dart';
import 'package:halenest/screens/profile/profile.dart';
import 'package:halenest/screens/social/blogs/blog_details.dart';
import 'package:halenest/screens/social/forums/forum_detail.dart';
import 'package:halenest/screens/social/stories/stories.dart';

import 'package:optimized_cached_image/optimized_cached_image.dart';
import 'package:provider/provider.dart';

class TrendingScreen extends StatefulWidget {
  const TrendingScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<TrendingScreen> createState() => _TrendingScreenState();
}

class _TrendingScreenState extends State<TrendingScreen> {
  Future<List<Status>> getStatus(
    BuildContext context,
  ) async {
    List<Status> statuses = await StatusRepository(
            auth: FirebaseAuth.instance, firestore: FirebaseFirestore.instance)
        .getStatus(
      context,
    );
    return statuses;
  }

  String uid1 = "1BkAmve42IPdwhIBwCLZ5vZRx5P2";
  String uid2 = "hPCddRyBBAcdm5cOrWkZXZuKyea2";
  @override
  Widget build(BuildContext context) {
    UserModel user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'GAMIFY',
          style: TextStyle(
              color: const Color(0xff101928),
              fontFamily: 'BerlinSans',
              fontSize: 18.sp,
              letterSpacing: 0.3,
              fontWeight: FontWeight.w600),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20.0.w),
            child: GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return ProfileScreen(
                    bio: user.bio!,
                    profileImg: user.profilePhoto!,
                    uid: user.uid,
                    username: user.username,
                  );
                }));
              },
              child: CachedNetworkImage(
                fadeOutDuration: const Duration(microseconds: 200),
                imageUrl: user.profilePhoto!,
                imageBuilder: (context, imageProvider) => Container(
                  width: 26.w,
                  height: 26.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: imageProvider, fit: BoxFit.cover),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            left: 20.0.w,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 5.h,
              ),
              Text(
                'Hello ${user.username},',
                style: TextStyle(
                    fontFamily: 'Helvetica-Bold',
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xff3F414E)),
              ),
              SizedBox(
                height: 15.h,
              ),
              Text(
                'Its good to see you',
                style: TextStyle(
                    fontFamily: 'RobotoRegular',
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0XFFA1A4B2)),
              ),
              SizedBox(height: 27.h),
              FutureBuilder<List<Status>>(
                  future: getStatus(
                    context,
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return SizedBox(
                        height: 210.h,
                        child: ListView.builder(
                          itemCount: snapshot.data!.length,
                          scrollDirection: Axis.horizontal,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            var statusData = snapshot.data![index];
                            if (statusData.uid == uid1 ||
                                statusData.uid == uid2) {
                              return Padding(
                                padding: EdgeInsets.only(right: 20.0.w),
                                child: Container(
                                  height: 210.h,
                                  width: 177.w,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.r),
                                      image: DecorationImage(
                                          image: AssetImage(index == 0
                                              ? "assets/images/Container1.png"
                                              : "assets/images/Container2.png"),
                                          fit: BoxFit.cover)),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: 14.5.w, bottom: 15.h),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(left: 95.w),
                                          child: Container(
                                            height: 56.h,
                                            width: 56.w,
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image: NetworkImage(
                                                        statusData.profilePic
                                                            .toString()),
                                                    fit: BoxFit.cover),
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                    width: 2.w,
                                                    color: const Color(
                                                        0xffF08769))),
                                          ),
                                        ),
                                        Text(
                                          statusData.username.toString(),
                                          style: TextStyle(
                                              fontFamily: 'Helvetica-Regular',
                                              fontWeight: FontWeight.w700,
                                              fontSize: 18.sp,
                                              letterSpacing: 0.6,
                                              color: index == 0
                                                  ? const Color(0xffDBDAED)
                                                  : const Color(0xff3F414E)),
                                        ),
                                        SizedBox(
                                          height: 10.h,
                                        ),
                                        Text(
                                          'A feeble body weakens the mind',
                                          style: TextStyle(
                                              fontFamily: 'Helvetica-Regular',
                                              fontWeight: FontWeight.w400,
                                              fontSize: 11.sp,
                                              letterSpacing: 0.6,
                                              color: index == 0
                                                  ? const Color(0xffDBDAED)
                                                  : const Color(0xff3F414E)),
                                        ),
                                        SizedBox(
                                          height: 23.h,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              'New story',
                                              style: TextStyle(
                                                  fontFamily:
                                                      'Helvetica-Regular',
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 11.sp,
                                                  letterSpacing: 0.6,
                                                  color: index == 0
                                                      ? const Color(0xffDBDAED)
                                                      : const Color(
                                                          0xff3F414E)),
                                            ),
                                            SizedBox(
                                              width: 27.w,
                                            ),
                                            InkWell(
                                              onTap: () {
                                                Navigator.push(context,
                                                    MaterialPageRoute(
                                                        builder: (context) {
                                                  return StatusScreen(
                                                      status: statusData);
                                                }));
                                              },
                                              child: Container(
                                                alignment: Alignment.center,
                                                height: 35.h,
                                                width: 70.w,
                                                decoration: BoxDecoration(
                                                    color:
                                                        const Color(0xffF08769),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            29.r)),
                                                child: Text(
                                                  'WATCH',
                                                  style: TextStyle(
                                                      fontFamily:
                                                          'Helvetica-Regular',
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 12.sp,
                                                      letterSpacing: 0.6,
                                                      color: Colors.white),
                                                ),
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              return Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.r),
                                    image: DecorationImage(
                                        image: AssetImage(index == 0
                                            ? "assets/images/Container1.png"
                                            : "assets/images/Container2.png"),
                                        fit: BoxFit.cover)),
                              );
                            }
                          },
                        ),
                      );
                    } else {
                      return Row(
                        children: [
                          Container(
                            height: 210.h,
                            width: 177.w,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.r),
                                image: const DecorationImage(
                                    image: AssetImage(
                                        "assets/images/Container1.png"),
                                    fit: BoxFit.cover)),
                            child: Padding(
                              padding:
                                  EdgeInsets.only(left: 14.5.w, bottom: 15.h),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 95.w),
                                    child: Container(
                                      height: 56.h,
                                      width: 56.w,
                                      decoration: BoxDecoration(
                                          image: const DecorationImage(
                                              image: NetworkImage(
                                                  "https://i.stack.imgur.com/l60Hf.png"),
                                              fit: BoxFit.cover),
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              width: 2.w,
                                              color: const Color(0xffF08769))),
                                    ),
                                  ),
                                  Text(
                                    "",
                                    style: TextStyle(
                                        fontFamily: 'Helvetica-Regular',
                                        fontWeight: FontWeight.w700,
                                        fontSize: 18.sp,
                                        letterSpacing: 0.6,
                                        color: const Color(0xffDBDAED)),
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  Text(
                                    'To enjoy the glow of good health, you must exercise.',
                                    style: TextStyle(
                                        fontFamily: 'Helvetica-Regular',
                                        fontWeight: FontWeight.w400,
                                        fontSize: 11.sp,
                                        letterSpacing: 0.6,
                                        color: const Color(0xffDBDAED)),
                                  ),
                                  SizedBox(
                                    height: 23.h,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        'New story',
                                        style: TextStyle(
                                            fontFamily: 'Helvetica-Regular',
                                            fontWeight: FontWeight.w500,
                                            fontSize: 11.sp,
                                            letterSpacing: 0.6,
                                            color: const Color(0xffDBDAED)),
                                      ),
                                      SizedBox(
                                        width: 27.w,
                                      ),
                                      InkWell(
                                        child: Container(
                                          alignment: Alignment.center,
                                          height: 35.h,
                                          width: 70.w,
                                          decoration: BoxDecoration(
                                              color: const Color(0xffF08769),
                                              borderRadius:
                                                  BorderRadius.circular(29.r)),
                                          child: Text(
                                            'WATCH',
                                            style: TextStyle(
                                                fontFamily: 'Helvetica-Regular',
                                                fontWeight: FontWeight.w500,
                                                fontSize: 12.sp,
                                                letterSpacing: 0.6,
                                                color: Colors.white),
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 20.w,
                          ),
                          Container(
                            height: 210.h,
                            width: 177.w,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.r),
                                image: const DecorationImage(
                                    image: AssetImage(
                                        "assets/images/Container2.png"),
                                    fit: BoxFit.cover)),
                            child: Padding(
                              padding:
                                  EdgeInsets.only(left: 14.5.w, bottom: 15.h),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 95.w),
                                    child: Container(
                                      height: 56.h,
                                      width: 56.w,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                  "https://i.stack.imgur.com/l60Hf.png"
                                                      .toString()),
                                              fit: BoxFit.cover),
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              width: 2.w,
                                              color: const Color(0xffF08769))),
                                    ),
                                  ),
                                  Text(
                                    "",
                                    style: TextStyle(
                                        fontFamily: 'Helvetica-Regular',
                                        fontWeight: FontWeight.w700,
                                        fontSize: 18.sp,
                                        letterSpacing: 0.6,
                                        color: const Color(0xff3F414E)),
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  Text(
                                    '',
                                    style: TextStyle(
                                        fontFamily: 'Helvetica-Regular',
                                        fontWeight: FontWeight.w400,
                                        fontSize: 11.sp,
                                        letterSpacing: 0.6,
                                        color: const Color(0xff3F414E)),
                                  ),
                                  SizedBox(
                                    height: 23.h,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        'New story',
                                        style: TextStyle(
                                            fontFamily: 'Helvetica-Regular',
                                            fontWeight: FontWeight.w500,
                                            fontSize: 11.sp,
                                            letterSpacing: 0.6,
                                            color: const Color(0xff3F414E)),
                                      ),
                                      SizedBox(
                                        width: 27.w,
                                      ),
                                      InkWell(
                                        // onTap: () {
                                        //   Navigator.push(context,
                                        //       MaterialPageRoute(
                                        //           builder: (context) {
                                        //     return StatusScreen(
                                        //         status: statusData);
                                        //   }));
                                        // },
                                        child: Container(
                                          alignment: Alignment.center,
                                          height: 35.h,
                                          width: 70.w,
                                          decoration: BoxDecoration(
                                              color: const Color(0xffF08769),
                                              borderRadius:
                                                  BorderRadius.circular(29.r)),
                                          child: Text(
                                            'WATCH',
                                            style: TextStyle(
                                                fontFamily: 'Helvetica-Regular',
                                                fontWeight: FontWeight.w500,
                                                fontSize: 12.sp,
                                                letterSpacing: 0.6,
                                                color: Colors.white),
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      );
                    }
                  }),
              SizedBox(
                height: 20.h,
              ),
              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('questions')
                      .orderBy('datetime', descending: true)
                      .limit(1)
                      .snapshots(),
                  builder:
                      (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                    if (streamSnapshot.hasData) {
                      var documentSnapshot = streamSnapshot.data!.docs[0];
                      return streamSnapshot.data!.docs.isNotEmpty
                          ? Container(
                              width: 374.w,
                              height: 95.h,
                              decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(10.r),
                                  image: const DecorationImage(
                                      image: AssetImage(
                                          "assets/images/Container.png"),
                                      fit: BoxFit.cover)),
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: 30.0.w, right: 30.0.w),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: 235.w,
                                          child: Text(
                                            documentSnapshot['description'],
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: TextStyle(
                                                fontFamily: 'Helvetica-Regular',
                                                fontWeight: FontWeight.w700,
                                                fontSize: 18.sp,
                                                letterSpacing: 0.6,
                                                color: Colors.white),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10.h,
                                        ),
                                        Text(
                                          'By @${documentSnapshot["username"]}',
                                          style: TextStyle(
                                              fontFamily: 'Helvetica-Regular',
                                              fontWeight: FontWeight.w700,
                                              fontSize: 11.sp,
                                              letterSpacing: 0.6,
                                              color: Colors.white),
                                        )
                                      ],
                                    ),
                                    InkWell(
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
                                      child: Container(
                                          alignment: Alignment.center,
                                          height: 33.h,
                                          width: 75.w,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(29.r)),
                                          child: Text(
                                            'Answer',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontFamily: 'Poppins-Regular',
                                                fontWeight: FontWeight.w500,
                                                fontSize: 11.sp),
                                          )),
                                    )
                                  ],
                                ),
                              ),
                            )
                          : Center(
                              child: Container(
                                child: const Text("No Posts yet"),
                              ),
                            );
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  }),
              SizedBox(
                height: 46.h,
              ),
              Text(
                "Trending Blogs",
                style: TextStyle(
                    fontFamily: 'Poppins-Regular',
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xff3F414E)),
              ),
              SizedBox(
                height: 22.h,
              ),
              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('blogs')
                      .orderBy("popularity", descending: true)
                      .limit(10)
                      .snapshots(),
                  builder:
                      (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                    if (streamSnapshot.hasData) {
                      return SizedBox(
                        height: 220.h,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: streamSnapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              var documentSnapshot =
                                  streamSnapshot.data!.docs[index];
                              return InkWell(
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return BlogDetail(
                                      likes: documentSnapshot['likes'],
                                      postId: documentSnapshot['postId'],
                                    );
                                  }));
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                        padding: EdgeInsets.only(right: 20.0.w),
                                        child: OptimizedCacheImage(
                                          progressIndicatorBuilder:
                                              (context, url, downloadProgress) {
                                            return SizedBox(
                                              width: 162.h,
                                              height: 113.w,
                                            );
                                          },
                                          imageUrl:
                                              documentSnapshot['feedphoto'],
                                          imageBuilder:
                                              (context, imageprovider) {
                                            return Container(
                                              width: 162.h,
                                              height: 113.w,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.r),
                                                  image: DecorationImage(
                                                      image: imageprovider,
                                                      fit: BoxFit.fill)),
                                            );
                                          },
                                        )),
                                    SizedBox(
                                      height: 11.h,
                                    ),
                                    SizedBox(
                                      width: 162.h,
                                      child: Text(
                                        documentSnapshot['title'],
                                        maxLines: 1,
                                        style: TextStyle(
                                            fontFamily: 'Helvetica-Regular',
                                            fontWeight: FontWeight.w700,
                                            fontSize: 18.sp,
                                            letterSpacing: 0.6,
                                            overflow: TextOverflow.ellipsis,
                                            color: const Color(0xff3F414E)),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 6.h,
                                    ),
                                    Text(
                                      "by @${documentSnapshot["username"]}",
                                      style: TextStyle(
                                          fontFamily: 'Poppins-Regular',
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w500,
                                          color: const Color(0xffA1A4B2)),
                                    ),
                                  ],
                                ),
                              );
                            }),
                      );
                    } else {
                      return const CircularProgressIndicator();
                    }
                  }),
              SizedBox(
                height: 100.h,
              )
            ],
          ),
        ),
      ),
    );
  }
}
