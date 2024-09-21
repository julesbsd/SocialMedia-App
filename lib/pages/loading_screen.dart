import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:socialmedia_app/controllers/login_or_register.dart';
import 'package:socialmedia_app/controllers/persistance_handler.dart';
import 'package:socialmedia_app/global/routes.dart';
import 'package:socialmedia_app/http/http_service.dart';
import 'package:socialmedia_app/pages/home_page.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  void initState() {
    super.initState();
    _passLoadingScreen();
  }

  void _passLoadingScreen() async {
    String? token = await PersistanceHandler().getAccessToken();
    print('token passLoadingScreen:  $token');
    if (token != null) {
      Response res =
          await HttpService().makePostRequestWithToken(PostLogin, token);

      if (res.statusCode == 200) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginOrRegister()),
        );
      }

      print("Token retrieved: $token");
      print("autologin response: ${res.statusCode}");
    } else {
      print("No token found");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginOrRegister()),
      );
    }
  }

  Future<String?> _getTokenFromPersistence() async {
    // Replace this with your actual code to retrieve the token
    // For example, using SharedPreferences:
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // return prefs.getString('token');
    return null; // Placeholder implementation
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
