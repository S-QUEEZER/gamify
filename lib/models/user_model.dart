import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String username;
  final String email;
  final String uid;
  final List followers;
  final List following;
  final String? profilePhoto;
  final String? bio;
  final List? contacts;

  UserModel(
      {this.bio,
      this.contacts,
      required this.email,
      required this.followers,
      required this.following,
      required this.profilePhoto,
      required this.uid,
      required this.username});

  static UserModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return UserModel(
      contacts: snapshot['contacts'],
      username: snapshot["username"],
      uid: snapshot["uid"],
      email: snapshot["email"],
      bio: snapshot["bio"],
      followers: snapshot["followers"],
      following: snapshot["following"],
      profilePhoto: snapshot['profilePhoto'],
    );
  }

  Map<String, dynamic> toJson() => {
        'email': email,
        'username': username,
        'uid': uid,
        'followers': followers,
        'following': following,
        'profilePhoto': profilePhoto,
        'bio': bio,
        'contacts': contacts
      };
}
