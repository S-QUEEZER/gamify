class StoryModel {
  String username;
  String photoUrl;
  String storyUrl;
  String uid;
  DateTime createdAt;
  List isSeenBy;

  StoryModel(
      {required this.createdAt,
      required this.photoUrl,
      required this.storyUrl,
      required this.uid,
      required this.isSeenBy,
      required this.username});

  Map<String, dynamic> toJson() => {
        "username": username,
        "photoUrl": photoUrl,
        "storyUrl": storyUrl,
        "uid": uid,
        "createdAt": createdAt,
        "isSeenBy": isSeenBy
      };
}
