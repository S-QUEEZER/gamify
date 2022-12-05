class ForumModel {
  final String email;
  final String uid;
  final String username;
  final String profilePhoto;
  final String postId;
  final String question;
  final List? tags;
  final DateTime datePublished;
  ForumModel({
    required this.email,
    required this.uid,
    required this.username,
    required this.profilePhoto,
    required this.postId,
    required this.question,
    this.tags,
    required this.datePublished,
  });

  Map<String, dynamic> toJson() => {
        'email': email,
        'uid': uid,
        'username': username,
        'profilePhoto': profilePhoto,
        'postId': postId,
        'description': question,
        'tags': tags,
        'datetime': datePublished
      };
}
