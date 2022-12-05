class Status {
  final String uid;
  final String username;

  final List<String> photoUrl;
  final DateTime createdAt;
  final String profilePic;
  final String statusId;

  Status({
    required this.uid,
    required this.username,
    required this.photoUrl,
    required this.createdAt,
    required this.profilePic,
    required this.statusId,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'username': username,
      'photoUrl': photoUrl,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'profilePic': profilePic,
      'statusId': statusId,
    };
  }

  factory Status.fromMap(Map<String, dynamic> map) {
    return Status(
      uid: map['uid'] ?? '',
      username: map['username'] ?? '',
      photoUrl: List<String>.from(map['photoUrl']),
      createdAt: DateTime.now(),
      profilePic: map['profilePic'] ?? '',
      statusId: map['statusId'] ?? '',
    );
  }
}
