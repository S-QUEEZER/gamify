import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:halenest/models/status_model.dart';

import 'package:halenest/resources/storage_method.dart';
import 'package:halenest/util/utils.dart';
import 'package:uuid/uuid.dart';

class StatusRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  StatusRepository({
    required this.firestore,
    required this.auth,
  });

  Future<String> uploadStatus({
    required String username,
    required String profilePic,
    required Uint8List statusImage,
    required BuildContext context,
  }) async {
    String res = "Some error occurred";
    try {
      var statusId = const Uuid().v1();
      String uid = auth.currentUser!.uid;
      String imageurl = await StorageMethod()
          .uploadImagetoStorage('statusImages', statusImage, true);

      List<String> statusImageUrls = [];
      var statusesSnapshot = await firestore
          .collection('status')
          .where(
            'uid',
            isEqualTo: auth.currentUser!.uid,
          )
          .get();

      if (statusesSnapshot.docs.isNotEmpty) {
        Status status = Status.fromMap(statusesSnapshot.docs[0].data());
        statusImageUrls = status.photoUrl;
        statusImageUrls.add(imageurl);
        await firestore
            .collection('status')
            .doc(statusesSnapshot.docs[0].id)
            .update({
          'photoUrl': statusImageUrls,
        });
      } else {
        statusImageUrls = [imageurl];
      }

      Status status = Status(
        uid: uid,
        username: username,
        photoUrl: statusImageUrls,
        createdAt: DateTime.now(),
        profilePic: profilePic,
        statusId: statusId,
      );

      await firestore.collection('status').doc(statusId).set(status.toMap());
      res = "success";
      return res;
    } catch (e) {
      return res;
    }
  }

  //* get status

  Future<List<Status>> getStatus(BuildContext context) async {
    List<Status> statusData = [];
    try {
      var statusesSnapshot = await firestore
          .collection('status')
          .where(
            'createdAt',
            isGreaterThan: DateTime.now()
                .subtract(const Duration(hours: 24))
                .millisecondsSinceEpoch,
          )
          .get();
      for (var tempData in statusesSnapshot.docs) {
        Status tempStatus = Status.fromMap(tempData.data());
        statusData.add(tempStatus);
      }
    } catch (e) {
      if (kDebugMode) print(e);
      showSnackBar(
        e.toString(),
        context,
      );
    }
    return statusData;
  }
}
