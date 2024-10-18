import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:socialmedia_app/controllers/login_or_register.dart';
import 'package:socialmedia_app/controllers/persistance_handler.dart';
import 'package:socialmedia_app/controllers/providers/UserProvider.dart';
import 'package:socialmedia_app/global/routes.dart';
import 'package:socialmedia_app/http/http_service.dart';
import 'package:socialmedia_app/model/user.dart';
import 'package:socialmedia_app/pages/discussion_page.dart';
import 'package:socialmedia_app/pages/menu.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  late UserProvider pUser;

  void initState() {
    super.initState();
    _passLoadingScreen();
    pUser = Provider.of<UserProvider>(context, listen: false);
  }

  void _passLoadingScreen() async {
    String? token = await PersistanceHandler().getAccessToken();

    // await Future.delayed(Duration(seconds: 30));
    if (token != null) {
      Response res =
          await HttpService().makePostRequestWithToken(PostLogin, "");
      if (res.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(res.body);
        final Map<String, dynamic> userData = responseData['user'];
        User user = User.fromJson(userData);
        pUser.setUser(user);

        inspect(user);

        // Response conversationRes =
        //     await HttpService().makeGetRequestWithToken(getConversations);

        // if (conversationRes.statusCode == 200) {
        //   List<dynamic> conversations = jsonDecode(conversationRes.body);
        //   pUser.setConversations(conversations);
        // }

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Menu()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginOrRegister()),
        );
      }
    } else {
      print("No token found");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginOrRegister()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
