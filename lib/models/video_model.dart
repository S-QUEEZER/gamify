import 'package:cloud_firestore/cloud_firestore.dart';

class VideoModel {
  String username;
  String uid;
  String id;
  List likes;
  int commentCount;
  int shareCount;

  String video;
  String caption;
  String profileImg;

  VideoModel(
      {required this.username,
      required this.uid,
      required this.profileImg,
      required this.id,
      required this.likes,
      required this.commentCount,
      required this.shareCount,
      required this.caption,
      required this.video});

  Map<String, dynamic> toJson() => {
        "video": video,
        "profileImg": profileImg,
        "username": username,
        "uid": uid,
        "id": id,
        "likes": likes,
        "commentCount": commentCount,
        "shareCount": shareCount,
        "caption": caption,
      };

  static VideoModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return VideoModel(
      profileImg: snapshot['profileImg'],
      video: snapshot['video'],
      username: snapshot['username'],
      uid: snapshot['uid'],
      id: snapshot['id'],
      likes: snapshot['likes'],
      commentCount: snapshot['commentCount'],
      shareCount: snapshot['shareCount'],
      caption: snapshot['caption'],
    );
  }
}
