import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:socialmedia_app/components/my_button.dart';
import 'package:socialmedia_app/components/my_textfield.dart';
import 'package:socialmedia_app/global/routes.dart';
import 'package:socialmedia_app/http/http_service.dart';
import 'package:socialmedia_app/model/user.dart';
import 'package:socialmedia_app/controllers/json_handler.dart';
import 'package:socialmedia_app/controllers/persistance_handler.dart';
import 'package:socialmedia_app/controllers/providers/UserProvider.dart';
import 'package:socialmedia_app/pages/discussion_page.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;

  LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late UserProvider pUser;

  // email and password controller
  final TextEditingController emailController =
      TextEditingController(text: "julesbsd@gmail.com");

  final TextEditingController passwordController =
      TextEditingController(text: "password");

  @override
  void initState() {
    super.initState();
    pUser = Provider.of<UserProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // logo
            Icon(
              Icons.message,
              size: 60,
              color: Theme.of(context).colorScheme.primary,
            ),

            const SizedBox(height: 50),
            // welcome msg
            Text(
              'Welcome to Social Media',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 25),

            // email textfield
            MyTextField(
              hintText: 'Email',
              obscureText: false,
              controller: emailController,
            ),

            const SizedBox(height: 10),

            // password textfield
            MyTextField(
              hintText: 'Password',
              obscureText: true,
              controller: passwordController,
            ),

            const SizedBox(height: 25),

            // login button
            GestureDetector(
                onTap: () async {
                  String body = await JSONHandler()
                      .login(emailController.text, passwordController.text);

                  Response res = await HttpService()
                      .makePostRequestWithoutToken(PostLogin, body);

                  if (res.statusCode == 200) {
                    final Map<String, dynamic> responseData =
                        jsonDecode(res.body);

                    // Extract token and user data
                    final String token = responseData['token'];
                    final Map<String, dynamic> userData = responseData['user'];

                    User user = User.fromJson(userData);
                    // inspect(user);

                    await PersistanceHandler().setAccessToken(token);
                    pUser.setUser(user);

                    // Vérifier les données sauvegardées
                    var getToken = await PersistanceHandler().getAccessToken();
                    User? getUser = await pUser.getUser;
                    // inspect(getUser);
                    if (res.statusCode == 200) {
                      print('succes 200');
                      Response conversationRes = await HttpService()
                          .makeGetRequestWithToken(getConversations);

                      if (conversationRes.statusCode == 200) {
                        List<dynamic> conversations =
                            jsonDecode(conversationRes.body);
                        // inspect('conversations:' + conversationRes.body);
                        pUser.setConversations(conversations);
                      }

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => DiscussionPage()),
                      );
                    }
                    print('Token: $getToken');
                    print('User: ${user.name}');

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => DiscussionPage()),
                    );
                  } else {
                    // Handle error response
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Login Failed'),
                          content: Text(
                              'Please check your email and password and try again.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(25),
                  margin: const EdgeInsets.symmetric(horizontal: 25),
                  child: Center(
                    child: Text("Login"),
                  ),
                )),

            const SizedBox(height: 25),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Not a member? ',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.primary),
                ),
                GestureDetector(
                  onTap: widget.onTap,
                  child: Text(
                    'Register Now',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
