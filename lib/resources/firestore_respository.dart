import 'package:firebase_auth/firebase_auth.dart';
import 'package:halenest/models/message_model.dart';
import 'package:halenest/models/user_model.dart';
import 'package:halenest/resources/firestore_methods.dart';

class FirebaseRespository {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirestoreMethods _firebaseMethods = FirestoreMethods();
  Future<void> addMessageToDb(
          Message message, UserModel sender, UserModel receiver) =>
      _firebaseMethods.addMessageToDb(message, sender, receiver);
}
