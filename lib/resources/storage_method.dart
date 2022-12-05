// ignore_for_file: unused_element

import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class StorageMethod {
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<List<String>> multipleImageUploader(List<XFile> list) async {
    List<String> path = [];
    for (XFile file in list) {
      path.add(await uploadImage(file, "feeds", true));
    }
    return path;
  }

  Future<String> uploadImage(XFile image, String childname, bool isPost) async {
    Reference ref =
        firebaseStorage.ref().child(childname).child(_auth.currentUser!.uid);

    if (isPost == true) {
      String uid = const Uuid().v1();
      ref = ref.child(uid);
    }
    await ref.putFile(File(image.path));
    return await ref.getDownloadURL();
  }

  Future<List<String>> uploadMultipleImage(List<File> list) async {
    List<String> path = [];
    for (File? image in list) {
      path.add(await uploadFeedImagetoStorage('feeds', image!, true));
    }
    return path;
  }

  Future<String> uploadFeedImagetoStorage(
      String childname, File file, bool isPost) async {
    Reference ref =
        firebaseStorage.ref().child(childname).child(_auth.currentUser!.uid);

    if (isPost == true) {
      String uid = const Uuid().v1();
      ref = ref.child(uid);
    }
    UploadTask uploadTask = ref.putFile(file);
    TaskSnapshot taskSnapshot = await uploadTask;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  //* Upload image for feeds, forums, blogs

  Future<String> uploadImagetoStorage(
      String childname, Uint8List? file, bool isPost) async {
    Reference ref =
        firebaseStorage.ref().child(childname).child(_auth.currentUser!.uid);

    if (isPost == true) {
      String uid = const Uuid().v1();
      ref = ref.child(uid);
    }
    UploadTask uploadTask = ref.putData(file!);
    TaskSnapshot taskSnapshot = await uploadTask;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  //* Upload shorts

  Future<String> uploadVideoToStorage(File file, bool isPost) async {
    Reference ref =
        firebaseStorage.ref().child('videos').child(_auth.currentUser!.uid);
    if (isPost == true) {
      String uid = const Uuid().v1();
      ref = ref.child(uid);
    }
    UploadTask uploadTask = ref.putFile(file);
    TaskSnapshot taskSnapshot = await uploadTask;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }
}
