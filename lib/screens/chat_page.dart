import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:remote_health/defaults/chat_tile.dart';
import 'package:remote_health/models/user_profile.dart';
import 'package:remote_health/screens/chat_screen.dart';
import 'package:remote_health/services/database_service.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late DatabaseService _databaseService;
  final GetIt _getIt = GetIt.instance;
  late String excludeUid;

  @override
  void initState() {
    super.initState();
    _databaseService = _getIt.get<DatabaseService>();

    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      excludeUid = user.uid;
    } else {
      excludeUid = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 15.0,
          vertical: 20.0,
        ),
        child: _chatsList(),
      ),
    );
  }

  Widget _chatsList() {
    return StreamBuilder(
        stream: _databaseService.getUserProfiles(excludeUid: excludeUid),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text("Unable to Load Data."),
            );
          }
          if (snapshot.hasData && snapshot.data != null) {
            final users = snapshot.data!.docs;
            return ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  UserProfile? user = users[index].data() as UserProfile?;
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10.0,
                    ),
                    child: ChatTile(
                      userId: user!.uid!,
                      userProfile: user!,
                      onTap: () async {
                        final chatExits =
                            await _databaseService.checkChatExists(
                          excludeUid,
                          user.uid!,
                        );
                        if (!chatExits) {
                          await _databaseService.createNewChat(
                              excludeUid, user.uid!);
                        }
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatScreen(
                              chatUser: user,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                });
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
