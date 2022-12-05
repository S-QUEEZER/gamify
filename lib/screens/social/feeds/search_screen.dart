import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:halenest/models/user_model.dart';
import 'package:halenest/screens/profile/profile.dart';

import 'package:optimized_cached_image/optimized_cached_image.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  bool isShowUsers = false;
  String query = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
        title: Form(
          child: TextField(
            controller: searchController,
            decoration: const InputDecoration(
                hintText: 'Search for a user...', border: InputBorder.none),
            onChanged: (String value) {
              setState(() {
                query = value;
                isShowUsers = true;
              });
            },
          ),
        ),
      ),
      body: query.isNotEmpty
          ? Padding(
              padding: EdgeInsets.only(top: 5.h),
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .where('username', isGreaterThan: query)
                    .snapshots(),
                builder:
                    (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                  if (streamSnapshot.hasData) {
                    return streamSnapshot.data!.docs.isNotEmpty
                        ? ListView.builder(
                            itemCount: streamSnapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              final DocumentSnapshot documentSnapshot =
                                  streamSnapshot.data!.docs[index];
                              UserModel receiver = UserModel(
                                  email: documentSnapshot['email'],
                                  followers: documentSnapshot['followers'],
                                  following: documentSnapshot['following'],
                                  profilePhoto:
                                      documentSnapshot['profilePhoto'],
                                  uid: documentSnapshot['uid'],
                                  username: documentSnapshot['username']);
                              if (documentSnapshot['username']
                                  .toString()
                                  .startsWith(query)) {
                                return InkWell(
                                  onTap: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => ProfileScreen(
                                        receiver: receiver,
                                        uid: documentSnapshot['uid'],
                                        profileImg:
                                            documentSnapshot['profilePhoto'],
                                        bio: documentSnapshot['bio'],
                                        username: documentSnapshot['username'],
                                      ),
                                    ),
                                  ),
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundImage: NetworkImage(
                                          documentSnapshot['profilePhoto']),
                                      radius: 16,
                                    ),
                                    title: Text(
                                      documentSnapshot['username'],
                                    ),
                                  ),
                                );
                              } else {
                                return Container();
                              }
                            },
                          )
                        : Container();
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              ),
            )
          : Padding(
              padding: EdgeInsets.only(top: 10.0.h),
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('feeds')
                    .orderBy('datetime')
                    .limit(55)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return StaggeredGridView.countBuilder(
                      crossAxisCount: 3,
                      itemCount: (snapshot.data! as dynamic).docs.length,
                      itemBuilder: (context, index) => OptimizedCacheImage(
                        imageUrl: (snapshot.data! as dynamic).docs[index]
                            ['feedphoto'][0],
                        imageBuilder: (context, imageProvider) {
                          return Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: imageProvider, fit: BoxFit.cover),
                                borderRadius: BorderRadius.circular(5.r)),
                            // child: Image.network(
                            //   (snapshot.data! as dynamic).docs[index]['feedphoto'],
                            //   fit: BoxFit.cover,
                            // ),
                          );
                        },
                      ),
                      staggeredTileBuilder: (index) => StaggeredTile.count(
                          (index % 7 == 0) ? 2 : 1, (index % 7 == 0) ? 2 : 1),
                      mainAxisSpacing: 8.0,
                      crossAxisSpacing: 8.0,
                    );
                  }
                },
              ),
            ),
    );
  }
}
