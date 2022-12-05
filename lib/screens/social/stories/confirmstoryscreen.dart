// ignore_for_file: unused_local_variable

import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:halenest/models/user_model.dart';
import 'package:halenest/provider/user_provider.dart';
import 'package:halenest/resources/status_methods.dart';
import 'package:halenest/util/colors.dart';
import 'package:halenest/util/utils.dart';
import 'package:provider/provider.dart';

class ConfirmStoryUpload extends StatefulWidget {
  final Uint8List file;
  const ConfirmStoryUpload({Key? key, required this.file}) : super(key: key);

  @override
  State<ConfirmStoryUpload> createState() => _ConfirmStoryUploadState();
}

class _ConfirmStoryUploadState extends State<ConfirmStoryUpload> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    UserModel user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.close_rounded,
                size: 30,
              )),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              isLoading
                  ? const LinearProgressIndicator(
                      color: primaryColor,
                      backgroundColor: Colors.white,
                    )
                  : Container(),
              Container(
                alignment: Alignment.bottomCenter,
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: MemoryImage(widget.file), fit: BoxFit.cover)),
                child: Padding(
                  padding: EdgeInsets.only(bottom: 30.h),
                  child: InkWell(
                      onTap: () async {
                        setState(() {
                          isLoading = true;
                        });
                        String res = await StatusRepository(
                                firestore: FirebaseFirestore.instance,
                                auth: FirebaseAuth.instance)
                            .uploadStatus(
                                username: user.username,
                                profilePic: user.profilePhoto!,
                                statusImage: widget.file,
                                context: context);
                        if (res == "success") {
                          Navigator.pop(context);
                          setState(() {
                            isLoading = false;
                          });
                        } else {
                          showSnackBar("Some error occurred", context);
                          setState(() {
                            isLoading = false;
                          });
                        }
                      },
                      child: const Text("Upload story")),
                ),
              ),
            ],
          ),
        ));
  }
}
