import 'package:cloud_firestore/cloud_firestore.dart';

Map abc = {
  'mango': 2,
};

class Message {
  String senderId;
  String receiverId;
  String type;
  String message;
  FieldValue timestamp;
  String? photoUrl;

  Message(
      {required this.senderId,
      required this.receiverId,
      required this.type,
      required this.message,
      required this.timestamp});

  //Will be only called when you wish to send an image
  Message.imageMessage(
      {required this.senderId,
      required this.receiverId,
      required this.message,
      required this.type,
      required this.timestamp,
      this.photoUrl});

  Map<String, dynamic> toJson() => {
        'sendId': senderId,
        'receiverId': receiverId,
        'message': message,
        'type': type,
        'timestamp': timestamp,
      };
}
