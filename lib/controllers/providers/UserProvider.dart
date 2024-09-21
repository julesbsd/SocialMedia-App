import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:socialmedia_app/model/user.dart';

class UserProvider with ChangeNotifier {
  User user = User(
    name: '',
    email: '',
    posts: [],
    profileImage: '',
  );

  void setUser(User newUser) {
    user = newUser;
    notifyListeners();
  }

  User get getUser {
    return user;
  }
}
