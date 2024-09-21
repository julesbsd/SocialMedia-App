import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socialmedia_app/components/my_drawer.dart';
import 'package:socialmedia_app/controllers/login_or_register.dart';
import 'package:socialmedia_app/controllers/persistance_handler.dart';
import 'package:socialmedia_app/controllers/providers/UserProvider.dart';
import 'package:socialmedia_app/model/user.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // User? _user;
  late UserProvider pUser;

  @override
  void initState() {
    super.initState();
    pUser = Provider.of<UserProvider>(context, listen: false);
    // _getUser();
  }

  // Future<void> _getUser() async {
  //   setState(() {
  //     _user = pUserProvider.getUser;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              PersistanceHandler().delAccessToken();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginOrRegister()),
              );
            },
          ),
        ],
      ),
      drawer: MyDrawer(),
      body: Center(
        child: Text('Bonjour, ${pUser.user.email}2'),
      ),
    );
  }
}
