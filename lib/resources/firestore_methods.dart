import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:halenest/models/blog_model.dart';
import 'package:halenest/models/feed_model.dart';
import 'package:halenest/models/forum_model.dart';
import 'package:halenest/models/health_model.dart';
import 'package:halenest/models/message_model.dart';
import 'package:halenest/models/user_model.dart';
import 'package:halenest/models/video_model.dart';
import 'package:halenest/resources/storage_method.dart';
import 'package:halenest/util/utils.dart';

import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  //* upload stories

  //* updates followers list
  Future<void> followUser(String uid, String followId) async {
    try {
      DocumentSnapshot snap =
          await firestore.collection('users').doc(uid).get();
      List following = (snap.data()! as dynamic)['following'];

      if (following.contains(followId)) {
        await firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayRemove([uid])
        });

        await firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([followId])
        });
      } else {
        await firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayUnion([uid])
        });

        await firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([followId])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  //* updates feeds likes
  Future<void> updateLikes(
      String postId, String uid, List likes, context) async {
    try {
      if (likes.contains(uid)) {
        await firebaseFirestore.collection('feeds').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        await firebaseFirestore.collection('feeds').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
    } catch (error) {
      showSnackBar(error.toString(), context);
    }
  }

//* updates blogs likes
  Future<void> updateBlogLikes(
      String postId, String uid, List likes, context) async {
    try {
      if (likes.contains(uid)) {
        await firebaseFirestore.collection('blogs').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid]),
          'popularity': FieldValue.increment(-10),
        });
      } else {
        await firebaseFirestore.collection('blogs').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid]),
          'popularity': FieldValue.increment(10),
        });
      }
    } catch (error) {
      showSnackBar(error.toString(), context);
    }
  }

  //* stores health Data
  Future<String> storeHealthData(
      String dayFormat,
      String calorie,
      String uid,
      String day,
      String protein,
      String carbs,
      String fiber,
      String sodium,
      String cholesterolMg,
      String fatSaturatedG,
      String potassiumMg,
      double servingSizeG,
      String name,
      String sugarG,
      String fat) async {
    String res = "Some error occurred";
    try {
      if (calorie.isNotEmpty && day.isNotEmpty && protein.isNotEmpty) {
        String postId = const Uuid().v1();
        final DateTime now = DateTime.now();
        final DateFormat formatter = DateFormat('yyyy-MM-dd');
        DateFormat('yyyy-MM-dd')
            .format(DateTime.now().subtract(const Duration(days: 7)));
        final String formatted = formatter.format(now);
        HealthModel data = HealthModel(
            postId: postId,
            serving_size_g: servingSizeG,
            name: name,
            cholesterol_mg: cholesterolMg,
            fat_saturated_g: fatSaturatedG,
            potassium_mg: potassiumMg,
            sugar_g: sugarG,
            calories: calorie,
            carbohydrates_total_g: carbs,
            fat_total_g: fat,
            sodium_mg: sodium,
            fiber_g: fiber,
            protein_g: protein,
            uid: uid,
            createdAt: DateTime.now());
        await firebaseFirestore
            .collection('healthData')
            .doc(uid)
            .collection(dayFormat)
            .doc(postId)
            .set(data.toJson());
        res = "success";
      }
    } catch (error) {
      res = error.toString();
    }
    return res;
  }

  //* Upload Feed Method
  Future<String> uploadFeed(
      {required List<XFile> feedphoto,
      required String description,
      List<String>? tags,
      required String email,
      required String username,
      required String profilePhoto,
      required String uid}) async {
    String res = 'some error occurred';
    try {
      if (feedphoto.isNotEmpty && description.isNotEmpty) {
        List<String> photoUrl =
            await StorageMethod().multipleImageUploader(feedphoto);
        String postId = const Uuid().v1();
        FeedModel feed = FeedModel(
            datePublished: DateTime.now(),
            description: description,
            email: email,
            feedphoto: photoUrl,
            postId: postId,
            profilePhoto: profilePhoto,
            uid: uid,
            username: username,
            likes: [],
            tags: []);
        await firebaseFirestore
            .collection('feeds')
            .doc(postId)
            .set(feed.toJson());
        res = "success";
      } else {
        res = "Please input all fields";
      }
    } catch (error) {
      res = error.toString();
    }

    return res;
  }

  //* UPLOAD QUESTION

  Future<String> uploadQuestion(
      {required String description,
      List<String>? tags,
      required String email,
      required String username,
      required String profilePhoto,
      required String uid}) async {
    String res = 'some error occurred';
    try {
      if (description.isNotEmpty) {
        String postId = const Uuid().v1();
        ForumModel forum = ForumModel(
            datePublished: DateTime.now(),
            question: description,
            email: email,
            postId: postId,
            profilePhoto: profilePhoto,
            uid: uid,
            username: username,
            tags: []);
        await firebaseFirestore
            .collection('questions')
            .doc(postId)
            .set(forum.toJson());
        res = "success";
      } else {
        res = "Please input all fields";
      }
    } catch (error) {
      res = error.toString();
    }

    return res;
  }

//* UPLOAD RECEIPE BLOG
  Future<String> uploadBlog(
      {required Uint8List feedphoto,
      required String description,
      List<String>? tags,
      required String email,
      required String username,
      required String title,
      required String profilePhoto,
      required String uid}) async {
    String res = 'some error occurred';
    try {
      if (feedphoto.isNotEmpty && description.isNotEmpty) {
        String photoUrl = await StorageMethod()
            .uploadImagetoStorage('blogs', feedphoto, true);
        String postId = const Uuid().v1();
        BlogModel blog = BlogModel(
            datePublished: DateTime.now(),
            description: description,
            email: email,
            thumbnail: photoUrl,
            title: title,
            postId: postId,
            profilePhoto: profilePhoto,
            uid: uid,
            username: username,
            likes: [],
            tags: [],
            popularity: 0);
        await firebaseFirestore
            .collection('blogs')
            .doc(postId)
            .set(blog.toJson());
        res = "success";
      } else {
        res = "Please input all fields";
      }
    } catch (error) {
      res = error.toString();
    }

    return res;
  }

  //* Upload shorts
  Future<String> uploadVideo(
      {required File videofile,
      required String caption,
      required String uid,
      required String username,
      required String profileImg}) async {
    String res = "some error occurred";
    try {
      String postId = const Uuid().v1();
      String videoUrl =
          await StorageMethod().uploadVideoToStorage(videofile, true);
      // String thumbnail = await StorageMethod()
      //     .uploadThumbnailToStorage("Video $len", videoPath);

      VideoModel video = VideoModel(
        profileImg: profileImg,
        video: videoUrl,
        username: username,
        uid: uid,
        id: postId,
        likes: [],
        commentCount: 0,
        shareCount: 0,
        caption: caption,
      );

      await firestore.collection('videos').doc(postId).set(
            video.toJson(),
          );
      res = "success";
    } catch (error) {
      res = error.toString();
    }
    return res;
  }

  //*upload comments

  Future<String> postComment(String postId, String text, String uid,
      String name, String profilePic) async {
    String res = "Some error occurred";
    try {
      if (text.isNotEmpty) {
        // if the likes list contains the user uid, we need to remove it
        String commentId = const Uuid().v1();
        firestore
            .collection('feeds')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'profilePic': profilePic,
          'name': name,
          'uid': uid,
          'text': text,
          'commentId': commentId,
          'datePublished': DateTime.now(),
        });
        res = 'success';
      } else {
        res = "Please enter text";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  //*upload answers

  Future<String> postAnswer(String questionId, String text, String uid,
      String name, String profilePic) async {
    String res = "Some error occurred";
    try {
      if (text.isNotEmpty) {
        // if the likes list contains the user uid, we need to remove it
        String answersId = const Uuid().v1();
        firestore
            .collection('questions')
            .doc(questionId)
            .collection('answers')
            .doc(answersId)
            .set({
          'profilePic': profilePic,
          'name': name,
          'uid': uid,
          'text': text,
          'answerId': answersId,
          'datePublished': DateTime.now(),
        });
        res = 'success';
      } else {
        res = "Please enter text";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future addMessageToDb(
      Message message, UserModel sender, UserModel receiver) async {
    var map = message.toJson();

    await firestore.collection('users').doc(sender.uid).update({
      'contacts': FieldValue.arrayUnion([receiver.uid])
    });
    await firestore.collection('users').doc(receiver.uid).update({
      'contacts': FieldValue.arrayUnion([sender.uid])
    });
    await firestore
        .collection("messages")
        .doc(message.senderId)
        .collection(message.receiverId)
        .add(map);

    return await firestore
        .collection("messages")
        .doc(message.receiverId)
        .collection(message.senderId)
        .add(map);
  }

  Future<String> deletePost(String postId) async {
    String res = "Some error occurred";
    try {
      await firestore.collection('feeds').doc(postId).delete();
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
