import 'dart:convert';

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
import 'package:socialmedia_app/pages/home_page.dart';

class LoginPage extends StatelessWidget {
  // email and password controller
  final TextEditingController emailController =
      TextEditingController(text: "julesbsd@gmail.com");

  final TextEditingController passwordController =
      TextEditingController(text: "password");

  // Tap to go to register page
  final void Function()? onTap;

  LoginPage({super.key, required this.onTap});

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

                    // Créer un objet User à partir des données reçues
                    User user = User.fromJson(userData);

                    // Save token and user data using PersistenceHandler
                    await PersistanceHandler().setAccessToken(token);
                    Provider.of<UserProvider>(context, listen: false)
                        .setUser(user);

                    // Vérifier les données sauvegardées
                    var getToken = await PersistanceHandler().getAccessToken();
                    User? getUser = await PersistanceHandler().getUser();

                    print('Token: $getToken');
                    print('User: ${user.name}');

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
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
                  onTap: onTap,
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
