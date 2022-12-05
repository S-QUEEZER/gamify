// ignore_for_file: unused_field

import 'package:flutter/cupertino.dart';

import 'package:halenest/models/user_model.dart';
import 'package:halenest/resources/auth_methods.dart';

class UserProvider extends ChangeNotifier {
  final AuthMethods _authMethods = AuthMethods();

  UserModel _user = UserModel(
      email: '',
      followers: [],
      following: [],
      profilePhoto:
          'https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
      uid: '',
      username: '');
  UserModel get getUser => _user;
  Future<void> refreshUser() async {
    UserModel user = await _authMethods.getDetails();
    _user = user;
    notifyListeners();
  }
}
