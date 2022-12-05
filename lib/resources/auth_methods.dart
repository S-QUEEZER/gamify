import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:halenest/models/user_model.dart';
import 'package:halenest/resources/storage_method.dart';
import 'package:halenest/util/utils.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<String> signInWithFacebook(BuildContext context) async {
    String res = "some error occurred";
    try {
      final LoginResult loginResult = await FacebookAuth.instance.login();

      final OAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(loginResult.accessToken!.token);

      UserCredential userCredential =
          await _auth.signInWithCredential(facebookAuthCredential);
      if (userCredential.user != null) {
        if (userCredential.additionalUserInfo!.isNewUser) {
          String uid = userCredential.user!.uid;
          final user = FirebaseAuth.instance.currentUser!;
          UserModel googleUser = UserModel(
            username: user.displayName!,
            email: user.email!,
            uid: uid,
            bio: '',
            followers: [],
            following: [],
            profilePhoto: user.photoURL!,
          );
          await _firebaseFirestore
              .collection('users')
              .doc(userCredential.user!.uid)
              .set(googleUser.toJson());
        }
      }
      res = "success";
    } on FirebaseAuthException catch (e) {
      showSnackBar(
          e.message.toString(), context); // Displaying the error message
    }
    return res;
  }

  Future<String> signInWithGoogle(BuildContext context) async {
    String res = "Something occured";
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      if (googleAuth?.accessToken != null && googleAuth?.idToken != null) {
        // Create a new credential
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );
        UserCredential userCredential =
            await _auth.signInWithCredential(credential);
        if (userCredential.user != null) {
          if (userCredential.additionalUserInfo!.isNewUser) {
            String uid = userCredential.user!.uid;
            final user = FirebaseAuth.instance.currentUser!;
            UserModel googleUser = UserModel(
              username: user.displayName!,
              email: user.email!,
              uid: uid,
              bio: '',
              followers: [],
              following: [],
              profilePhoto: 'https://i.stack.imgur.com/l60Hf.png',
            );
            await _firebaseFirestore
                .collection('users')
                .doc(userCredential.user!.uid)
                .set(googleUser.toJson());
          }
        }

        res = "success";
      }
    } on FirebaseAuthException catch (e) {
      showSnackBar(
          e.message.toString(), context); // Displaying the error message
    }
    return res;
  }

  Future<String> uploadPhoto({required Uint8List file}) async {
    String res = 'Some error occured';
    try {
      if (file.isNotEmpty) {
        String photoUrl = await StorageMethod()
            .uploadImagetoStorage('profilePics', file, false);
        var docUser = FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid);
        docUser.update({'profilePhoto': photoUrl});
        res = 'success';
      }
    } catch (error) {
      res = error.toString();
    }

    return res;
  }

  Future<String> skipPhoto() async {
    String res = 'Some error occured';
    try {
      var docUser = FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid);
      docUser.update({'profilePhoto': 'https://i.stack.imgur.com/l60Hf.png'});
      res = 'success';
    } catch (error) {
      res = error.toString();
    }

    return res;
  }

  //* SIGN UP METHOD

  Future<String> signUp(
      {required String email,
      required String password,
      String? bio,
      required String username}) async {
    String res = "Some Error Occured";
    try {
      if (email.isNotEmpty || password.isNotEmpty || username.isNotEmpty) {
        // * creates an user
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        // * register the user in database
        String uid = cred.user!.uid;
        UserModel user = UserModel(
          username: username,
          email: email,
          uid: uid,
          bio: bio,
          followers: [],
          following: [],
          profilePhoto: 'https://i.stack.imgur.com/l60Hf.png',
        );
        await _firebaseFirestore
            .collection('users')
            .doc(cred.user!.uid)
            .set(user.toJson());

        res = "success";
      }
    } on FirebaseAuthException catch (err) {
      if (err.code == 'email-already-in-use') {
        res = "email already in use";
      } else if (err.code == "weak-password") {
        res = 'Create a strong password';
      } else {
        res = "Email id not valid";
      }
    } catch (error) {
      res = error.toString();
    }
    return res;
  }

  //* SIGN IN METHOD

  Future<String> signin(
      {required String email, required String password}) async {
    String res = "Some error occurred";

    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = "success";
      } else {
        res = "Please input all fields";
      }
    } catch (error) {
      res = error.toString();
    }

    return res;
  }

  //* SIGN OUT METHOD
  Future<void> signout() async {
    await _auth.signOut();
  }

  Future<UserModel> getDetails() async {
    User currentUser = _auth.currentUser!;
    DocumentSnapshot snapshot =
        await _firebaseFirestore.collection('users').doc(currentUser.uid).get();
    return UserModel.fromSnap(snapshot);
  }
}
