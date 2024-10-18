import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:socialmedia_app/model/user.dart';

class UserProvider with ChangeNotifier {
  User user = User(
    name: '',
    email: '',
    posts: [],
    profileImage: '',
    conversations: [],
  );

  void setUser(User newUser) {
    user = newUser;
    notifyListeners();
  }

  User get getUser {
    return user;
  }

  void setConversations(List<dynamic> newConversations) {
    user.conversations = newConversations.cast<Conversation>();
    notifyListeners();
  }

  List<dynamic> get getConversations {
    return user.conversations;
  }

  // void addConversation(String newConversation) {
  //   user.conversations?.add(newConversation);
  //   notifyListeners();
  // }
}
