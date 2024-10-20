import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
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

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;

  RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  var profileImage = '';

  // name, email and password controller
  final TextEditingController emailController =
      TextEditingController(text: "julesbsd@gmail.com");

  final TextEditingController passwordController =
      TextEditingController(text: "password");

  final TextEditingController nameController =
      TextEditingController(text: 'Jules');

  final TextEditingController confirmPasswordController =
      TextEditingController(text: 'password');

  final ImagePicker _picker = ImagePicker();
  File? _image;

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });

      final bytes = await pickedFile.readAsBytes();
      profileImage = base64Encode(bytes);
    }
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
              "Let's create an account for you",
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 25),

            MyTextField(
              hintText: 'Name',
              obscureText: false,
              controller: nameController,
            ),

            const SizedBox(height: 10),
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

            const SizedBox(height: 10),

            MyTextField(
              hintText: 'Password',
              obscureText: true,
              controller: confirmPasswordController,
            ),
            const SizedBox(height: 10),
            if (_image != null)
              Column(
                children: [
                  Image.file(
                    _image!,
                    height: 100,
                    width: 100,
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(25),
                margin: const EdgeInsets.symmetric(horizontal: 25),
                child: Center(
                  child: Text("Choose Profile Image"),
                ),
              ),
            ),
            const SizedBox(height: 25),

            // login button
            GestureDetector(
                onTap: () async {
                  if (nameController.text.isEmpty ||
                      emailController.text.isEmpty ||
                      passwordController.text.isEmpty ||
                      confirmPasswordController.text.isEmpty) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Inscription Failed'),
                          content: Text('Tous les champs sont requis.'),
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
                    return;
                  }

                  if (passwordController.text !=
                      confirmPasswordController.text) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Inscription Failed'),
                          content:
                              Text('Les mos de passes ne correspondent pas.'),
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
                    return;
                  }

                  String body = await JSONHandler().register(
                      nameController.text,
                      emailController.text,
                      passwordController.text,
                      profileImage);

                  Response res = await HttpService()
                      .makePostRequestWithoutToken(postRegister, body);

                  if (res.statusCode == 201) {
                    final Map<String, dynamic> responseData =
                        jsonDecode(res.body);

                    final String token = responseData['token'];
                    await PersistanceHandler().setAccessToken(token);

                    final Map<String, dynamic> userData = responseData['user'];
                    User user = User.fromJson(userData);
                    Provider.of<UserProvider>(context, listen: false)
                        .setUser(user);

                    var getToken = await PersistanceHandler().getAccessToken();
                    User? getUser = await PersistanceHandler().getUser();

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
                          title: Text('Inscription Failed'),
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
                    child: Text("Register"),
                  ),
                )),

            const SizedBox(height: 25),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Already have an account? ',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.primary),
                ),
                GestureDetector(
                  onTap: widget.onTap,
                  child: Text(
                    'Login Now',
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
