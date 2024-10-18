import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socialmedia_app/components/my_drawer.dart';
import 'package:socialmedia_app/controllers/login_or_register.dart';
import 'package:socialmedia_app/controllers/persistance_handler.dart';
import 'package:socialmedia_app/controllers/providers/UserProvider.dart';
import 'package:socialmedia_app/model/user.dart';

class DiscussionPage extends StatefulWidget {
  const DiscussionPage({super.key});

  @override
  State<DiscussionPage> createState() => _DiscussionPageState();
}

class _DiscussionPageState extends State<DiscussionPage> {
  // User? _user;
  late UserProvider pUser;
  late List<Conversation> _conversations = [];
  @override
  void initState() {
    super.initState();
    pUser = Provider.of<UserProvider>(context, listen: false);
    _getConversations();
  }

  Future<void> _getConversations() async {
    setState(() {
      _conversations = pUser.getConversations.cast<Conversation>();
    });
    inspect(_conversations);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _conversations.isNotEmpty
            ? ListView.builder(
                itemCount: _conversations.length,
                itemBuilder: (context, index) {
                  final conversation = _conversations[index];
                  final lastMessage = conversation.messages.isNotEmpty
                      ? conversation.messages.last.content
                      : "Aucun message";

                  return Card(
                    child: ListTile(
                      title: Text(
                        conversation.participants
                            .map((p) => p.name)
                            .join(", "), // List participants' names
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(lastMessage), // Display the last message
                      onTap: () {
                        // Action on tap, e.g., navigate to chat details
                      },
                    ),
                  );
                },
              )
            : const Text('Aucune conversation disponible'),
      ),
    );
  }
}
