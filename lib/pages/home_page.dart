import 'package:flutter/material.dart';
import 'package:socialmedia_app/controllers/persistance_handler.dart';
import 'package:socialmedia_app/model/user.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User? _user;

  void initState() {
    super.initState();
    _getUser();
  }

  Future<void> _getUser() async {
    User user = (await PersistanceHandler().getUser())!;
    setState(() {
      _user = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Center(
        child: _user == null
            ? const CircularProgressIndicator()
            : Text('Bonjour, ${_user!.name}2'),
      ),
    );
  }
}
