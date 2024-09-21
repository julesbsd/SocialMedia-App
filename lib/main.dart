import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socialmedia_app/controllers/login_or_register.dart';
import 'package:socialmedia_app/pages/loading_screen.dart';
import 'package:socialmedia_app/pages/register_page.dart';
import 'package:socialmedia_app/theme/light_mode.dart';
import 'controllers/providers/UserProvider.dart';
import 'pages/login_page.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => UserProvider()), // Ajout de votre UserProvider ici
      ],
      child: MyApp(), // Votre classe principale de l'application
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoadingScreen(),
      theme: lightMode,
    );
  }
}
// lancer loading screen ou véririfer le token 
// initstate 