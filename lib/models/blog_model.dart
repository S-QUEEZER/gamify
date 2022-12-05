// ignore_for_file: prefer_typing_uninitialized_variables

class BlogModel {
  final String email;
  final String uid;
  final String username;
  final String profilePhoto;
  final likes;
  final String postId;
  final String description;
  final String thumbnail;
  final String title;
  final List? tags;
  final DateTime datePublished;
  final int popularity;
  BlogModel(
      {required this.email,
      required this.uid,
      required this.username,
      required this.profilePhoto,
      this.likes,
      required this.postId,
      required this.description,
      required this.thumbnail,
      this.tags,
      required this.datePublished,
      required this.title,
      required this.popularity});

  Map<String, dynamic> toJson() => {
        'email': email,
        'uid': uid,
        'username': username,
        'profilePhoto': profilePhoto,
        'likes': likes,
        'postId': postId,
        'description': description,
        'feedphoto': thumbnail,
        'tags': tags,
        'datetime': datePublished,
        'title': title,
        'popularity': popularity
      };
}
