class FeedModel {
  final String email;
  final String uid;
  final String username;
  final String profilePhoto;
  final likes;
  final String postId;
  final String description;
  var feedphoto;
  final List? tags;
  final DateTime datePublished;
  FeedModel({
    required this.email,
    required this.uid,
    required this.username,
    required this.profilePhoto,
    this.likes,
    required this.postId,
    required this.description,
    required this.feedphoto,
    this.tags,
    required this.datePublished,
  });

  Map<String, dynamic> toJson() => {
        'email': email,
        'uid': uid,
        'username': username,
        'profilePhoto': profilePhoto,
        'likes': likes,
        'postId': postId,
        'description': description,
        'feedphoto': feedphoto,
        'tags': tags,
        'datetime': datePublished
      };
}
