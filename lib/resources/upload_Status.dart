import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:halenest/models/user_model.dart';
import 'package:halenest/provider/user_provider.dart';
import 'package:halenest/resources/status_methods.dart';
import 'package:halenest/util/utils.dart';

import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class UploadStatus extends StatefulWidget {
  const UploadStatus({Key? key}) : super(key: key);

  @override
  State<UploadStatus> createState() => _UploadStatusState();
}

class _UploadStatusState extends State<UploadStatus> {
  Uint8List? storyImage;

  selectImageForStories() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    // set state because we need to display the image we selected on the circle avatar
    setState(() {
      storyImage = im;
    });
  }

  @override
  Widget build(BuildContext context) {
    UserModel user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: IconButton(
                onPressed: () => selectImageForStories(),
                icon: SvgPicture.asset('assets/icons/attachment.svg')),
          ),
          Center(
            child: TextButton(
                onPressed: () {
                  StatusRepository(
                          firestore: FirebaseFirestore.instance,
                          auth: FirebaseAuth.instance)
                      .uploadStatus(
                          username: user.username,
                          profilePic: user.profilePhoto!,
                          statusImage: storyImage!,
                          context: context);
                },
                child: const Text("Upload status")),
          ),
        ],
      ),
    );
  }
}
